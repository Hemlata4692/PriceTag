//
//  ForgotPasswordController.m
//  PriceTag
//
//  Created by Ranosys on 07/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ForgotPasswordController.h"
#import "RestPasswordController.h"

@interface ForgotPasswordController ()
{
    NSDictionary *jsonDictionary;
}
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation ForgotPasswordController
@synthesize emailAddress,jsonDictionary;

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
    self.view=[GlobalMethod customView:self.view];
    emailAddress.delegate=self;
    self.view=[GlobalMethod customView:self.view];
    emailAddress=[GlobalMethod customPadding:self.emailAddress];
    emailAddress.text=@"";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    emailAddress.text=@"";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"FORGOT PASSWORD";
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
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}
#pragma mark - end


#pragma mark - Button Action
//Action for forgot password webservice to reset varification code 
- (IBAction)submit:(UIButton *)sender
{
    [self.view endEditing:YES];
    
     NSString *message;
    if(emailAddress.text.length==0)
    {
        message=@"Please enter email address.";
        UIAlertView *wrongemailformat=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongemailformat show];
        
        return;
    }
    else if(![GlobalMethod validateEmailString:emailAddress.text])
    {
        message=@"Please enter the valid email address.";
        UIAlertView *wrongemailformat=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongemailformat show];
        
        return;
    }    [myDelegate ShowIndicator];
   //Method for requesting change passwod from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(forgotPasswordWebservice) toTarget:self withObject:nil];
    
}
#pragma mark - end

#pragma mark - Call Forgot Password API
//Forgot password webservice
-(void)forgotPasswordWebservice
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
        NSDictionary *requestDict = @{@"email":emailAddress.text};
        jsonDictionary=[NSDictionary new];
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"forgotPassword"];
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];

        
       // NSLog(@"totalBodyData is %@",tempDict1);
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RestPasswordController *resetView=[sb instantiateViewControllerWithIdentifier:@"RestPasswordController"];
            resetView.email=emailAddress.text;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController pushViewController:resetView animated:YES];
            
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
//Action to move to reset password if already had a code
- (IBAction)alreadyCode:(UIButton *)sender
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestPasswordController *resetView=[sb instantiateViewControllerWithIdentifier:@"RestPasswordController"];
    resetView.email=@"";
    [self.navigationController pushViewController:resetView animated:YES];
}
#pragma mark - end

@end
