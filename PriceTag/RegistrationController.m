//
//  RegistrationController.m
//  PriceTag
//
//  Created by Ranosys on 06/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "RegistrationController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Base64.h"
#import "VerficationController.h"
#import "UIImageView+WebCache.h"
#import "Terms_PolicyView.h"

@interface RegistrationController ()
{
    UIImagePickerController *picker;
    UIImage *image;
    int check;
    NSDictionary *jsonDictionary;
    int tag;
    UIImage *scaledImage;
}
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;

@end

@implementation RegistrationController
@synthesize imageGallery,userName,emailAddress,passwordField1,passwordField2,passwordField3,passwordField4,confirmPasswordField1,confirmPasswordField2,confirmPasswordField3,confirmPasswordField4,scrollView,jsonDictionary;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFBSessionStateChangeWithNotification:)name:@"RegSessionStateChangeNotification" object:nil];
    //facebook
    
    [termsAndCondition_Btn setSelected:YES];
    //Setting textfield delegates
    userName.delegate=self;
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
    userName=[GlobalMethod customPadding:self.userName];
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
    
    NSDictionary *attrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName : [UIColor blackColor]};
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Terms of Use" attributes: attrDict];
    
    // making text property to underline text-
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length]) ];
    
    // using text on button
    [self.termOfUseOutlet setAttributedTitle: titleString forState:UIControlStateNormal];
    NSMutableAttributedString *titleString1 = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy." attributes: attrDict];
    
    // making text property to underline text-
    [titleString1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString1 length])];
    
    // using text on button
    [self.privacyPolicyOutlet setAttributedTitle: titleString1 forState:UIControlStateNormal];
    

    imageGallery.layer.cornerRadius = imageGallery.frame.size.width / 2;
    imageGallery.clipsToBounds = YES;
    
    [imageGallery.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [imageGallery.layer setBorderWidth: 2.0];
    
    //method to handle textfield to change while entering old, new and confirm password
    [passwordField1 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    [passwordField2 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    [passwordField3 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    [passwordField4 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    
    [confirmPasswordField1 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField2 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField3 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    [confirmPasswordField4 addTarget:self action:@selector(textchangeRegisterView:) forControlEvents:UIControlEventEditingChanged];
    
    NSArray *fields = @[userName,emailAddress,passwordField1,passwordField2,passwordField3,passwordField4,confirmPasswordField1,confirmPasswordField2,confirmPasswordField3,confirmPasswordField4];
    
    //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    
}
//Action to check uncheck the agree conditions of terms-conditions and privacy policy
- (IBAction)checkBoxBtnClicked:(id)sender
{
    
    if([sender isSelected])
    {
        
        [sender setSelected:NO];
        
    }
    else
    {
        [sender setSelected:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //facebook
    
    // Observe for the custom notification regarding the session state change.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFBSessionStateChangeWithNotification:)name:@"RegSessionStateChangeNotification" object:nil];
    //facebook
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"REGISTER";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end


#pragma mark - Facebook login
//Login with facebook
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    // Get the session, state and error values from the notification's userInfo dictionary.
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   
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
                                              //  NSLog(@"%@", result);
                                              
                                              userName.text=[NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                                              
                                              emailAddress.text=[result objectForKey:@"email"];
                                              [myDelegate StopIndicator];

                                              [imageGallery sd_setImageWithURL:[NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"add_photo.png"]];
                                              [myDelegate StopIndicator];
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

#pragma mark - Password Textfield blocks action performed
//This method is used to handle previous next actions in the textfields
-(void)textchangeRegisterView:(id)sender
{
    
    if(check==1)
    {
        check=0;
        if ([sender tag]==3)
        {
            [passwordField1 resignFirstResponder];
        }
        else if ([sender tag]==4)
        {
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
        else if ([sender tag]==9)
        {
            [confirmPasswordField3 resignFirstResponder];
            [confirmPasswordField2 becomeFirstResponder];
            
        }
        else if ([sender tag]==10)
        {
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
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    if (textField!=userName)
    {
        [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(2.5* textField.frame.size.height)) animated:YES];
    }
    else
    {
        userName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    
}

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
    
    else
    {
        
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
                //Calling textfield change handle action
                [self textchangeRegisterView:textField];
                return NO;
            }
        }
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



#pragma mark - Call Register User API

//Action for rescaling image to avoid memory pressure
-(UIImage *)imageWithImage:(UIImage *)image1 scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//Register user web service to request server to register new user
-(void)registerUser
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSString *strEncoded;
        if (imageGallery.image !=[UIImage imageNamed:@"add_photo.png"])
        {
            //Scalling image to avoid memory pressure
//            CGFloat compression = 0.9f;
//            CGFloat maxCompression = 0.01f;
//            int maxFileSize = 250*500;
            
            NSData *imageData = UIImageJPEGRepresentation(imageGallery.image, 1.0);
            strEncoded = [Base64 encode:imageData];
//            while ([imageData length] > maxFileSize && compression > maxCompression)
//            {
//                compression -= 0.1;
//                imageData = UIImageJPEGRepresentation(image, compression);
//            }
            
            scaledImage=[UIImage imageWithData:imageData];
            CGSize scale;
            scale.height=200;
            scale.width=200;
            scaledImage = [self imageWithImage:scaledImage scaledToSize:scale];
            imageData = UIImageJPEGRepresentation(scaledImage, 0.01);
            strEncoded = [Base64 encode:imageData];
            
        }
        else
        {
            strEncoded =@"";
        }
        
        
        NSString *password=[NSString stringWithFormat:@"%@%@%@%@",passwordField1.text,passwordField2.text,passwordField3.text,passwordField4.text];
        NSDictionary *requestDict = @{@"name":userName.text,@"email":emailAddress.text,@"password":password,@"profile_photo":strEncoded};
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"registerUser"];
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        
        //  NSLog(@"totalBodyData is %@",tempDict1);
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:emailAddress.text forKey:@"checkLoginText"];
            [prefs synchronize];
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            VerficationController *verifiedView=[sb instantiateViewControllerWithIdentifier:@"VerficationController"];
            verifiedView.email=emailAddress.text;
            [self.navigationController pushViewController:verifiedView animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 0 && tempDict1 !=NULL)
            {
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

//Terms and condition web service to display terms-conditions and privacy policy
-(void)termsCondition:(NSString*)string
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
        
        NSDictionary *requestDict = @{@"name":string};
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"getCmsContent"];
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        
        // NSLog(@"totalBodyData is %@",tempDict1);
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            Terms_PolicyView *verifiedView1=[sb instantiateViewControllerWithIdentifier:@"Terms_PolicyView"];
            verifiedView1.buttonTag=tag;
            verifiedView1.TermsPolicy=[jsonDictionary valueForKey:@"cmsContent"];
            [self.navigationController pushViewController:verifiedView1 animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    }
}

#pragma mark - end


#pragma mark - Button Action
//Action for register user web service to register new user
- (IBAction)submit:(UIButton *)sender
{
    
    NSString *password=[NSString stringWithFormat:@"%@%@%@%@",passwordField1.text,passwordField2.text,passwordField3.text,passwordField4.text];
    NSString *confirmPassword=[NSString stringWithFormat:@"%@%@%@%@",confirmPasswordField1.text,confirmPasswordField2.text,confirmPasswordField3.text,confirmPasswordField4.text];
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.view endEditing:YES];
    
    //Alert messages if textfield is empty
    NSString *message;
    message=@"Please fill in all fields";
    if(userName.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    if(emailAddress.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    if((passwordField1.text.length==0) || (passwordField2.text.length==0) || (passwordField3.text.length==0) || (passwordField4.text.length==0))
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    if((confirmPasswordField1.text.length==0) || (confirmPasswordField2.text.length==0) || (confirmPasswordField3.text.length==0) || (confirmPasswordField4.text.length==0))
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    //Password confirmation for new password entered
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
    else if (![termsAndCondition_Btn isSelected])
    {
        message=@"Please accept terms and conditions.";
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    [myDelegate ShowIndicator];
    //Method for requseting new user registration from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(registerUser) toTarget:self withObject:nil];
}

//Action for setting user image
- (IBAction)takeAndSelectPhoto:(UIButton *)sender
{
    UIActionSheet *share=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing Photo", nil];
    [share showInView:self.view];
}

//Action to verify code view
- (IBAction)verifiedCode:(UIButton *)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VerficationController *verifiedView=[sb instantiateViewControllerWithIdentifier:@"VerficationController"];
    [self.navigationController pushViewController:verifiedView animated:YES];
}

//Login with facebook action
- (IBAction)signUpWithFB:(UIButton *)sender
{
    if ([FBSession activeSession].state != FBSessionStateOpen && [FBSession activeSession].state != FBSessionStateOpenTokenExtended)
    {
        [[FBSession activeSession] closeAndClearTokenInformation];
        
        myDelegate.CheckController=false;
        [myDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
    }
    else
    {
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
        
        myDelegate.CheckController=false;
        [myDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
    }
}

//Action for terms and conditions webservice for terms and conditions
- (IBAction)terms_conditions:(id)sender
{
    [myDelegate ShowIndicator];
    tag=(int)[sender tag];
    [self performSelector:@selector(termsCondition:) withObject:@"Terms" afterDelay:0.3];
    
}

//Action for terms and conditions webservice for privacy policy
- (IBAction)privacy_policy:(id)sender
{
    [myDelegate ShowIndicator];
    tag=(int)[sender tag];
    [self performSelector:@selector(termsCondition:) withObject:@"Privacy" afterDelay:0.3];
    
}

#pragma mark - end
//Action sheet for capturing images from camera and gallery
#pragma mark - Actionsheet
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
    {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
        //NSData *pngData = UIImageJPEGRepresentation(image, .5);
    }
    
    else if(buttonIndex==1)
    {
        
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark - end

#pragma mark - Gallery Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Picking image from image gallery or capturing from device
    image= [info objectForKey:UIImagePickerControllerOriginalImage];
    imageGallery.image = image;
    myDelegate.imageCheck=true;
    
    [picker1 dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    
    [picker1 dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - end





@end
