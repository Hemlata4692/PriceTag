//
//  DataHolderClass.h
//  PriceTag
//
//  Created by Sumit on 12/08/14.
//  Copyright (c) 2014 Sumit. All rights reserved.
//


@interface DataHolderClass : NSObject

@property(nonatomic,assign)int noOfEntries;

@property(nonatomic,retain)NSString * product_id;
@property(nonatomic,retain)NSString * productImg_url;
@property(nonatomic,retain)NSString * product_name;
@property(nonatomic,retain)NSString * product_price;
@property(nonatomic,retain)NSString * product_barcode;
@property(nonatomic,retain)NSString * product_weight;
@property(nonatomic,retain)NSString * product_unit;

//variables for offer ticker screen
@property(nonatomic,retain)NSString * offer_id;
@property(nonatomic,retain)NSString * offer_name;
@property(nonatomic,retain)NSString * category_name;
@property(nonatomic,retain)NSString * subcategory_name;
@property(nonatomic,retain)NSString * offer_subcategories;
@property(nonatomic,retain)NSString * offerImg_url;
@property(nonatomic,retain)NSString * offerCellBg;
//end

//variables for offer ticker subcategory list
@property(nonatomic,retain)NSString * subCatName;
@property(nonatomic,retain)NSString * tickerContent;
//end

//add product/submit price
@property(nonatomic,retain)NSString * store_id;
@property(nonatomic,retain)NSString * store_name;
@property(nonatomic,retain)NSString * store_location;
//end

//variables for submitted price screen
@property(nonatomic,retain)NSString * flagForLike;
@property(nonatomic,assign)BOOL likeDislikeFlag;
@property(nonatomic,retain)NSString * submittedProductPriceId;
@property(nonatomic,retain)NSString * totalDislikes;
@property(nonatomic,retain)NSString * totalLikes;
@property(nonatomic,retain)NSString * timeSubmitted;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,assign)int currentRank;
@property(nonatomic,assign)int previousRank;
@property(nonatomic,assign)int userId;
//end

//variables for usercommnet on  Product Detail Screen
@property(nonatomic,retain) NSString *user_name;
@property(nonatomic,retain) NSString *user_image_url;
@property(nonatomic,retain) NSString *user_comment;
//end

//variables for nearby stores on  Product Detail Screen
@property(nonatomic,retain) NSString *storeDistance_nearby;
@property(nonatomic,retain) NSString *storeUnit_nearby;
@property(nonatomic,retain) NSString *storeLocation_nearby;
@property(nonatomic,retain) NSString *productPrice_nearby;
@property(nonatomic,retain) NSString *storeName_nearby;
//end
@end
