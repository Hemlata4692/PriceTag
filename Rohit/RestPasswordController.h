//
//  RestPasswordController.h
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

@interface RestPasswordController : UIViewController<UITextFieldDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *verCode;
@property (weak, nonatomic) IBOutlet UITextField *passwordField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;
@property (weak, nonatomic) IBOutlet UITextField *passwordField3;
@property (weak, nonatomic) IBOutlet UITextField *passwordField4;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField1;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField2;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField3;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField4;

@property(nonatomic, retain) NSString *email;

- (IBAction)submit:(UIButton *)sender;

@end
