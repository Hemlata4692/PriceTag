//
//  RestPasswordController.m
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "RestPasswordController.h"


@interface RestPasswordController ()
{
    NSDictionary *jsonDictionary;
    int check;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation RestPasswordController
@synthesize emailAddress,passwordField1,passwordField2,passwordField3,passwordField4,confirmPasswordField1,confirmPasswordField2,confirmPasswordField3,confirmPasswordField4,scrollView,verCode,email,jsonDictionary;

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
    //setting textfield delegates
    verCode.delegate=self;
    emailAddress.delegate=self;
    passwordField1.delegate=self;
    passwordField2.delegate=self;
    passwordField3.delegate=self;
    passwordField4.delegate=self;
    confirmPasswordField1.delegate=self;
    confirmPasswordField2.delegate=self;
    confirmPasswordField3.delegate=self;
    confirmPasswordField4.delegate=self;
    
    self.view=[GlobalMethod customView:self.view];
    
    // left of padding textfield
    verCode=[GlobalMethod customPadding:self.verCode];
    emailAddress=[GlobalMethod customPadding:self.emailAddress];
    // custom password field
    passwordField1=[GlobalMethod CustomPassField:passwordField1];
    passwordField2=[GlobalMethod CustomPassField:passwordField2];
    passwordField3=[GlobalMethod CustomPassField:passwordField3];
    passwordField4=[GlobalMethod CustomPassField:passwordField4];
    
    confirmPasswordField1=[GlobalMethod CustomPassField:confirmPasswordField1];
    confirmPasswordField2=[GlobalMethod CustomPassField:confirmPasswordField2];
    confirmPasswordField3=[GlobalMethod CustomPassField:confirmPasswordField3];
    confirmPasswordField4=[GlobalMethod CustomPassField:confirmPasswordField4];
    
    //method to handle textfield to change while entering old, new and confirm password
    [passwordField1 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    [passwordField2 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    [passwordField3 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    [passwordField4 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    
    [confirmPasswordField1 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField2 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField3 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField4 addTarget:self action:@selector(textchangeRestPassword:) forControlEvents:UIControlEventEditingChanged];
    
    if ([email isEqualToString:@""]) {
        emailAddress.text=@"";
        emailAddress.enabled=YES;
    }
    else{
        emailAddress.text=email;
        emailAddress.enabled=NO;
    }
    
    NSArray *fields = @[emailAddress,verCode,passwordField1,passwordField2,passwordField3,passwordField4,confirmPasswordField1,confirmPasswordField2,confirmPasswordField3,confirmPasswordField4];
      //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"RESET PASSWORD";
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
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [keyboardControls.activeField resignFirstResponder];
}
#pragma mark - end

#pragma mark - Action on Password Textfield
//This method is used to handle previous next actions in the textfields
-(void)textchangeRestPassword:(id)sender
{
    
    if(check==1)
    {
        check=0;
        if ([sender tag]==3) {
            [confirmPasswordField1 resignFirstResponder];
        }
        else if ([sender tag]==4) {
            [passwordField2 resignFirstResponder];
            [passwordField1 becomeFirstResponder];
            
        }
        else if ([sender tag]==5)
        {
            [passwordField3 resignFirstResponder];
            [passwordField2 becomeFirstResponder];
            
        }
        else if ([sender tag]==6)
        {
            [passwordField4 resignFirstResponder];
            [passwordField3 becomeFirstResponder];
        }
        
        
        
        if ([sender tag]==7)
        {
            [confirmPasswordField1 resignFirstResponder];
            [passwordField4 becomeFirstResponder];
        }
        else if ([sender tag]==8)
        {
            [confirmPasswordField2 resignFirstResponder];
            [confirmPasswordField1 becomeFirstResponder];
            
        }
        else if ([sender tag]==9) {
            [confirmPasswordField3 resignFirstResponder];
            [confirmPasswordField2 becomeFirstResponder];
            
        }
        else if ([sender tag]==10) {
            [confirmPasswordField4 resignFirstResponder];
            [confirmPasswordField3 becomeFirstResponder];
        }
    }
    
    else{
        
        if ([sender tag]==3) {
            [passwordField1 resignFirstResponder];
            [passwordField2 becomeFirstResponder];
        }
        else if ([sender tag]==4) {
            [passwordField2 resignFirstResponder];
            [passwordField3 becomeFirstResponder];
            
        }
        else if ([sender tag]==5) {
            [passwordField3 resignFirstResponder];
            [passwordField4 becomeFirstResponder];
            
        }
        else if ([sender tag]==6) {
            [passwordField4 resignFirstResponder];
            [confirmPasswordField1 becomeFirstResponder];
        }
        
        
        if ([sender tag]==7) {
            [confirmPasswordField1 resignFirstResponder];
            [confirmPasswordField2 becomeFirstResponder];
        }
        else if ([sender tag]==8) {
            [confirmPasswordField2 resignFirstResponder];
            [confirmPasswordField3 becomeFirstResponder];
            
        }
        else if ([sender tag]==9) {
            [confirmPasswordField3 resignFirstResponder];
            [confirmPasswordField4 becomeFirstResponder];
            
        }
        else if ([sender tag]==10) {
            [confirmPasswordField4 resignFirstResponder];
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
        if (textField.tag==1 || textField.tag==2)
        {
            return YES;
        }
        else
        {
            check=1;
            return YES;
        }
    }
    
    else{
        
        if (textField.tag==1 || textField.tag==2)
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
                [self textchangeRestPassword:textField];
                return NO;
            }
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if (textField==emailAddress);
    else{
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(2.5* textField.frame.size.height)) animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [aTextField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Submit Action
//Action for rest password
- (IBAction)submit:(UIButton *)sender
{
    [self.view endEditing:YES];
    //Alert messages for empty textfields
    NSString *message;
    message=@"Please fill in all fields.";
    if(emailAddress.text.length==0)
    {
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    NSString *password=[NSString stringWithFormat:@"%@%@%@%@",passwordField1.text,passwordField2.text,passwordField3.text,passwordField4.text];
    NSString *confirmPassword=[NSString stringWithFormat:@"%@%@%@%@",confirmPasswordField1.text,confirmPasswordField2.text,confirmPasswordField3.text,confirmPasswordField4.text];
    
    [self.view endEditing:YES];
    
    
    if(verCode.text.length==0)
    {
        //message=@"Please fill Verfication Code.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    if((passwordField1.text.length==0) || (passwordField2.text.length==0) || (passwordField3.text.length==0) || (passwordField4.text.length==0))
    {
        //message=@"Please fill all field of password.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    if((confirmPasswordField1.text.length==0) || (confirmPasswordField2.text.length==0) || (confirmPasswordField3.text.length==0) || (confirmPasswordField4.text.length==0))
    {
        //message=@"Please fill all field of confirm password.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    //Alert to confirm new password
    if (![password isEqualToString:confirmPassword]) {
        message=@"Password and confirm password must be same.";
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
   //Method for request of reset password from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(resetPassword) toTarget:self withObject:nil];
    
}
#pragma mark - end

#pragma mark - Call Reset Password API
//Reset password web service to reset password
-(void)resetPassword
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
        NSDictionary *requestDict = @{@"email":emailAddress.text,@"password":password,@"code":verCode.text};
        
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"resetPassword"];
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        
        //  NSLog(@"totalBodyData is %@",tempDict1);
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        { if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 0 && tempDict1 !=NULL) {
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


@end
