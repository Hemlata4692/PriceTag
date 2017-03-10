//
//  CustomCell.h
//  PriceTag
//
//  Created by Ranosys on 08/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UIButton *redeemAction;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end
