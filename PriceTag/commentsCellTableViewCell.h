//
//  commentsCellTableViewCell.h
//  PriceTag
//
//  Created by Sumit on 11/08/14.
//  Copyright (c) 2014 Sumit. All rights reserved.
//


@interface commentsCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *ImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *myComment;

@end
