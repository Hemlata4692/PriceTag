//
//  ProductDetailCell.h
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface ProductDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnitLbl;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dollarLbl;

@end
