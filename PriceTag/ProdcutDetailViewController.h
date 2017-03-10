//
//  ProdcutDetailViewController.h
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalMethod.h"

@class commentsCell;
@class ProductDetailCell;

@interface ProdcutDetailViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *storeTableView;
@property (weak, nonatomic) IBOutlet UIView *buttonTabView;
@property (weak, nonatomic) IBOutlet UIButton *nearbyBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCommentBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTxtBox;

@property (strong, nonatomic) IBOutlet commentsCell *comment;
@property (strong, nonatomic)IBOutlet ProductDetailCell *productCell;
@property(nonatomic,assign)int screenCounter;
@property (weak, nonatomic) IBOutlet UIView *textView;

- (IBAction)selectedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic) NSString *productId;

- (IBAction)moveBack:(id)sender;

- (IBAction)addComment:(id)sender;
@property(nonatomic,retain)NSMutableArray * data_array;
@property(nonatomic,retain)NSMutableArray * commentArray;
@property(nonatomic,retain)NSMutableArray * nearByArray;

//product_details
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productWeight;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *productBarcode;

@property(nonatomic,retain) NSString *productImageUrl;
@property(nonatomic,retain)NSString *product_Name;
@property(nonatomic,retain)NSString *product_Weight;
@property(nonatomic,retain)NSString *product_Unit;
@property(nonatomic,retain) NSString *Product_Barcode;

//timer
@property (retain, nonatomic) NSString *todayDate;
@property (retain, nonatomic) NSString *endingDate;

@property (weak, nonatomic) IBOutlet UILabel *noRecord;
@end
