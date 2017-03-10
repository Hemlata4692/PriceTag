//
//  WebService.m
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "WebService.h"

@implementation WebService

+(NSString *)callLoginWebService :(NSString *)jsonString cipher:(NSString *)cipher
{
    NSLog(@"JSON from my side === %@", jsonString);
    NSString * postString = [NSString stringWithFormat:@"%@",jsonString];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",cipher]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
    
	[request setValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
	//[request setValue:cipher forHTTPHeaderField:@"cipher"];
	//[request setValue:@"User-logIn" forHTTPHeaderField:@"method"];
	
	//[request setValue:key forHTTPHeaderField:@"key"];
	[request setHTTPBody:postData];
	
	NSError *error;
	NSHTTPURLResponse *response;
	
    NSData *ResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *responseString = [[NSString alloc]initWithData:ResponseData encoding:NSUTF8StringEncoding];
	//[ResponseData release];
	
	NSDictionary *headerData = [response allHeaderFields];
	NSMutableDictionary * BodyData = [NSMutableDictionary dictionary];
	

	if (ResponseData == (id)[NSNull null]|| ResponseData== NULL || ResponseData== nil || (NSNull *)ResponseData == [NSNull null])
	{
		//NSLog(@"JSON Response nil");
		NSString *temp = @"SERVER IS DOWN";
		ResponseData = [temp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
		[BodyData setObject:ResponseData forKey:@"MainData"];
	}
	else
	{
		[BodyData setObject:ResponseData forKey:@"MainData"];
		[BodyData setObject:headerData forKey:@"headerData"];
	}
	
return responseString;
}

+(NSDictionary *)generateJsonAndCallApi : (NSDictionary *)requestDict methodName :(NSString *)methodName
{
    NSString * finalSendingStr = [requestDict JSONString];
    NSString *strUrl=[NSString stringWithFormat:@"%@%@/",webUrl,methodName];
    NSString *d=[WebService callLoginWebService:finalSendingStr cipher:strUrl];
    NSDictionary * jsonDictionary = [d objectFromJSONString];
    return jsonDictionary;

}
@end
