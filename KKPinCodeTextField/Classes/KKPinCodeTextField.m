//
//  KKPinCodeTextField.m
//  KolesaKz
//
//  Created by Amirzhan on 30.06.17.
//  Copyright © 2017 Eugene Valeyev. All rights reserved.
//

#import "KKPinCodeTextField.h"

static const CGFloat KKTextFieldPadding = 20;
static const CGFloat KKDigitToBorderSpace = 10;

static const NSUInteger KKDefaultDigitsCount = 4;
static const CGFloat KKDefaultBorderHeight = 4;
static const CGFloat KKDefaultBordersSpacing = 10;

@interface KKPinCodeTextField() <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray <CALayer *> *borders;

@end

@implementation KKPinCodeTextField

@synthesize digitsCount = _digitsCount;
@synthesize borderHeight = _borderHeight;
@synthesize bordersSpacing = _bordersSpacing;
@synthesize filledDigitBorderColor = _filledDigitBorderColor;
@synthesize emptyDigitBorderColor = _emptyDigitBorderColor;

#pragma mark Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    [self setupBorders];
    [self configureDefaultValues];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setupBorders {
    for (CALayer *border in self.borders) {
        [border removeFromSuperlayer];
    }
    
    self.borders = [NSMutableArray new];
    
    for (int i = 0; i < self.digitsCount; i++) {
        CALayer *border = [CALayer layer];
        border.borderColor = self.emptyDigitBorderColor.CGColor;
        border.borderWidth = self.borderHeight;
        
        [self.borders addObject:border];
        [self.layer addSublayer:border];
    }
}

- (void)configureDefaultValues {
    self.delegate = self;
    self.adjustsFontSizeToFitWidth = NO;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.textAlignment = NSTextAlignmentLeft;
    self.borderStyle = UITextBorderStyleNone;
}

#pragma mark Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.borders.count; i++) {
        CALayer *border = self.borders[i];
        CGFloat xPos = ([self borderWidth] + self.bordersSpacing) * i + KKTextFieldPadding;
        border.frame = CGRectMake(xPos, CGRectGetHeight(self.frame) - self.borderHeight, [self borderWidth], self.borderHeight);
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.height += self.borderHeight * 2 + KKDigitToBorderSpace;
    
    return size;
}

- (BOOL)becomeFirstResponder {
    [self configureInitialSpacingAtIndex:self.text.length];
    
    return [super becomeFirstResponder];
}

#pragma mark Public methods

- (void)clearText {
    self.text = nil;
    for (int i = 0; i < self.borders.count; i++) {
        CALayer *border = self.borders[i];
        border.borderColor = self.emptyDigitBorderColor.CGColor;
    }
    
    [self configureInitialSpacingAtIndex:0];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger length = [currentString length];
    
    if (![self isOnlyNumbersString:string]) {
        return NO;
    }
    
    if (length > self.digitsCount) {
        return NO;
    }
    
    return YES;
}

#pragma mark Actions

- (void)textFieldDidChange:(UITextField *)sender {
    NSUInteger length = sender.text.length;
    [self configureBorderColorAtIndex:length];
    [self configureInitialSpacingAtIndex:length];
    [self addSpacingToTextWithLength:length];
}

- (void)configureBorderColorAtIndex:(NSUInteger)index {
    if (index == 0) {
        self.borders[0].borderColor = self.emptyDigitBorderColor.CGColor;
    } else if (index == self.digitsCount) {
        self.borders[self.digitsCount - 1].borderColor = self.filledDigitBorderColor.CGColor;
    } else {
        self.borders[index].borderColor = self.emptyDigitBorderColor.CGColor;
        self.borders[index - 1].borderColor = self.filledDigitBorderColor.CGColor;
    }
}

- (void)configureInitialSpacingAtIndex:(NSUInteger)index {
    if (index == 0) {
        [self addInitialSpacing:KKTextFieldPadding];
    } else if (index == 1) {
        NSDictionary *userAttributes = @{NSFontAttributeName: self.font};
        CGFloat textWidth = [self.text sizeWithAttributes: userAttributes].width;
        CGFloat spacing = ([self borderWidth] - textWidth) / 2 + KKTextFieldPadding;
        [self addInitialSpacing:spacing];
    }
}

