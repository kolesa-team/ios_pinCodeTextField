//
//  KKPinCodeTextField.h
//  KolesaKz
//
//  Created by Amirzhan on 30.06.17.
//  Copyright © 2017 Eugene Valeyev. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/// TextField for verification codes
@interface KKPinCodeTextField : UITextField

/// Verification code length. Default value is 4
@property (assign, nonatomic) IBInspectable NSUInteger digitsCount;

/// Bottom borders height. Default value is 4
@property (assign, nonatomic) IBInspectable CGFloat borderHeight;

/// Spacing between bottom borders. Default value is 10
@property (assign, nonatomic) IBInspectable CGFloat bordersSpacing;

/// Bottom border color when digit is filled. Default value is UIColor.lightGrayColor
@property (strong, nonatomic) IBInspectable UIColor *filledDigitBorderColor;

/// Bottom border color when digit is empty. Default value is UIColor.redColor
@property (strong, nonatomic) IBInspectable UIColor *emptyDigitBorderColor;

/// Clears all text
- (void)clearText;

@end
