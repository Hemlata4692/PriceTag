//
//  ProductNotAvailViewController.m
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ProductNotAvailViewController.h"
#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "ProductAvailableViewController.h"
#include "AddProductViewController.h"
#import "ProdcutDetailViewController.h"

@interface ProductNotAvailViewController ()
@end

@implementation ProductNotAvailViewController
@synthesize myobj,ResultArray,BarCodeData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg.png"]];
    BarCodeData=myobj.EnterCodeTxt.text;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=@"SCANNED ITEM";
    
    if(self.ResultArray.count<1)
    {
        self.noRecord.hidden = NO;
    }
    else
    {
        self.noRecord.hidden = YES;
    }
    
    
    self.navigationItem.leftBarButtonItem = nil;
    GlobalNavigationBackButton *global = [GlobalNavigationBackButton new];
    global.myVC = self;
    self.navigationItem.leftBarButtonItem = [GlobalNavigationBackButton customizeMyNavigationBar:self];
    
    //[self setTopbarTitle];
    
}

-(void)goBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated

{
    
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ResultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    DataHolderClass *data;
    data=[ResultArray objectAtIndex:indexPath.row];
    
    // Displaying scanned item results
    cell.descLabel.text=[NSString stringWithFormat:@"%@, %@%@",data.product_name,data.product_weight,data.product_unit];
    
    cell.descLabel.textColor = [UIColor colorWithRed:(31.0/255.0) green:(31.0/255.0) blue:(31.0/255.0) alpha:0.8];
    
    cell.numLabel.text=data.product_barcode;
    cell.numLabel.textColor = [UIColor colorWithRed:(31.0/255.0) green:(31.0/255.0) blue:(31.0/255.0) alpha:0.8];
    
    UIImageView * imgView = (UIImageView *)[cell viewWithTag:1];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:data.productImg_url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.arrow.image=[UIImage imageNamed:@"profileArrow.png"];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Moving to submit price screen of selected product
    DataHolderClass *data=[ResultArray objectAtIndex:indexPath.row];
//    cont.productId=data.product_id;
    [myDelegate ShowIndicator];
    [NSThread detachNewThreadSelector:@selector(addPriceMonitor:) toTarget:self withObject:data];
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ProdcutDetailViewController *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"ProdcutDetailViewController"];
//    objProductDetail.productId=data.product_id;
//    [self.navigationController pushViewController:objProductDetail animated:YES];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ProductAvailableViewController *cont=[storyboard instantiateViewControllerWithIdentifier:@"ProductAvailableViewController"];
//    DataHolderClass *data=[ResultArray objectAtIndex:indexPath.row];
//    cont.productId=data.product_id;
//    cont.productImage=data.productImg_url;
//    cont.productName=data.product_name;
//    cont.productWeight=data.product_weight;
//    cont.productUnit=data.product_unit;
//    [self.navigationController pushViewController:cont animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_found_bg_.png"]];
    //Displaying the number of products found in scanned item list
    UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 4, 320, 30)];
    NSString *Productno = [NSString stringWithFormat:@"%lu Products Found", (unsigned long)ResultArray.count];
    if(ResultArray.count<1)
    {
        tableView.scrollEnabled = NO;
    }
    else
    {
        tableView.scrollEnabled = YES;
    }
    headerLabel.text=Productno;
    headerLabel.font=[UIFont systemFontOfSize:12.0];
    headerLabel.font=[UIFont fontWithName:@"OpenSans" size:12.0];
    headerLabel.textColor=[UIColor colorWithRed:(31.0/255.0) green:(31.0/255.0) blue:(31.0/255.0) alpha:0.8];
    [headerImage addSubview:headerLabel];
    return headerImage;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark - end

//Call add priceMonitor web-service
-(void)addPriceMonitor:(DataHolderClass *)data{
    //    [myDelegate StopIndicator];
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
        NSDictionary *requestDict;
        NSDictionary *jsonDictionary;
        requestDict = @{@"user_Id":myDelegate.userId,@"product_Id":data.product_id};
        //    }
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"addPriceMonitor"];
        
        [myDelegate StopIndicator];
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProdcutDetailViewController *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"ProdcutDetailViewController"];
        objProductDetail.productId=data.product_id;
        [self.navigationController pushViewController:objProductDetail animated:YES];
    }
}

#pragma mark - Button Actions
//Back action
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addProductBtn:(id)sender
{
    //Moving to add product view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddProductViewController *cont=[storyboard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
    cont.BarCodeValue=BarCodeData;
    [self.navigationController pushViewController:cont animated:YES];
    
}
#pragma mark - end
@end
