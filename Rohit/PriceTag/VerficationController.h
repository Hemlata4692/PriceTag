//
//  VerficationController.h
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface VerficationController : UIViewController<UITextFieldDelegate,BSKeyboardControlsDelegate>

- (IBAction)submit:(UIButton *)sender;
- (IBAction)backButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITabBarController *tabbarcontroller;
@property(nonatomic, retain) NSString *email;
@end
