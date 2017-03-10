//
//  ProductAvailableViewController.h
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "MJGeocodingServices.h"


@interface ProductAvailableViewController : UIViewController<UITextFieldDelegate,BSKeyboardControlsDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate, MJGeocoderDelegate>
{
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    
    CLLocationManager *locationManager;
    MJGeocoder *forwardGeocoder;
  	NSArray *displayedResults;
    
    
}
- (IBAction)backBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic) NSArray *pickerArray;
@property(retain,nonatomic)NSArray *displayedResults;
@property (retain, nonatomic) IBOutlet UIView *topSubView;
@property (retain, nonatomic) IBOutlet UIImageView *subViewImage;
@property (retain, nonatomic) IBOutlet UILabel *subViewDesc;
@property (retain, nonatomic) IBOutlet UILabel *subViewDetail;

@property (retain, nonatomic) IBOutlet UITextField *priceTextField;
@property (retain, nonatomic) IBOutlet UITextField *storeNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *locationTextField;
@property (retain, nonatomic) IBOutlet UITextField *otherTextField;

@property (retain, nonatomic) IBOutlet UIButton *submitOutlet;

@property (retain, nonatomic) IBOutlet UIImageView *storeNameImgView;
@property (retain, nonatomic) IBOutlet UIImageView *storeNamePNG;

@property (retain, nonatomic) IBOutlet UIImageView *locationImgView;
@property (retain, nonatomic) IBOutlet UIImageView *locationPNG;

@property(retain,nonatomic) NSString *productId;
@property(retain,nonatomic) NSString *productImage;
@property(retain,nonatomic) NSString *productName;
@property(retain,nonatomic) NSString *productWeight;
@property(retain,nonatomic) NSString *productUnit;

//For finding latitude and longitude
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) MJGeocoder *forwardGeocoder;
@end
