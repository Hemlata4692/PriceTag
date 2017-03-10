//
//  ProductNotAvailViewController.h
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "BarCodeViewController.h"
@interface ProductNotAvailViewController : UIViewController

- (IBAction)backBtn:(id)sender;
- (IBAction)addProductBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, retain)BarCodeViewController *myobj;
@property(nonatomic,retain) NSMutableArray *ResultArray;
@property(nonatomic, retain) NSString* BarCodeData;
@property (weak, nonatomic) IBOutlet UILabel *noRecord;
@end
