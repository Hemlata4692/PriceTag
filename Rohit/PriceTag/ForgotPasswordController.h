//
//  ForgotPasswordController.h
//  PriceTag
//
//  Created by Ranosys on 07/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface ForgotPasswordController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
- (IBAction)submit:(UIButton *)sender;
- (IBAction)alreadyCode:(UIButton *)sender;

@end
