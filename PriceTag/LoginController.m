//
//  LoginController.m
//  PriceTag
//
//  Created by Ranosys on 05/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "LoginController.h"
#import "RegistrationController.h"
#import "ForgotPasswordController.h"
#import "HomeViewController.h"
#import "MyProfileController.h"
#import "Base64.h"

@interface LoginController ()
{
    int check;
    NSDictionary *jsonDictionary;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;
@end

@implementation LoginController
@synthesize emailAddress,passwordField1,passwordField2,passwordField3,passwordField4,scrollView;
@synthesize tabbarcontroller;
@synthesize user_name,user_email,user_gender,profilePic,data,url,imageNameFB,jsonDictionary;


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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //facebook
    
    // Observe for the custom notification regarding the session state change.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFBSessionStateChangeWithNotification:)name:@"LoginSessionStateChangeNotification" object:nil];
    //facebook
    
    emailAddress.delegate=self;
    passwordField1.delegate=self;
    passwordField2.delegate=self;
    passwordField3.delegate=self;
    passwordField4.delegate=self;
    
    //set background image
    self.view=[GlobalMethod customView:self.view];
    
    // left of padding textfield
    emailAddress=[GlobalMethod customPadding:self.emailAddress];
    // custom password field
    passwordField1=[GlobalMethod CustomPassField:passwordField1];
    passwordField2=[GlobalMethod CustomPassField:passwordField2];
    passwordField3=[GlobalMethod CustomPassField:passwordField3];
    passwordField4=[GlobalMethod CustomPassField:passwordField4];
    
    UIFont *cellFont = [UIFont fontWithName:@"Bariol-Regular" size:16.0];
    
    NSDictionary *attrDict = @{NSFontAttributeName :cellFont ,NSForegroundColorAttributeName : [UIColor colorWithRed:(44/255.0) green:(44/255.0) blue:(44/255.0) alpha:1]};
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password?" attributes: attrDict];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length]) ];
    [titleString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1] range:NSMakeRange(0, [titleString length])];
    [self.forgotPassOutler setAttributedTitle: titleString forState:UIControlStateNormal];
    
    //method to handle textfield to change while entering old, new and confirm password
    [passwordField1 addTarget:self action:@selector(textchangeLoginView:) forControlEvents:UIControlEventEditingChanged];
    [passwordField2 addTarget:self action:@selector(textchangeLoginView:) forControlEvents:UIControlEventEditingChanged];
    [passwordField3 addTarget:self action:@selector(textchangeLoginView:) forControlEvents:UIControlEventEditingChanged];
    [passwordField4 addTarget:self action:@selector(textchangeLoginView:) forControlEvents:UIControlEventEditingChanged];
    
    
    NSArray *fields = @[emailAddress,passwordField1,passwordField2,passwordField3,passwordField4];
      //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // hide navigation bar
    [myDelegate StopIndicator];
    emailAddress.text=@"";
    passwordField1.text=@"";
    passwordField2.text=@"";
    passwordField3.text=@"";
    passwordField4.text=@"";
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [keyboardControls.activeField resignFirstResponder];
}

#pragma mark - end


#pragma mark - Password Textfield Action Performed
//This method is used to handle previous next actions in the textfields
-(void)textchangeLoginView:(id)sender
{
    
    if(check==1)
    {
        check=0;
        if ([sender tag]==2)
        {
            [passwordField1 resignFirstResponder];
            
            
        }
        else if ([sender tag]==3)
        {
            [passwordField2 resignFirstResponder];
            [passwordField1 becomeFirstResponder];
            
        }
        else if ([sender tag]==4)
        {
            [passwordField3 resignFirstResponder];
            [passwordField2 becomeFirstResponder];
            
        }
        else if ([sender tag]==5)
        {
            [passwordField4 resignFirstResponder];
            [passwordField3 becomeFirstResponder];
        }
    }
    
    else
    {
        
        if ([sender tag]==2)
        {
            [passwordField1 resignFirstResponder];
            [passwordField2 becomeFirstResponder];
            
        }
        else if ([sender tag]==3)
        {
            [passwordField2 resignFirstResponder];
            [passwordField3 becomeFirstResponder];
            
        }
        else if ([sender tag]==4)
        {
            [passwordField3 resignFirstResponder];
            [passwordField4 becomeFirstResponder];
            
        }
        else if ([sender tag]==5)
        {
            [passwordField4 resignFirstResponder];
        }
    }
}
#pragma mark - end


