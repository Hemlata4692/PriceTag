//
//  MyProfileController.m
//  PriceTag
//
//  Created by Ranosys on 07/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "MyProfileController.h"
#import "CustomCell.h"
#import "RedeemViewController.h"
#import "CommentsViewController.h"
#import "EditProfile.h"
#import "LoginController.h"
#import "ChangePasswordController.h"
#import "UIImageView+WebCache.h"
@interface MyProfileController ()
{
    NSArray *list,*secList,*imageList;
    NSDictionary *jsonDictionary;
    NSString * image_url;
    
    NSTimer *timer;
    int hour1,minute,second,day;
    int secondsLeft;
    BOOL click;
    NSString *RedeemCount;
}

@property (weak, nonatomic) IBOutlet UIImageView *mainBackImage;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@property(nonatomic,retain) NSArray *list,*secList,*imageList;
@property(nonatomic,assign) int hour1;
@property(nonatomic,assign) int minute;
@property(nonatomic,assign) int second;
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int secondLeft;

@end

@implementation MyProfileController
@synthesize hour1,minute,second,secondLeft,day;
@synthesize dropDownView,rightBarButtonOutlet,naviController,profileImage,defaultImage,jsonDictionary,imageList,list,secList;
@synthesize days,hours,minutes,seconds;
@synthesize todayDate,endingDate;
@synthesize adminEmailId;
#pragma mark - View Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    click=false;
    
    self.view.userInteractionEnabled = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    [self.profileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImage.layer setBorderWidth: 2.0];
    
    
    timer_popup.layer.cornerRadius = 5;
    timer_popup.layer.masksToBounds = YES;
    timer_popup.layer.borderWidth=1.0f;
    timer_popup.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:2.0].CGColor;
    
    //Adding gesture to timer screen
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapTimer:)];
    [timerpopup_bg addGestureRecognizer:singleFingerTap];
    //Gesture to hide right bar button list
    UITapGestureRecognizer *singleFingerTapSetting =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapSetting:)];
    [self.mainBackImage addGestureRecognizer:singleFingerTapSetting];
    
    self.view=[GlobalMethod customView:self.view];
    
    //Setting bottom tabbar
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;       //get reference of tabbar
    UITabBar *tabBar = myTab.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"bottom_tab_bg.png"]];
    [[[self tabBarController] tabBar] setBackgroundColor:[UIColor whiteColor]];
    
    //Setting bottom tabbar icons
    [tabBarItem1 setImage:[[UIImage imageNamed:@"icon3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"icon2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    [tabBarItem2 setImage:[[UIImage imageNamed:@"search_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"search_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem2.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    
    [tabBarItem3 setImage:[[UIImage imageNamed:@"icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"icon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem3.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
    [myTab setSelectedIndex:2];
    
    //set inset of bar button
    list = [NSArray arrayWithObjects:@"Earned Money",@"Comment",@"My Activity",@"Offer Feed",@"Timer",nil];
    
    imageList = [NSArray arrayWithObjects:@"money_icon.png",@"comments_icon.png",@"my-activity_icon.png",@"offer_icon.png",@"timer_icon.png",nil];
    
    if ([myDelegate.DBemail isEqualToString:@""]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.emailAddress.text = [prefs stringForKey:@"checkLoginText"];
    }
    else{
        self.emailAddress.text=myDelegate.DBemail;
    }
    if (self.profileImage.image==nil)
    {
        self.profileImage.image=[UIImage imageNamed:@"my_profile_placeholder_.png"];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self normalAnimation];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=@"MY PROFILE";
    
    [myDelegate ShowIndicator];
    //Method for fetching the my profile data from server
    [self performSelector:@selector(myProfileWebservice) withObject:nil afterDelay:0.3];
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//touch event on the screen to hide dropdown view
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view != dropDownView)
    {
        [self normalAnimation];
    }
    
}
#pragma mark - end

#pragma mark - Call My Profile API
//Myprofile webservice method to fetch profile data
-(void)myProfileWebservice
{
    //Internet check to check inernet status is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *myUserName =[NSString stringWithFormat:@"%ld", (long)[prefs integerForKey:@"checkUserId"] ];
        NSDictionary *requestDict = @{@"userId":myUserName};
        myDelegate.userId=[NSNumber numberWithInteger:[prefs integerForKey:@"checkUserId"]];
        jsonDictionary=[NSDictionary new];
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"myProfile"];
        
        NSLog(@"totalBodyData is %@",jsonDictionary);
        
        if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 1)
        {
            NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:[jsonDictionary valueForKey:@"profile"]]];
            
            //Parsing my profile data from server
            self.userName.text=[tempDict valueForKey:@"name"];
            self.todayDate = [jsonDictionary objectForKey:@"today_date"];
            self.endingDate = [jsonDictionary objectForKey:@"submission_close_date"];
            secList = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"earnedMoney"] ],[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"totalComments"] ],[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"totalActivities"] ],[NSString stringWithFormat:@"%@",[tempDict valueForKey:@"totalOfferTickers"] ],nil];
            RedeemCount=[tempDict valueForKey:@"earnedMoney"];
            [self.tableView reloadData];
            image_url =[tempDict valueForKey:@"profilePhotoUrl"];
            adminEmailId = [jsonDictionary objectForKey:@"adminEmailId"];
            [profileImage sd_setImageWithURL:[NSURL URLWithString:[tempDict valueForKey:@"profilePhotoUrl"]] placeholderImage:[UIImage imageNamed:@"my_profile_placeholder_.png"]];
            [myDelegate StopIndicator];
            [timer invalidate];
            //Calling my profile timer
            [self performSelectorOnMainThread:@selector(profileTimer) withObject:nil waitUntilDone:NO];
        }
        else if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 2)
        {
            [self performSelectorOnMainThread:@selector(callLogoutMethod) withObject:nil waitUntilDone:NO];
            
            return;
            
        }
        else
        {
            if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 0 && jsonDictionary !=NULL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[jsonDictionary valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [myDelegate StopIndicator];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [myDelegate StopIndicator];
            }
            
        }
        
    }
}
//alert shows that user's account has deactivated by admin
-(void)callLogoutMethod
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your account has been deactivated by administrator" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag=150;
    [alert show];
    //[self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    
}
#pragma mark - end

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //adding border to cell
    if (cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.redeemAction.hidden=YES;
    
    cell.title.text=[list objectAtIndex:indexPath.row];
    if (indexPath.row==0)
    {
        //Redeem button action use to redeem when a user earned money
        cell.redeemAction.hidden=NO;
        [cell.redeemAction addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.secondTitle.frame = CGRectMake(150, 7, 85, 28);
        cell.secondTitle.layer.borderWidth=0.5;
        cell.secondTitle.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        cell.secondTitle.text = [secList objectAtIndex:indexPath.row];
        cell.arrow.hidden=YES;
        cell.imageview.image=[UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
        
    }
    else if (indexPath.row==(list.count-1))
    {
        
        cell.secondTitle.hidden=YES;
        cell.arrow.hidden=YES;
        cell.imageview.image=[UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
    }
    else
    {
        
        cell.secondTitle.text = [secList objectAtIndex:indexPath.row];
        cell.imageview.image=[UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self hideAnimation];
    }
    
    if(indexPath.row == 1)
    {
        //Hiding dropdown view
        [UIView animateWithDuration:0.3f animations:^{
            self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 0);
            [self.editButton setFrame:CGRectMake(0, -137, 156, 45)];
            [self.resetButton setFrame:CGRectMake(0, -91, 161, 40)];
            [self.logoutButton setFrame:CGRectMake(5, -50, 156, 45)];
            [self.separator1 setFrame:CGRectMake(0, -92, 161, 3)];
            [self.separator2 setFrame:CGRectMake(0, -51, 161, 3)];
        }completion:^(BOOL finished) {
            
            [rightBarButtonOutlet setSelected:NO];
            //Moving to comments list screen display
            [self gotoCommentActivity:(int)indexPath.row];
            
            
        }];
        
        
    }
    
    else if(indexPath.row == 2)
    {
        //Hiding dropdown view
        [UIView animateWithDuration:0.3f animations:^{
            self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 0);
            [self.editButton setFrame:CGRectMake(0, -137, 156, 45)];
            [self.resetButton setFrame:CGRectMake(0, -91, 161, 40)];
            [self.logoutButton setFrame:CGRectMake(5, -50, 156, 45)];
            [self.separator1 setFrame:CGRectMake(0, -92, 161, 3)];
            [self.separator2 setFrame:CGRectMake(0, -51, 161, 3)];
        }completion:^(BOOL finished) {
            
            [rightBarButtonOutlet setSelected:NO];
            //Moving to my activity list screen display
            [self gotoCommentActivity:(int)indexPath.row];
            
        }];
    }
    
    else if (indexPath.row==3)
    {
        
        [UIView animateWithDuration:0.3f animations:^{
            self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 0);
            [self.editButton setFrame:CGRectMake(0, -137, 156, 45)];
            [self.resetButton setFrame:CGRectMake(0, -91, 161, 40)];
            [self.logoutButton setFrame:CGRectMake(5, -50, 156, 45)];
            [self.separator1 setFrame:CGRectMake(0, -92, 161, 3)];
            [self.separator2 setFrame:CGRectMake(0, -51, 161, 3)];
        }completion:^(BOOL finished) {
            
            [rightBarButtonOutlet setSelected:NO];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *cont=[storyboard instantiateViewControllerWithIdentifier:@"OfferTickerViewController"];
            [self.navigationController pushViewController:cont animated:YES];
            
        }];
        
        
        
    }
    
    else if (indexPath.row == 4)
    {
        //Hiding dropdown view
        [UIView animateWithDuration:0.3f animations:^{
            self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 0);
            [self.editButton setFrame:CGRectMake(0, -137, 156, 45)];
            [self.resetButton setFrame:CGRectMake(0, -91, 161, 40)];
            [self.logoutButton setFrame:CGRectMake(5, -50, 156, 45)];
            [self.separator1 setFrame:CGRectMake(0, -92, 161, 3)];
            [self.separator2 setFrame:CGRectMake(0, -51, 161, 3)];
        }completion:^(BOOL finished) {
            
            [rightBarButtonOutlet setSelected:NO];
            
            //Displaying timer pop-up
            timerpopup_bg.backgroundColor = [UIColor colorWithRed:(72.0/255.0) green:(72.0/255.0) blue:(72.0/255.0) alpha:0.5];
            timer_popup.hidden = NO;
            timerpopup_bg.hidden = NO;
            
        }];
        
        
        
    }
    
}
//Handling timer gesture
- (void)handleSingleTapTimer:(UITapGestureRecognizer *)recognizer
{
    timerpopup_bg.backgroundColor = [UIColor clearColor];
    timerpopup_bg.userInteractionEnabled=YES;
    timer_popup.hidden=YES;
    timerpopup_bg.hidden=YES;
    
}

