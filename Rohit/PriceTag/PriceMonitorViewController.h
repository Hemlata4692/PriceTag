//
//  PriceMonitorViewController.h
//  PriceTag
//
//  Created by Ranosys on 04/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceMonitorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *priceMonitorListing;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *noRecord;

@end
