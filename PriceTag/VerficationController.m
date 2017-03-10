//
//  VerficationController.m
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "VerficationController.h"

@interface VerficationController (){
    NSDictionary *jsonDictionary;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation VerficationController
@synthesize emailAddress,verificationCode,scrollView,email,tabbarcontroller,jsonDictionary;

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
    emailAddress.delegate=self;
    verificationCode.delegate=self;
    self.view=[GlobalMethod customView:self.view];
    emailAddress=[GlobalMethod customPadding:self.emailAddress];
    verificationCode=[GlobalMethod customPadding:self.verificationCode];
    NSArray *fields = @[emailAddress,verificationCode];
    
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
   
    if (email ==nil) {
        emailAddress.text=@"";
        emailAddress.enabled=YES;
    }
    else {
        emailAddress.text=email;
        emailAddress.enabled=NO;
    }
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"VERIFICATION CODE";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

#pragma mark - Textfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(2.5* textField.frame.size.height)) animated:YES];
    
    [self.keyboardControls setActiveField:textField];
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


#pragma mark - Submit Button
//Action for calling verification email web service
- (IBAction)submit:(UIButton *)sender {
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                           animated:NO];
    [self.view endEditing:YES];
    
   NSString *message;
    if(verificationCode.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please fill the verification code." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
    //Method for requesting to verification email from server which is called in seperate thread
     [NSThread detachNewThreadSelector:@selector(verifyEmailWebservice) toTarget:self withObject:nil];
}
#pragma mark - end


#pragma mark - Call Verification Email API
//Verifiy email webservice to check verifaction of email
-(void)verifyEmailWebservice
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
        
        NSDictionary *requestDict = @{@"email":emailAddress.text,@"code":verificationCode.text};
        //[self countdownTimer];
        
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"emailVerification"];
       
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        
       // NSLog(@"totalBodyData is %@",tempDict1);
        
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            
            myDelegate.userId=[jsonDictionary valueForKey:@"userId"];
           // NSLog(@"totalBodyData is %@",myDelegate.userId);
            myDelegate.DBemail=emailAddress.text;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:emailAddress.text forKey:@"checkLoginText"];
            [prefs setObject:myDelegate.userId forKey:@"checkUserId"];
            [prefs synchronize];
            
            [prefs setObject:emailAddress.text forKey:@"IsUserLogin"];
            [prefs synchronize];
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController * objView=[sb instantiateViewControllerWithIdentifier:@"TutorialViewController"];
            [self.navigationController pushViewController:objView animated:YES];
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

#pragma mark - end


#pragma mark - Button Action
- (IBAction)backButton:(UIButton *)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

@end
