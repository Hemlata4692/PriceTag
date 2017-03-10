//
//  OfferTickerViewController.h
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface OfferTickerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backBtn:(id)sender;
@end
