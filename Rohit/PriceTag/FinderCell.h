//
//  FinderCell.h
//  PriceTag
//
//  Created by Ranosys on 04/09/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageArrow;
//@property (weak, nonatomic) IBOutlet UIButton *myPositionbtn;
@property (weak, nonatomic) IBOutlet UIImageView *ProductImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameProductLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalEntryLabel;

@end
