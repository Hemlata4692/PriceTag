//
//  MyProfileController.h
//  PriceTag
//
//  Created by Ranosys on 07/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


#import "LoginController.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class LoginController;

@interface MyProfileController : UIViewController<MFMailComposeViewControllerDelegate>
{
    
    __weak IBOutlet UIButton *helpAndSupport_Btn;
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UIView *timerpopup_bg;
    __weak IBOutlet UIView *timer_popup;
    __weak IBOutlet UIImageView *separator3;
    
}
@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButtonOutlet;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;
@property (weak, nonatomic) IBOutlet UIImageView *separator1;
@property (weak, nonatomic) IBOutlet UIImageView *separator2;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UILabel *days;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UILabel *minutes;
@property (weak, nonatomic) IBOutlet UILabel *seconds;

@property (weak, nonatomic) NSString *todayDate;
@property (weak, nonatomic) NSString *endingDate;
@property(nonatomic,retain)NSString  * adminEmailId;

- (IBAction)editProfile:(UIButton *)sender;
- (IBAction)resetPassword:(UIButton *)sender;
- (IBAction)rightBarButton:(UIButton *)sender;
- (IBAction)logout:(UIButton *)sender;

@property (strong, nonatomic) UINavigationController *naviController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, retain) LoginController *loginObj;

@property(nonatomic, retain) UIImage *defaultImage;
@end
