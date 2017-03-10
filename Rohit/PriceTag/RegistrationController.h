//
//  RegistrationController.h
//  PriceTag
//
//  Created by Ranosys on 06/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
@interface RegistrationController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,BSKeyboardControlsDelegate,FBLoginViewDelegate>
{

    __weak IBOutlet UIButton *termsAndCondition_Btn;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageGallery;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *passwordField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;
@property (weak, nonatomic) IBOutlet UITextField *passwordField3;
@property (weak, nonatomic) IBOutlet UITextField *passwordField4;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField1;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField2;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField3;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField4;

@property (weak, nonatomic) IBOutlet UIButton *termOfUseOutlet;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyOutlet;

- (IBAction)verifiedCode:(UIButton *)sender;
- (IBAction)submit:(UIButton *)sender;
- (IBAction)takeAndSelectPhoto:(UIButton *)sender;

- (IBAction)signUpWithFB:(UIButton *)sender;

- (IBAction)terms_conditions:(id)sender;
- (IBAction)privacy_policy:(id)sender;

@end
