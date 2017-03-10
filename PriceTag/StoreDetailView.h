//
//  StoreDetailView.h
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDetailCell.h"

@interface StoreDetailView : UIViewController
{
    __weak IBOutlet UITableView *storeTableView;
    __weak IBOutlet UILabel *noRecord_lbl;
     __weak IBOutlet UILabel *timer_lbl;
    
    
}
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *separator1View;
@property (weak, nonatomic) IBOutlet UIView *separator2View;
@property(weak,nonatomic)IBOutlet StoreDetailCell *cell;

@property(nonatomic,retain)NSString * product_id;
@property(nonatomic,retain)NSString * productname_nearby;
@property(nonatomic,retain)NSString * productWeight_nearby;
@property(nonatomic,retain)NSString * productUnit_nearby;
@property(nonatomic,retain)NSString * ProductImageUrl_nearby;
@property(nonatomic,retain)NSString * productBarcode_nearby;

@property(nonatomic,retain)NSMutableArray * data_array;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *Product_Name;
@property (weak, nonatomic) IBOutlet UILabel *product_Weight;
@property (weak, nonatomic) IBOutlet UILabel *Product_Barcode;

@property(nonatomic,retain) NSString *imageUrlProduct;
@property(nonatomic,retain)NSString *nameProduct;
@property(nonatomic,retain)NSString *weightProduct;
@property(nonatomic,retain)NSString *unitProduct;
@property(nonatomic,retain) NSString *barcodeProduct;
@property(nonatomic,retain)NSString * start_date;
@property(nonatomic,retain)NSString * end_date;

@end
