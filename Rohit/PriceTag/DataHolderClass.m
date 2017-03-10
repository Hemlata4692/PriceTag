//
//  DataHolderClass.m
//  PriceTag
//
//  Created by Sumit on 12/08/14.
//  Copyright (c) 2014 Sumit. All rights reserved.
//


@implementation DataHolderClass
@synthesize product_id;
@synthesize product_name;
@synthesize product_price;
@synthesize productImg_url;
@synthesize product_barcode,product_unit,product_weight;

//synthesize for offer ticker module
@synthesize offer_id,offer_name,offer_subcategories,offerImg_url,offerCellBg,category_name,subcategory_name;
//end


//synthesize for submitted price
@synthesize likeDislikeFlag;
@synthesize flagForLike;
@synthesize submittedProductPriceId;
@synthesize totalDislikes;
@synthesize totalLikes;
@synthesize timeSubmitted;
@synthesize userName;
@synthesize currentRank;
@synthesize previousRank;
//end

//add product/submit price
@synthesize store_id,store_location,store_name;
//end

//variables for usercommnet on product Detail Screen
@synthesize user_name,user_comment,user_image_url;
//end

//variables for nearby stores on  Product Detail Screen
@synthesize storeDistance_nearby,storeUnit_nearby,productPrice_nearby,storeName_nearby,storeLocation_nearby;

@end