#pragma mark - end
//Handling animation action on tapping anywhere in the view
- (void)handleSingleTapSetting:(UITapGestureRecognizer *)recognizer
{
    //hide dropdown view on single tap
    [self hideAnimation];
    
}

#pragma mark - Comment Activity Method
//Action for moving to comments and my activity module
- (void)gotoCommentActivity:(int)index
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentsViewController * objCommentsView = [storyboard instantiateViewControllerWithIdentifier:@"CommentsViewController"];
    objCommentsView.screenCounter = index;
    [self.navigationController pushViewController:objCommentsView animated:YES];
}
#pragma mark - end

#pragma mark - Mail composer delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Button Actions
//method to open iOS native mail composer to send mail for help and support
- (IBAction)helpAndSupportBtnClivked:(id)sender {
    
    
    NSLog(@"admin address is %@",adminEmailId);
    NSArray *toRecipents = [NSArray arrayWithObject:adminEmailId];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc.navigationBar setTintColor:[UIColor whiteColor]];
    mc.mailComposeDelegate = self;
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}
//Action for reddem
-(IBAction)myAction:(UIButton *)sender
{
    [self normalAnimation];
    //codition to check if user has earned some money or not
    if ([RedeemCount isEqualToString:@"BND0.0"])
    {
        //When user has not enough balance to redeem
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You do not have enough balance to redeem." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (!(secondsLeft<=0))
    {
        //When compition is in running mode user can not redeem
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You cannot redeem until the competition is over." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //Redeem action when user has earned some money
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Would you like to redeem with %@ balance.",RedeemCount] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Confirm",nil];
        
        [alert show];
        
    }
}

