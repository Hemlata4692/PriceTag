//
//  AppDelegate.h
//  PriceTag
//
//  Created by Sumit on 05/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "TutorialViewController.h"
#import "LoginController.h"
#import "GAI.h"
#import "GAIFields.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *lat;
    NSString *lon;
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) UINavigationController *navigationController;
// Methos for show indicator
- (void) ShowIndicator;

//Method for stop indicator
- (void)StopIndicator;
@property (strong, nonatomic) NSNumber *userId;

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

@property (strong, nonatomic) NSString *DBemail;
@property (strong, nonatomic) NSString *DBuserName;
@property (strong, nonatomic) NSString *DBuserFbId;
@property (strong, nonatomic) UIImage *DBimage;

@property (strong, nonatomic) UITabBarController *tabbarcontroller;

@property (assign, nonatomic) BOOL CheckController;
@property(nonatomic,assign) bool imageCheck;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property(nonatomic,retain)NSString * deviceToken;

@end
