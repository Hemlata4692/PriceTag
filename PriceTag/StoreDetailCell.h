//
//  StoreDetailCell.h
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface StoreDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeOutlet;
@property (weak, nonatomic) IBOutlet UIButton *unlikeOutlet;
@property (weak, nonatomic) IBOutlet UILabel *totalLikes_lbl;
@property (weak, nonatomic) IBOutlet UILabel *totalDislikes_lbl;

@end