//Displaying the right bar pop-up with options of edit profile, reset password and logout
- (IBAction)rightBarButton:(UIButton *)sender
{
    if([sender isSelected])
    {
        
        [self hideAnimation];
        // [sender setSelected:NO];
        
    }
    else
    {
        [self showAnimation];
        [sender setSelected:YES];
    }
    
}

//Action to move to edit profile module
- (IBAction)editProfile:(UIButton *)sender
{
    [self normalAnimation];
    click=false;
    [UIView animateWithDuration:0.5f animations:^{
        [self.profileImage setFrame:CGRectMake(110, 29, 100, 100)];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = YES;
    } completion:^(BOOL finished) {
        
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditProfile *editView=[sb instantiateViewControllerWithIdentifier:@"EditProfile"];
        editView.profileObj=self;
        editView.myImage=self.profileImage.image;
        editView.img_url = image_url;
        editView.name=self.userName.text;
        
        [self.navigationController pushViewController:editView animated:YES];
        
    }];
    
    
}
//Action to move to reset password module
- (IBAction)resetPassword:(UIButton *)sender {
    [self normalAnimation];
    click=false;
    [UIView animateWithDuration:0.5f animations:^{
        [self.profileImage setFrame:CGRectMake(110, 29, 100, 100)];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = YES;
        // [self.cancelOutlet setFrame:CGRectMake(260, -10, 46, 30)];
    } completion:^(BOOL finished) {
        
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChangePasswordController *changeView=[sb instantiateViewControllerWithIdentifier:@"ChangePasswordController"];
        [self.navigationController pushViewController:changeView animated:YES];
        
        
    }];
    
}

