//
//  LoginController.h
//  PriceTag
//
//  Created by Ranosys on 05/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "BSKeyboardControls.h"
@interface LoginController : UIViewController<UITextFieldDelegate,FBLoginViewDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *enterPassLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *passwordField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;
@property (weak, nonatomic) IBOutlet UITextField *passwordField3;
@property (weak, nonatomic) IBOutlet UITextField *passwordField4;
@property (weak, nonatomic) IBOutlet UIButton *submitOutlet;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordOutlet;

- (IBAction)submit:(UIButton *)sender;
- (IBAction)forgotPass:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassOutler;

- (IBAction)loginWithFacebook:(UIButton *)sender;
- (IBAction)registrationWithEmail:(UIButton *)sender;

@property (strong, nonatomic) UITabBarController *tabbarcontroller;

@property(nonatomic, retain) NSString *user_name;
@property(nonatomic, retain) NSString *user_email;
@property(nonatomic, retain) NSString *user_gender;
@property(nonatomic, retain) UIImage *profilePic;
@property(nonatomic, retain)  NSData *data;
@property(nonatomic, retain) NSURL *url;
@property (strong,nonatomic) NSString *imageNameFB;


@end
