//
//  KKViewController.m
//  KKPinCodeTextField
//
//  Created by Amirzhan on 03/13/2018.
//  Copyright (c) 2018 Amirzhan. All rights reserved.
//

#import "KKViewController.h"
#import "KKPinCodeTextField.h"

@interface KKViewController()

@property (strong, nonatomic) IBOutlet KKPinCodeTextField *textField;

@end

@implementation KKViewController

- (IBAction)continueButtonPressed:(UIButton *)sender {
    [self.textField clearText];
}

@end