//Logging out from the applilcation
- (IBAction)logout:(UIButton *)sender
{
    
    [self normalAnimation];
    click=false;
    [UIView animateWithDuration:0.5f animations:^{
        [self.profileImage setFrame:CGRectMake(110, 29, 100, 100)];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.clipsToBounds = YES;
        
    } completion:^(BOOL finished) {
        
        //Facebook logout
        if (!([FBSession activeSession].state != FBSessionStateOpen &&
              [FBSession activeSession].state != FBSessionStateOpenTokenExtended))
        {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginController *firstVC=[sb instantiateViewControllerWithIdentifier:@"LoginController"];
        [myDelegate.navigationController setViewControllers: [NSArray arrayWithObject: firstVC]
                                                   animated: YES];
        myDelegate.window.rootViewController=myDelegate.navigationController;
        [myDelegate.window makeKeyAndVisible];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"checkLoginText"];
        [defaults removeObjectForKey:@"checkUserId"];
        
        myDelegate.DBemail=@"";
        myDelegate.DBimage=nil;
        myDelegate.DBuserFbId=@"";
        myDelegate.DBuserName=@"";
        myDelegate.userId=nil;
        [defaults synchronize];
        
        CATransition* transition = [CATransition animation];
        [transition setDuration:0.5];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setFillMode:kCAFillModeBoth];
        [transition setTimingFunction:[CAMediaTimingFunction
                                       functionWithName:kCAMediaTimingFunctionDefault]];
        [myDelegate.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [myDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    }];
    
    
}
#pragma mark - end
#pragma mark - Timer

//Displaying competition running timer
-(void)profileTimer
{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSString * start = todayDate;
    NSDate *startDate1 = [f dateFromString:start];
    NSString * end = endingDate;
    NSDate *endDate = [f dateFromString:end];
    
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:startDate1
                                                          toDate:endDate
                                                         options:0];
    
    if(components.day == 0)
        if(components.hour == 0)
            if(components.minute == 0)
            {
                [timer invalidate];
            }
    secondsLeft = [endDate timeIntervalSinceDate:startDate1];
    //Timer calculations method
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}

