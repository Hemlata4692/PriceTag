//
//  RedeemViewController.m
//  PriceTag
//
//  Created by Ranosys on 08/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "RedeemViewController.h"

@interface RedeemViewController ()
{
    NSDictionary *jsonDictionary;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation RedeemViewController
@synthesize phoneNumber,BankDetails,BankName,jsonDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    phoneNumber.delegate=self;
    BankName.delegate=self;
    BankDetails.delegate=self;
    
    self.view=[GlobalMethod customView:self.view];
    phoneNumber=[GlobalMethod customPadding:phoneNumber];
    BankDetails=[GlobalMethod customPadding:BankDetails];
    BankName=[GlobalMethod customPadding:BankName];
    
    
    NSArray *fields = @[phoneNumber,BankName,BankDetails];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"REDEEM";
    self.navigationItem.leftBarButtonItem = nil;
    GlobalNavigationBackButton *global = [GlobalNavigationBackButton new];
    global.myVC = self;
    self.navigationItem.leftBarButtonItem = [GlobalNavigationBackButton customizeMyNavigationBar:self];
    
    //[self setTopbarTitle];
    
}

-(void)goBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - end

#pragma mark - Textfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==BankDetails) {
        [self.scrollView setContentOffset:CGPointMake(0, BankDetails.frame.origin.y- (2.5 * BankDetails.frame.size.height)) animated:YES];
    }
    
    [self.keyboardControls setActiveField:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)TextField
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [TextField resignFirstResponder];
    return YES;
}

#pragma mark - end

#pragma mark - Keyboard Controls Delegate
//Keyboard toolbar delegate actions adding keyboard controls
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]< 7.0) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end



#pragma mark - Button Actions
- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//Action for redeem webservice to allow user to reddem the earned money
- (IBAction)submit:(UIButton *)sender
{
    NSString *message;
    message=@"Please fill all fields.";
    if(BankDetails.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    if(BankName.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    if(phoneNumber.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    
    [myDelegate ShowIndicator];
      //Method for redeem action to be completed from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(redeemWebservice) toTarget:self withObject:nil];
}
#pragma mark - end

#pragma mark - Call Redeem API
//Redeem webservice method to allow user to redeem with earned money
-(void)redeemWebservice
{
    //Internet check to check internet status is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        //json request
        NSDictionary *requestDict = @{@"contactNo":phoneNumber.text,@"bankName":BankName.text,@"bankAccountNo":BankDetails.text,@"userId":[NSString stringWithFormat:@"%@",myDelegate.userId]};
        jsonDictionary=[NSDictionary new];
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"redeem"];
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        // NSLog(@"totalBodyData is %@",tempDict1);
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert setTag:1];
            [alert show];
        }
        else if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 2)
        {
            [self performSelectorOnMainThread:@selector(callLogoutMethod) withObject:nil waitUntilDone:NO];
            
            return;
        
        }
        else
        {
            if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 0 && tempDict1 !=NULL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
    }
}

//alert shows that user's account has deactivated by admin
-(void)callLogoutMethod
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your account has been deactivated by administrator" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag=200;
    [alert show];
    //[self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    
}
//this method will fired when user's account has been deactivated. It will destroy user's existing session.
- (void)logout
{
    
    //[self normalAnimation];
    
    
    
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
    
    
    
    
}
#pragma mark - end


#pragma mark - Alert View
//Alert view button clicked to pop to profile screen after redeem is successfully done
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alert.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alert.tag==2)
    {
    [self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    
    }
}

#pragma mark - end

@end
