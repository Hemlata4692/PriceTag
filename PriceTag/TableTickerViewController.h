//
//  TableTickerViewController.h
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface TableTickerViewController : UIViewController

- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString  *offerTickerId;
@property (weak, nonatomic) NSString  *categoryName;

@end