#pragma mark - Textfield Delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]]
        isEqualToString:@""])
    {
        if (textField.tag==1) {
            return YES;
        }
        else{
            check=1;
            return YES;
        }
    }
    
    else{
        if (textField.tag==1)
        {
            return YES;
        }
        else
        {
            if ([textField.text length]==0)
            {
                return YES;
            }
            else
            {
                //Calling textfield change handle action
                [self textchangeLoginView:textField];
                return NO;
            }
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if (textField!=emailAddress) {
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(4.0* textField.frame.size.height)) animated:YES];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

#pragma mark - end

#pragma mark - Call Login User API
//Method to fetch logged in user details
-(void)loginUserWebservice
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        
        
        
        
        NSString *password=[NSString stringWithFormat:@"%@%@%@%@",passwordField1.text,passwordField2.text,passwordField3.text,passwordField4.text];
        NSDictionary *requestDict = @{@"email":emailAddress.text,@"password":password};
        jsonDictionary=[NSDictionary new];
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"loginUser"];
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        
        // NSLog(@"totalBodyData is %@",tempDict1);
        [myDelegate StopIndicator];
        
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            myDelegate.userId=[tempDict1 valueForKey:@"userId"];
            myDelegate.DBemail=emailAddress.text;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:emailAddress.text forKey:@"checkLoginText"];
            [prefs setObject:myDelegate.userId forKey:@"checkUserId"];
            [prefs synchronize];
            
            NSLog(@"login key is %@",[prefs objectForKey:@"IsUserLogin"]);
            if(([[prefs objectForKey:@"IsUserLogin"] isEqualToString:@""] || [[prefs objectForKey:@"IsUserLogin"] isEqualToString:@"(null)"] ||[prefs objectForKey:@"IsUserLogin"] ==NULL) || (![emailAddress.text isEqualToString:[prefs objectForKey:@"IsUserLogin"]]))
               
            {
                
                
                [prefs setObject:emailAddress.text forKey:@"IsUserLogin"];
                [prefs synchronize];
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController * objView=[sb instantiateViewControllerWithIdentifier:@"TutorialViewController"];
                [self.navigationController pushViewController:objView animated:YES];
            }
            else
            {
            
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                tabbarcontroller=[sb instantiateViewControllerWithIdentifier:@"UITabBarController"];
                [self.navigationController pushViewController:tabbarcontroller animated:YES];
            
            }

            
            
        }
        else
        {
            
            if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 0 && tempDict1 !=NULL)
            {
                passwordField1.text=@"";
                passwordField2.text=@"";
                passwordField3.text=@"";
                passwordField4.text=@"";
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
#pragma mark - end

#pragma mark - Button Action
//Action for calling login webservice to display logged in user details
- (IBAction)submit:(UIButton *)sender
{
    
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.view endEditing:YES];
    
    NSString *message;
    if(emailAddress.text.length==0)
    {
        message=@"Please enter login details.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    else if(passwordField1.text.length==0 || passwordField2.text.length==0 || passwordField3.text.length==0 || passwordField4.text.length==0){
        message=@"Please enter login details.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    else if(![GlobalMethod validateEmailString:emailAddress.text])
    {
        message=@"Please enter the valid email address.";
        UIAlertView *wrongemailformat=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongemailformat show];
        
        return;
    }
    
    [myDelegate ShowIndicator];
    //Method for fetching the logged in user details from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(loginUserWebservice) toTarget:self withObject:nil];
    
}

//Action for moving to forgot password screen
- (IBAction)forgotPass:(UIButton *)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgotPasswordController *forgotView=[sb instantiateViewControllerWithIdentifier:@"ForgotPasswordController"];
    [self.navigationController pushViewController:forgotView animated:YES];
}

