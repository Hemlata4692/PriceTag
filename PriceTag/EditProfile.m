//
//  EditProfile.m
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "EditProfile.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Base64.h"
#import "UIImageView+WebCache.h"
@interface EditProfile ()
{
    UIImagePickerController *picker;
    UIImage *image;
    int check;
    NSDictionary *jsonDictionary;
    UIImage *scaledImage;
    int sourceType;
}
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation EditProfile
@synthesize imageGallery,userName,emailAddress,scrollView,profileObj,jsonDictionary;
@synthesize img_url;

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
    userName.delegate=self;
    emailAddress.delegate=self;
    
    self.view=[GlobalMethod customView:self.view];
    
    // left of padding textfield
    userName=[GlobalMethod customPadding:self.userName];
    emailAddress=[GlobalMethod customPadding:self.emailAddress];
   
    imageGallery.layer.cornerRadius = imageGallery.frame.size.width / 2;
    imageGallery.clipsToBounds = YES;
    [imageGallery.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [imageGallery.layer setBorderWidth: 2.0];
    picker = [[UIImagePickerController alloc] init];
    
    if ([myDelegate.DBemail isEqualToString:@""]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.emailAddress.text = [prefs stringForKey:@"checkLoginText"];
    }
    else{
        self.emailAddress.text=myDelegate.DBemail;
    }
    emailAddress.enabled=NO;
    
    if (self.myImage!=nil) {
        self.imageGallery.image=_myImage;
    }
   
    if ([self.name isEqualToString:@""]) {
        self.userName.text=@"";
    }
    else
    {
        self.userName.text=self.name;
    }
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"EDIT PROFILE";
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


#pragma mark - Textfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
     [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(4.0* textField.frame.size.height)) animated:YES];
    
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


#pragma mark - Actionsheet
//Action sheet for setting image from camera or gallery
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
    {
        //Setting image from camera
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        [self presentViewController:picker animated:YES completion:NULL];
        sourceType = 0;
        
    }
    
    else if(buttonIndex==1)
    {
        //Setting image from gallery
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        sourceType = 1;
    }
}
#pragma mark - end


#pragma mark - Gallery Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    if (sourceType==1)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else if (sourceType==0)
    {
        image = info[UIImagePickerControllerEditedImage];
    }
    
    
    
    imageGallery.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1 {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - end


#pragma mark - Button Action
//Action to edit user profile photo
- (IBAction)takeAndSelectPhoto:(UIButton *)sender {
    UIActionSheet *share=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Existing Photo", nil];
    //when no use tabbar-> [share showInView:self.view];
    [share showFromTabBar:[[self tabBarController] tabBar]];
}

//Action for calling edit profile web service
- (IBAction)submit:(UIButton *)sender
{
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1)
                           animated:NO];
    [self.view endEditing:YES];
    
    NSString *message;
    if(userName.text.length==0)
    {
        message=@"Please enter your name.";
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        
        return;
    }
    
    [myDelegate ShowIndicator];
    //Method for edit profile request from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(callEditProfile) toTarget:self withObject:nil];
    
}

- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - end

#pragma mark - Edit Profile API Call
//Rescaling image to avoid memory pressure

-(UIImage *)imageWithImage:(UIImage *)image1 scaledToSize:(CGSize)newSize {
   
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//Edit profile web service
-(void)callEditProfile
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        
        //Scaling image
        NSData *imageData = UIImageJPEGRepresentation(imageGallery.image, 1.0);
      NSString *  strEncoded = [Base64 encode:imageData];
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

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int myUserId = (int)[prefs integerForKey:@"checkUserId"];
        //json request
        NSDictionary *requestDict = @{@"userId":[NSNumber numberWithInt:myUserId],@"name":userName.text,@"profile_photo":strEncoded};
       
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"editProfile"];
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
       
        [myDelegate StopIndicator];
        if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
        {
            [[SDImageCache sharedImageCache] removeImageForKey:img_url fromDisk:YES];
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
            else if (tempDict1==NULL)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
//Pop to profile view when profile is edited sucessfully
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alert.tag == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - end
@end

