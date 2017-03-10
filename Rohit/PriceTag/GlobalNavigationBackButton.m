//
//  GlobalNavigationBackButton.m
//  PriceTag
//
//  Created by Ranosys on 14/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "GlobalNavigationBackButton.h"

@implementation GlobalNavigationBackButton
@synthesize myVC;
+(UIBarButtonItem *)customizeMyNavigationBar:(UIViewController *)View{
    //NavController.navigationBarHidden =YES;
    //0  101  178
//    NSString *ver = [[UIDevice currentDevice] systemVersion];
//    int ver_int = [ver intValue];
//    
//    if (ver_int < 7)
//    {
//        [NavController.navigationBar setTintColor:[UIColor colorWithRed:46.0/255.0 green:165.0/255.0 blue:255.0/255.0 alpha:1.0]];
//    }
//    
//    else
//    {
//        NavController.navigationBar.barTintColor = [UIColor colorWithRed:46.0/255.0 green:165.0/255.0 blue:255.0/255.0 alpha:1.0];
//    }
//    // Do any additional setup after loading the view.
//    CGRect frame = CGRectMake(0, 0, 48, 44);
//    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:RobotoBoldFont size:17];
//    label.textAlignment = NSTextAlignmentRight;
//    label.textColor = [UIColor whiteColor];
//    label.text = Title;
    
//    UIImage *buttonImage;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 47, 22)];
//    if(!isRootView)
//    {
//        [button setTitle:@"back" forState:UIControlStateNormal];
//        item.leftBarButtonItem.title = @"back";
//        [button addTarget:View action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    
//    button.frame = CGRectMake(0, 0, 54, 22);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
//    item.leftBarButtonItem.title = @"back";
    [button addTarget:View action:@selector(goBackButton) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    item.leftBarButtonItem = customBarItem;
//    item.titleView = label;
    return customBarItem;
    
}

//-(IBAction) goBackButton: (id)sender{
//    [myVC.navigationController popViewControllerAnimated:YES];
//}



@end
