//
//  CustomTextfield.m
//  PriceTag
//
//  Created by Ranosys on 05/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@implementation GlobalMethod

+(UITextField *)customPadding:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 38)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    return textfield;
}

+(UITextField *)CustomPassField:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 21, 23)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    textfield.layer.borderColor=[[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0] CGColor];
    textfield.layer.borderWidth=1.0;
    textfield.layer.cornerRadius=2;
    
    textfield.backgroundColor=([UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]);
    return textfield;
}


+(UIView *)customView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:@"login_bg.png"] drawInRect:view.bounds];
    UIImage *backimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:backimage];
    return view;
}

+ (BOOL)isIphone5
{
    if([[UIScreen mainScreen] bounds].size.height==568)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(float)getCurrentLatitude
{
    AppDelegate * myAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    float latitude = myAppDelegate.locationManager.location.coordinate.latitude;
    return latitude;
}


+(float)getCurrentLongitude
{
    AppDelegate * myAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    float longitude = myAppDelegate.locationManager.location.coordinate.longitude;
    return longitude;
}

+(BOOL)validateEmailString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
