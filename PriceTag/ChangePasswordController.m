//
//  ChangePasswordController.m
//  PriceTag
//
//  Created by Ranosys on 14/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()
{
    int check;
    NSDictionary *jsonDictionary;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation ChangePasswordController
@synthesize scrollView,oldPasswordField1,oldPasswordField2,oldPasswordField3,oldPasswordField4,confirmPasswordField1,confirmPasswordField2,confirmPasswordField3,confirmPasswordField4,NPasswordField1,NPasswordField2,NPasswordField3,NPasswordField4,jsonDictionary;

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
    //setting text field delegates
    oldPasswordField1.delegate=self;
    oldPasswordField2.delegate=self;
    oldPasswordField3.delegate=self;
    oldPasswordField4.delegate=self;
    NPasswordField1.delegate=self;
    NPasswordField2.delegate=self;
    NPasswordField3.delegate=self;
    NPasswordField4.delegate=self;
    confirmPasswordField1.delegate=self;
    confirmPasswordField2.delegate=self;
    confirmPasswordField3.delegate=self;
    confirmPasswordField4.delegate=self;
    
    self.view=[GlobalMethod customView:self.view];
    //Text field padding
    oldPasswordField1=[GlobalMethod CustomPassField:oldPasswordField1];
    oldPasswordField2=[GlobalMethod CustomPassField:oldPasswordField2];
    oldPasswordField3=[GlobalMethod CustomPassField:oldPasswordField3];
    oldPasswordField4=[GlobalMethod CustomPassField:oldPasswordField4];
    
    NPasswordField1=[GlobalMethod CustomPassField:NPasswordField1];
    NPasswordField2=[GlobalMethod CustomPassField:NPasswordField2];
    NPasswordField3=[GlobalMethod CustomPassField:NPasswordField3];
    NPasswordField4=[GlobalMethod CustomPassField:NPasswordField4];
    
    confirmPasswordField1=[GlobalMethod CustomPassField:confirmPasswordField1];
    confirmPasswordField2=[GlobalMethod CustomPassField:confirmPasswordField2];
    confirmPasswordField3=[GlobalMethod CustomPassField:confirmPasswordField3];
    confirmPasswordField4=[GlobalMethod CustomPassField:confirmPasswordField4];
   
    //method to handle textfield to change while entering old, new and confirm password
    [oldPasswordField1 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [oldPasswordField2 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [oldPasswordField3 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [oldPasswordField4 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    
    [NPasswordField1 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [NPasswordField2 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [NPasswordField3 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [NPasswordField4 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    
    [confirmPasswordField1 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField2 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField3 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField4 addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
    
    NSArray *fields = @[oldPasswordField1,oldPasswordField2,oldPasswordField3,oldPasswordField4,NPasswordField1,NPasswordField2,NPasswordField3,NPasswordField4,confirmPasswordField1,confirmPasswordField2,confirmPasswordField3,confirmPasswordField4];
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"CHANGE PASSWORD";
    
    
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
-(void)textchange:(id)sender
{
    if(check==1)
    {
        check=0;
        switch ([sender tag])
        {
            case 1:
                [oldPasswordField1 resignFirstResponder];
                break;
            case 2:
                [oldPasswordField2 resignFirstResponder];
                [oldPasswordField1 becomeFirstResponder];
                break;
            case 3:
                [oldPasswordField3 resignFirstResponder];
                [oldPasswordField2 becomeFirstResponder];
                break;
            case 4:
                [oldPasswordField4 resignFirstResponder];
                [oldPasswordField3 becomeFirstResponder];
                break;
            case 5:
                [NPasswordField1 resignFirstResponder];
                [oldPasswordField4 becomeFirstResponder];
                break;
            case 6:
                [NPasswordField2 resignFirstResponder];
                [NPasswordField1 becomeFirstResponder];
                break;
            case 7:
                [NPasswordField3 resignFirstResponder];
                [NPasswordField2 becomeFirstResponder];
                break;
            case 8:
                [NPasswordField4 resignFirstResponder];
                [NPasswordField3 becomeFirstResponder];
                break;
            case 9:
                [confirmPasswordField1 resignFirstResponder];
                [NPasswordField4 becomeFirstResponder];
                break;
            case 10:
                [confirmPasswordField2 resignFirstResponder];
                [confirmPasswordField1 becomeFirstResponder];
                break;
            case 11:
                [confirmPasswordField3 resignFirstResponder];
                [confirmPasswordField2 becomeFirstResponder];
                break;
            case 12:
                [confirmPasswordField4 resignFirstResponder];
                [confirmPasswordField3 becomeFirstResponder];
                break;
                
            default:
                break;
        }
    }
    
    else{
        switch ([sender tag])
        {
            case 1:
                [oldPasswordField1 resignFirstResponder];
                [oldPasswordField2 becomeFirstResponder];
                break;
            case 2:
                [oldPasswordField2 resignFirstResponder];
                [oldPasswordField3 becomeFirstResponder];
                break;
            case 3:
                [oldPasswordField3 resignFirstResponder];
                [oldPasswordField4 becomeFirstResponder];
                break;
            case 4:
                [oldPasswordField4 resignFirstResponder];
                [NPasswordField1 becomeFirstResponder];
                break;
            case 5:
                [NPasswordField1 resignFirstResponder];
                [NPasswordField2 becomeFirstResponder];
                break;
            case 6:
                [NPasswordField2 resignFirstResponder];
                [NPasswordField3 becomeFirstResponder];
                break;
            case 7:
                [NPasswordField3 resignFirstResponder];
                [NPasswordField4 becomeFirstResponder];
                break;
            case 8:
                [NPasswordField4 resignFirstResponder];
                [confirmPasswordField1 becomeFirstResponder];
                break;
            case 9:
                [confirmPasswordField1 resignFirstResponder];
                [confirmPasswordField2 becomeFirstResponder];
                break;
            case 10:
                [confirmPasswordField2 resignFirstResponder];
                [confirmPasswordField3 becomeFirstResponder];
                break;
            case 11:
                [confirmPasswordField3 resignFirstResponder];
                [confirmPasswordField4 becomeFirstResponder];
                break;
            case 12:
                [confirmPasswordField4 resignFirstResponder];
                break;
                
            default:
                break;
        }
    }
    
}
#pragma mark - end

#pragma mark - Textfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.keyboardControls setActiveField:textField];
    
    if ((textField==oldPasswordField1) || (textField==oldPasswordField2) || (textField==oldPasswordField3) || (textField==oldPasswordField4));
    else{
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y- (3.0 * textField.frame.size.height)) animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]]
        isEqualToString:@""])
    {
        check=1;
        return YES;
    }
    
    else{
        
        if ([textField.text length]==0)
        {
            return YES;
        }
        else
        {
            [self textchange:textField];
            return NO;
        }
        
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



#pragma mark - Button Action
//Action for calling change password webservice
- (IBAction)submit:(UIButton *)sender {
    
    NSString *Npassword=[NSString stringWithFormat:@"%@%@%@%@",NPasswordField1.text,NPasswordField2.text,NPasswordField3.text,NPasswordField4.text];
    NSString *confirmPassword=[NSString stringWithFormat:@"%@%@%@%@",confirmPasswordField1.text,confirmPasswordField2.text,confirmPasswordField3.text,confirmPasswordField4.text];
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                           animated:NO];
    [self.view endEditing:YES];
    
    NSString *message;
    // message=@"Please fill all fields";
    
    if(oldPasswordField1.text.length==0 || oldPasswordField2.text.length==0 || oldPasswordField3.text.length==0 || oldPasswordField4.text.length==0){
        //message=@"Please fill all fields of old password.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the old password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    if (NPasswordField1.text.length==0 || NPasswordField2.text.length==0 || NPasswordField3.text.length==0 || NPasswordField4.text.length==0) {
        //message=@"Please fill all fields of new password.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the new password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    if (confirmPasswordField1.text.length==0 || confirmPasswordField2.text.length==0 || confirmPasswordField3.text.length==0 || confirmPasswordField4.text.length==0) {
        //message=@"Please fill all fields of new password.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the confirm password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    if (![Npassword isEqualToString:confirmPassword]) {
        message=@"Password and confirm password must be same.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    [myDelegate ShowIndicator];
    //Method for change password request from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(callChangePassword) toTarget:self withObject:nil];
}

- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - end

#pragma mark - Change Password API Call

//Change password Webservice
-(void)callChangePassword
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int myUserId = (int)[prefs integerForKey:@"checkUserId"];
        NSString *currentPassword=[NSString stringWithFormat:@"%@%@%@%@",oldPasswordField1.text,oldPasswordField2.text,oldPasswordField3.text,oldPasswordField4.text];
        NSString *Npassword=[NSString stringWithFormat:@"%@%@%@%@",NPasswordField1.text,NPasswordField2.text,NPasswordField3.text,NPasswordField4.text];
        
        NSDictionary *requestDict = @{@"userId":[NSNumber numberWithInt:myUserId],@"currentPassword":currentPassword,@"newPassword":Npassword};
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"changePassword"];
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        // NSLog(@"totalBodyData is %@",tempDict1);
        
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:myDelegate.userId forKey:@"checkUserId"];
            [prefs synchronize];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert setTag:1];
            [alert show];
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


#pragma mark - Alert View
//Poping to my profile view after password changed successfully
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alert.tag == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - end



@end
