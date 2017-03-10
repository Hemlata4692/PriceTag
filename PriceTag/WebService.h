//
//  WebService.h
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface WebService : NSObject
+(NSString *)callLoginWebService :(NSString *)jsonString cipher:(NSString *)cipher;
+(NSDictionary *)generateJsonAndCallApi : (NSDictionary *)requestDict methodName :(NSString *)methodName;
@end