- (void)addSpacingToTextWithLength:(NSUInteger)length {
    if (length == 0) {
        return;
    }
    
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    
    BOOL isLastDigit = length == self.digitsCount;
    CGFloat nextBorderSpacing = isLastDigit ? 0 : self.bordersSpacing;
    
    CGFloat lastSpacing = [self spacingToDigitAtIndex:length - 1 attributedText:attributedString];
    CGFloat spacing = lastSpacing + nextBorderSpacing;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(length - 1, 1)];
    
    if (length > 1) {
        CGFloat preLastSpacing = [self spacingToDigitAtIndex:length - 2 attributedText:attributedString];
        CGFloat spacing = preLastSpacing + lastSpacing + self.bordersSpacing;
        [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(length - 2, 1)];
    }
    
    self.attributedText = [attributedString copy];
}

- (CGFloat)spacingToDigitAtIndex:(NSUInteger)index attributedText:(NSMutableAttributedString *)attributedString {
    NSDictionary *userAttributes = @{NSFontAttributeName: self.font};
    
    NSString *text = [attributedString.string substringWithRange:NSMakeRange(index, 1)];
    CGFloat textWidth = [text sizeWithAttributes:userAttributes].width;
    CGFloat textSpacing = ([self borderWidth] - textWidth) / 2;
    
    return textSpacing;
}

#pragma mark Property getters/setters

- (NSUInteger)digitsCount {
    if (!_digitsCount) {
        return KKDefaultDigitsCount;
    }
    
    return _digitsCount;
}

- (void)setDigitsCount:(NSUInteger)digitsCount {
    _digitsCount = digitsCount;
    
    [self clearText];
    [self setupBorders];
}

- (CGFloat)borderHeight {
    if (!_borderHeight) {
        return KKDefaultBorderHeight;
    }
    
    return _borderHeight;
}

- (void)setBorderHeight:(CGFloat)borderHeight {
    _borderHeight = borderHeight;
    
    [self clearText];
    [self setupBorders];
}

- (CGFloat)bordersSpacing {
    if (!_bordersSpacing) {
        return KKDefaultBordersSpacing;
    }
    
    return _bordersSpacing;
}

- (void)setBordersSpacing:(CGFloat)bordersSpacing {
    _bordersSpacing = bordersSpacing;
    
    [self clearText];
    [self layoutIfNeeded];
}

- (UIColor *)filledDigitBorderColor {
    if (!_filledDigitBorderColor) {
        return UIColor.lightGrayColor;
    }
    
    return _filledDigitBorderColor;
}

- (void)setFilledDigitBorderColor:(UIColor *)filledDigitBorderColor {
    _filledDigitBorderColor = filledDigitBorderColor;
    
    [self configureBorderColors];
}

- (UIColor *)emptyDigitBorderColor {
    if (!_emptyDigitBorderColor) {
        return UIColor.redColor;
    }
    
    return _emptyDigitBorderColor;
}

- (void)setEmptyDigitBorderColor:(UIColor *)emptyDigitBorderColor {
    _emptyDigitBorderColor = emptyDigitBorderColor;
    
    [self configureBorderColors];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    super.delegate = self;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    super.adjustsFontSizeToFitWidth = NO;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    super.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    super.textAlignment = NSTextAlignmentLeft;
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle {
    super.borderStyle = UITextBorderStyleNone;
}

#pragma mark Private methods

- (CGFloat)borderWidth {
    CGFloat totalSpacing = (self.digitsCount - 1) * self.bordersSpacing;
    return (CGRectGetWidth(self.frame) - KKTextFieldPadding * 2 - totalSpacing) / self.digitsCount;
}

- (void)addInitialSpacing:(CGFloat)width {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = paddingView;
}

- (BOOL)isOnlyNumbersString:(NSString *)string {
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [string rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

- (void)configureBorderColors {
    for (CALayer *border in self.borders) {
        BOOL isFilled = self.text.length > [self.borders indexOfObject:border];
        border.borderColor = isFilled ? self.filledDigitBorderColor.CGColor : self.emptyDigitBorderColor.CGColor;
    }
}

@end