//Timer calculations
- (void)updateCounter:(NSTimer *)theTimer
{
    
    if(secondsLeft > 0 )
    {
        secondsLeft -- ;
        day=(secondsLeft/86400);
        hour1 = (secondsLeft / 3600)%24;
        minute = (secondsLeft /60) % 60;
        second = (secondsLeft  % 60);
        days.text = [NSString stringWithFormat:@"%02i",day];
        hours.text = [NSString stringWithFormat:@"%02i",hour1];
        minutes.text = [NSString stringWithFormat:@"%02i",minute];
        seconds.text=[NSString stringWithFormat:@"%02i",second ];
        
    }
    
    else
    {
        [timer invalidate];
        timer = nil;
    }
    
}
#pragma mark - end

#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1)
    {
        //Moving to redeem view
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RedeemViewController *redeemView=[sb instantiateViewControllerWithIdentifier:@"RedeemViewController"];
        [self.navigationController pushViewController:redeemView animated:YES];
        
    }
    else if (alert.tag==150)
    {
        [self performSelector:@selector(logout:) withObject:nil afterDelay:.1];
    }
    
}

#pragma mark - end

#pragma mark - Animation Handling

//Handling animation for right bar button pop-up
//Show animation
-(void)showAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 165);
        [self.editButton setFrame:CGRectMake(5, 0, 156, 45)];
        [self.resetButton setFrame:CGRectMake(0, 47, 161, 40)];
        [helpAndSupport_Btn setFrame:CGRectMake(5, 85, 156, 45)];
        [self.logoutButton setFrame:CGRectMake(5, 123, 156, 45)];
        [self.separator1 setFrame:CGRectMake(0, 42, 161, 3)];
        [self.separator2 setFrame:CGRectMake(0, 84, 161, 3)];
        [separator3 setFrame:CGRectMake(0, 126, 161, 3)];
        
    }];
    
}

//Hide animation
-(void)hideAnimation{
    [UIView animateWithDuration:0.3f animations:^{
        self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 0);
        [self.editButton setFrame:CGRectMake(0, -137, 156, 45)];
        [self.resetButton setFrame:CGRectMake(0, -91, 161, 40)];
        [self.logoutButton setFrame:CGRectMake(5, -50, 156, 45)];
        [helpAndSupport_Btn setFrame:CGRectMake(5, -50, 156, 45)];
        [self.separator1 setFrame:CGRectMake(0, -92, 161, 3)];
        [self.separator2 setFrame:CGRectMake(0, -51, 161, 3)];
        [separator3 setFrame:CGRectMake(0, -51, 161, 3)];
    }completion:^(BOOL finished) {
        
        [rightBarButtonOutlet setSelected:NO];
        
    }];
    
}

//Drop down pop-up without animation
-(void)normalAnimation
{
    
    self.dropDownView.frame =CGRectMake(self.dropDownView.frame.origin.x, self.dropDownView.frame.origin.y, self.dropDownView.frame.size.width, 0);
    [self.editButton setFrame:CGRectMake(0, -137, 156, 45)];
    [self.resetButton setFrame:CGRectMake(0, -91, 161, 40)];
    [self.logoutButton setFrame:CGRectMake(5, -50, 156, 45)];
    [helpAndSupport_Btn setFrame:CGRectMake(5, -50, 156, 45)];
    [self.separator1 setFrame:CGRectMake(0, -92, 161, 3)];
    [self.separator2 setFrame:CGRectMake(0, -51, 161, 3)];
    [separator3 setFrame:CGRectMake(0, -51, 161, 3)];
    
    [rightBarButtonOutlet setSelected:NO];
}
#pragma mark - end
@end
