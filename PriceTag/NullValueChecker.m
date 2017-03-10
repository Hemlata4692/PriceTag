//
//  NullValueChecker.m
//  Pixebadge
//
//  Created by shiv vaishnav on 28/05/14.
//  Copyright (c) 2014 Ranosys Technologies Pvt Ltd. All rights reserved.
//

#import "NullValueChecker.h"

@implementation NullValueChecker

+ (NSMutableDictionary *)checkDictionaryForNullValue: (NSMutableDictionary *)dict{

    for (int i = 0; i < [[dict allValues] count]; i++) {
        id value = [dict allValues][i];
        if ([value isKindOfClass:[NSNull class]] || value == (id)[NSNull null] || value == NULL || [value isEqual:@"<null>"]){
            [dict setObject:@"" forKey:[dict allKeys][i]];
            
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            [dict setObject:[NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)value]] forKey:[dict allKeys][i]];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            [dict setObject:[NullValueChecker checkArrayForNullValue:[NSMutableArray arrayWithArray:(NSArray *)value]] forKey:[dict allKeys][i]];
        }
    }
    return dict;
}
+ (NSMutableArray *)checkArrayForNullValue: (NSMutableArray *)array{
    for (int i = 0; i < [array count]; i++) {
        id value = array[i];
        if ([value isKindOfClass:[NSNull class]] || value == (id)[NSNull null] || value == NULL || [value isEqual:@"<null>"])
        {
            [array removeObjectAtIndex:i];
            [array insertObject:@"" atIndex:i];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            [array removeObjectAtIndex:i];
            [array insertObject:[NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)value]] atIndex:i];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            [array removeObjectAtIndex:i];
            [array insertObject:[NullValueChecker checkArrayForNullValue:[NSMutableArray arrayWithArray:(NSArray *)value]] atIndex:i];
        }
    }
    return array;
}
@end
