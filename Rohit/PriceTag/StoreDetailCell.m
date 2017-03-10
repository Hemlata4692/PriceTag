//
//  StoreDetailCell.m
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "StoreDetailCell.h"

@implementation StoreDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeBtn:(id)sender {
}

- (IBAction)unlikeBtn:(id)sender {
}
@end
