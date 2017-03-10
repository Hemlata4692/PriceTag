//
//  AddProductViewController.h
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ProductNotAvailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MJGeocodingServices.h"




@interface AddProductViewController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,BSKeyboardControlsDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate, MJGeocoderDelegate>
{
    
    CLLocationManager *locationManager;
    MJGeocoder *forwardGeocoder;
    UIPickerView *myPickerView;
    NSMutableArray *pickerArrayOther;
    NSArray *pickerArrayMeasure;
   NSArray *displayedResults;
}

- (IBAction)backBtn:(id)sender;

@property (retain, nonatomic)NSMutableArray *pickerArrayOther;
@property (retain, nonatomic)NSArray *pickerArrayMeasure;
@property (retain, nonatomic)NSArray *displayedResults;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIImageView *addPhoto;
@property (retain, nonatomic) IBOutlet UITextField *productName;
@property (retain, nonatomic) IBOutlet UITextField *barCode;
//@property (retain, nonatomic) IBOutlet UITextField *other;
//@property (retain, nonatomic) IBOutlet UITextField *storeName;
//@property (retain, nonatomic) IBOutlet UITextField *location;
//@property (retain, nonatomic) IBOutlet UITextField *price;
@property (retain, nonatomic) IBOutlet UITextField *weight;
@property (retain, nonatomic) IBOutlet UITextField *measure;
@property (retain, nonatomic) IBOutlet UIButton *submitOutlet;

- (IBAction)submitBtn:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *otherImgView;
@property (retain, nonatomic) IBOutlet UIImageView *otherPNG;
//@property (retain, nonatomic) IBOutlet UIImageView *storenameImgView;
//@property (retain, nonatomic) IBOutlet UIImageView *storenamePNG;
//@property (retain, nonatomic) IBOutlet UIImageView *locationImgView;
//@property (retain, nonatomic) IBOutlet UIImageView *locationPNG;
//@property (retain, nonatomic) IBOutlet UIImageView *priceImgView;
//@property (retain, nonatomic) IBOutlet UIImageView *pricePNG;
@property (retain, nonatomic) IBOutlet UIImageView *weightImgView;
@property (retain, nonatomic) IBOutlet UIImageView *weightPNG;
- (IBAction)addPhotoAction:(id)sender;

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) MJGeocoder *forwardGeocoder;
@property(nonatomic, retain) NSString* BarCodeValue;

@end
