//
//  GlobalNavigationBackButton.h
//  PriceTag
//
//  Created by Ranosys on 14/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalNavigationBackButton : NSObject
@property(nonatomic,retain) UIViewController *myVC;
+(UIBarButtonItem *)customizeMyNavigationBar:(UIViewController *)View;
@end
