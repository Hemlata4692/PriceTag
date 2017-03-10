//
//  PriceMonitorModal.h
//  PriceTag
//
//  Created by Ranosys on 11/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceMonitorModal : NSObject
@property(nonatomic, strong) NSString* product_name;
@property(nonatomic, strong) NSString* store_name;
@property(nonatomic, strong) NSString* currentPrice;
@property(nonatomic, strong) NSString* previousPrice;
@property(nonatomic, assign) int product_id;

@end
