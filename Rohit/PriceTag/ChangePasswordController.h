//
//  ChangePasswordController.h
//  PriceTag
//
//  Created by Ranosys on 14/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface ChangePasswordController : UIViewController<UITextFieldDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField1;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField2;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField3;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField4;

@property (weak, nonatomic) IBOutlet UITextField *NPasswordField1;
@property (weak, nonatomic) IBOutlet UITextField *NPasswordField2;
@property (weak, nonatomic) IBOutlet UITextField *NPasswordField3;
@property (weak, nonatomic) IBOutlet UITextField *NPasswordField4;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField1;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField2;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField3;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField4;

- (IBAction)submit:(UIButton *)sender;
- (IBAction)backButton:(UIButton *)sender;

@end
