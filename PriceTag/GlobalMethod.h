//
//  CustomTextfield.h
//  PriceTag
//
//  Created by Ranosys on 05/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface GlobalMethod : NSObject
+(UITextField *)customPadding:(UITextField*)textfield;
+(UITextField *)CustomPassField:(UITextField*)textfield;
+(UIView *)customView:(UIView*)view;
+ (BOOL)isIphone5;

+(float)getCurrentLongitude;
+(float)getCurrentLatitude;
+(BOOL)validateEmailString:(NSString*)email;
@end
