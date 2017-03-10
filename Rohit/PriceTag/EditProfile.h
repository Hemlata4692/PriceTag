//
//  EditProfile.h
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


#import "MyProfileController.h"


@class MyProfileController;
@interface EditProfile : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageGallery;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;


- (IBAction)submit:(UIButton *)sender;
- (IBAction)takeAndSelectPhoto:(UIButton *)sender;
- (IBAction)backButton:(UIButton *)sender;

@property(nonatomic, retain) UIImage *myImage;
@property(nonatomic, retain) MyProfileController *profileObj;
@property(nonatomic, retain) NSString *name;
@property(nonatomic,retain)NSString * img_url;

@end
