//
//  NullValueChecker.h
//  Pixebadge
//
//  Created by shiv vaishnav on 28/05/14.
//  Copyright (c) 2014 Ranosys Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NullValueChecker : NSObject
+ (NSMutableDictionary *)checkDictionaryForNullValue: (NSMutableDictionary *)dict;
+ (NSMutableArray *)checkArrayForNullValue: (NSMutableArray *)array;
@end
