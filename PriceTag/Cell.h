//
//  Cell.h
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface Cell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *offerName;

@end