//Login with facebook action
- (IBAction)loginWithFacebook:(UIButton *)sender {
    if ([FBSession activeSession].state != FBSessionStateOpen && [FBSession activeSession].state != FBSessionStateOpenTokenExtended)
    {
        myDelegate.CheckController=true;
        [myDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
    }
    else
    {
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
        
    }
    
    
}

//Action for moving to registration with email view
- (IBAction)registrationWithEmail:(UIButton *)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistrationController *regView=[sb instantiateViewControllerWithIdentifier:@"RegistrationController"];
    [self.navigationController pushViewController:regView animated:YES];
}


#pragma mark - end



#pragma mark - Facebook login

//Facebook login
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    // Get the session, state and error values from the notification's userInfo dictionary.
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSDictionary *userInfo = [notification userInfo];
        
        FBSessionState sessionState = (int)[[userInfo objectForKey:@"state"] integerValue];
        NSError *error = [userInfo objectForKey:@"error"];
        
        [myDelegate ShowIndicator];
        
        
        
        if (!error) {
            // In case that there's not any error, then check if the session opened or closed.
            if (sessionState == FBSessionStateOpen)
            {
                
                [FBRequestConnection startWithGraphPath:@"me"
                                             parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                             HTTPMethod:@"GET"
                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                          if (!error) {
                                              //NSLog(@"%@", result);
                                              
                                              myDelegate.DBuserName=[NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                                              
                                              myDelegate.DBuserFbId=[result objectForKey:@"id"];
                                              
                                              
                                              myDelegate.DBemail=[result objectForKey:@"email"];
                                              
                                              
                                              // Get the user's profile picture.
                                              NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                              NSString *profile_photo = [Base64 encode:[NSData dataWithContentsOfURL:pictureURL]];
                                              myDelegate.DBimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                                              // imageNameFB=[pictureURL lastPathComponent];
                                              
                                              NSDictionary *requestDict = @{@"email":myDelegate.DBemail,@"name":myDelegate.DBuserName,@"fb_id":myDelegate.DBuserFbId,@"profile_photo":profile_photo};
                                              
                                              jsonDictionary=[NSDictionary new];
                                              jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"loginUserFb"];
                                              
                                              // NSLog(@"totalBodyData is %@",jsonDictionary);
                                              [myDelegate StopIndicator];
                                              if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 1 || [[jsonDictionary valueForKey:@"isSuccess"] intValue] == 2)
                                              {
                                                  myDelegate.userId=[jsonDictionary valueForKey:@"userId"];
                                                  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                                  [prefs setObject:myDelegate.userId forKey:@"checkUserId"];
                                                  [prefs setObject:myDelegate.DBemail forKey:@"checkLoginText"];
                                                  
                                                  
                                                  [prefs synchronize];
                                                  if(([[prefs objectForKey:@"IsUserLogin"] isEqualToString:@""] || [[prefs objectForKey:@"IsUserLogin"] isEqualToString:@"(null)"] ||[prefs objectForKey:@"IsUserLogin"] ==NULL) || (![myDelegate.DBemail isEqualToString:[prefs objectForKey:@"IsUserLogin"]]))
                                                      
                                                  {
                                                      
                                                      
                                                      [prefs setObject:myDelegate.DBemail forKey:@"IsUserLogin"];
                                                      [prefs synchronize];
                                                      UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                      UIViewController * objView=[sb instantiateViewControllerWithIdentifier:@"TutorialViewController"];
                                                      [self.navigationController pushViewController:objView animated:YES];
                                                  }
                                                  else
                                                  {
                                                      
                                                      UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                      tabbarcontroller=[sb instantiateViewControllerWithIdentifier:@"UITabBarController"];
                                                      [self.navigationController pushViewController:tabbarcontroller animated:YES];
                                                      
                                                  }

                                                  //NSLog(@"%@",myDelegate.userId);
                                                  
                                                  [myDelegate StopIndicator];
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
                                          else{
                                              //NSLog(@"%@", [error localizedDescription]);
                                              [myDelegate StopIndicator];
                                          }
                                      }];
            }
            else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed)
            {
                [myDelegate StopIndicator];
                
            }
        }
        else{
            
            [myDelegate StopIndicator];
            
        }
    }
}
#pragma mark - end


@end
