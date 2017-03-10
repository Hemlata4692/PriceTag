//
//  Internet.m
//  RKPharma
//
//  Created by shiv vaishnav on 16/05/13.
//  Copyright (c) 2013 shivendra@ranosys.com. All rights reserved.
//


@implementation Internet
{
    Reachability *reachability;
}
-(BOOL) start 
{
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
     NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
     if(remoteHostStatus == NotReachable) 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"The internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       [alert show];
    
        return YES;
    }
    else
    {
        return NO;
    }
    
}
@end
