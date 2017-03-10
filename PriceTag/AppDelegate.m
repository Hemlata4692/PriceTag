//
//  AppDelegate.m
//  PriceTag
//
//  Created by Sumit on 05/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"


@implementation AppDelegate
//GAI tracker id declaration
id<GAITracker> tracker;

@synthesize navigationController,userId,DBemail,DBuserName,DBimage,DBuserFbId,tabbarcontroller,CheckController,locationManager,imageCheck,deviceToken;

//Activity indicator action
- (void) ShowIndicator
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        
        hud.dimBackground=YES;
        hud.labelText=@"Loading...";

    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.dimBackground=YES;
        hud.labelText=@"Loading...";

    }
}

//Method for stop indicator
- (void)StopIndicator
{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    self.deviceToken = token;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    //NSLog(@"did failtoRegister and testing : %@",str);
    
}

//This method is called every time when ever the app is runned
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Google analytics implementation
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // 2
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    
    // 3
    [GAI sharedInstance].dispatchInterval = 5;
    
    // 4
    tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-54270146-1"];

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString = [prefs stringForKey:@"checkLoginText"];
    int myUserId =(int) [prefs integerForKey:@"checkUserId"];
    
    userId=nil;
    DBemail=@"";
    DBuserFbId=@"";
    DBuserName=@"";
    DBimage=nil;
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Bariol-Regular" size:16.0]}];
    //set navigation bar button color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Bariol-Regular" size:18.0],NSFontAttributeName,nil]forState:UIControlStateNormal];
    self.navigationController = (UINavigationController *)self.window.rootViewController;
    
    if ((myString != nil) && (myUserId != 0) )
    {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        tabbarcontroller=[sb instantiateViewControllerWithIdentifier:@"UITabBarController"];
    
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:tabbarcontroller];
    }
    
    else
    {
        
    //BOOL isTutorialRootView = [[NSUserDefaults standardUserDefaults]boolForKey:@"rootView"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.navigationController = (UINavigationController *)[self.window rootViewController];
//    if(!isTutorialRootView)
//    {
//    //If the app is installed first time this screen will apper first
//        TutorialViewController * objTutorial = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
//         [self.navigationController setViewControllers: [NSArray arrayWithObject: objTutorial]
//                                                                                        animated: YES];
//    
//    }
//    else
//    {
    //Once the user is logged in login screen will appear
        LoginController * objLogin = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
        [self.navigationController setViewControllers: [NSArray arrayWithObject: objLogin]
                                             animated: YES];
    
    //}}
   application.applicationIconBadgeNumber = 0;
    }
    return YES;
}


#pragma mark-facebook
//Facebook delegate
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];
}

#pragma mark - end
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    application.applicationIconBadgeNumber = 0;
    
    
    
    //self.textView.text = [userInfo description];
    
    
    // We can determine whether an application is launched as a result of the user tapping the action
    
    // button or whether the notification was delivered to the already-running application by examining
    
    // the application state.
    
    if (application.applicationState == UIApplicationStateActive)
        
    {
        
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    }
    
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Public method implementation
//Facebook active session permision method
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI
{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
    {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      
                                      if (CheckController) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSessionStateChangeNotification"
                                                                                              object:nil
                                                                                            userInfo:sessionStateInfo];

                                      }
                                      else{
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"RegSessionStateChangeNotification"
                                                                                              object:nil
                                                                                            userInfo:sessionStateInfo];
                                          imageCheck=true;
                                          
                                      }
                                      
                                  }];
}
#pragma mark-end

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark CLLocationManagerDelegate
//Current location update method
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

	CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    lat = [NSString stringWithFormat:@"%f", coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f", coordinate.longitude];
}
#pragma mark - end

@end
