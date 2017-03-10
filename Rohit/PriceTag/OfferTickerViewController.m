//
//  OfferTickerViewController.m
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "OfferTickerViewController.h"
#import "Cell.h"
#import "UIImageView+WebCache.h"
#import "TableTickerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OfferTickerViewController (){
    NSDictionary *jsonDictionary;
    NSMutableArray *data_array;
    DataHolderClass *data;
}
@property(nonatomic,retain) NSMutableArray *data_array;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@end

@implementation OfferTickerViewController
@synthesize jsonDictionary,data_array;

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
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg.png"]];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    data_array=[[NSMutableArray alloc]init];
    [myDelegate ShowIndicator];
    //Method for fetching offer feed list from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(offerTicker) toTarget:self withObject:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=@"OFFER FEED";
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

#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return data_array.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //Displaying the offerfeed name and setting the label properties
    cell.myLabel.layer.cornerRadius = 15;
    cell.myLabel.layer.masksToBounds = YES;
    [cell.myLabel.layer setBorderWidth:2];
    [cell.myLabel.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    cell.myLabel.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(200.0/255.0) blue:(0.0/255.0) alpha:1.0];
    cell.myLabel.textAlignment=NSTextAlignmentCenter;
    cell.backgroundColor=[UIColor clearColor];
    
    
    data=[data_array objectAtIndex:indexPath.row];
    cell.myLabel.text=[NSString stringWithFormat:@"%@",data.offer_subcategories];
    cell.offerName.text=data.category_name;
    
    //Setting the offer feed image
    UIImageView * imgView = (UIImageView *)[cell viewWithTag:1];
    [imgView sd_setImageWithURL:[NSURL URLWithString:data.offerImg_url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //Setting the offer feed background color
    UIImageView * imgView1 = (UIImageView *)[cell viewWithTag:2];
    [imgView1 setBackgroundColor:[self colorWithHexString:data.offerCellBg]];
    if([data.offerCellBg isEqualToString:@"#FFFFFF"])
    {
        cell.offerName.textColor = [UIColor blackColor];
    }
    else
    {
        cell.offerName.textColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    data=[[DataHolderClass alloc]init];
    
    data=[data_array objectAtIndex:indexPath.row];
    
    //Action to move to offer feed table screen when ever an offer feed name is selected
    if (([data.offer_subcategories intValue]>0))
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TableTickerViewController *cont=[storyboard instantiateViewControllerWithIdentifier:@"TableTickerViewController"];
        
        data=[data_array objectAtIndex:indexPath.row];
        cont.offerTickerId=data.offer_id;
        cont.categoryName=data.category_name;
        [self.navigationController pushViewController:cont animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No record found for this category." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize mElementSize = CGSizeMake(104, 104);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,1,0,2);  // top, left, bottom, right
    
}
#pragma mark - end

#pragma mark - offer ticker API

//Offer ticker web service
-(void)offerTicker
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSDictionary *requestDict =NULL;
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"offerTickerList"];
         NSLog(@"totalBodyData is %@",jsonDictionary);
        [self parseOfferTickerData:jsonDictionary];
        
        
    }
}

-(void)parseOfferTickerData :(NSDictionary *)dataDict
{
    if ([[dataDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        [data_array removeAllObjects];
        NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
        NSArray * tempAry = [tempDict objectForKey:@"offerTickerList"];
        //Data parsing
        for (int i =0; i<tempAry.count; i++)
        {
            data = [[DataHolderClass alloc]init];
            NSDictionary * tempDict1 = [tempAry objectAtIndex:i];
            data.offer_id = [tempDict1 objectForKey:@"offerTickerId"];
            data.offerImg_url = [tempDict1 objectForKey:@"categoryIconUrl"];
            data.category_name = [tempDict1 objectForKey:@"categoryName"];
            data.offerCellBg= [tempDict1 objectForKey:@"categoryBgColor"];
            data.offer_subcategories= [tempDict1 objectForKey:@"totalSubCategories"];
            data.offerCellBg= [tempDict1 objectForKey:@"categoryBgColor"];
            [data_array addObject:data];
            
        }
        [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
        [self.collectionView reloadData];
    }
    else{
        [myDelegate StopIndicator];
        if ([[dataDict valueForKey:@"isSuccess"] intValue] == 0 && dataDict !=NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dataDict valueForKey:@"Oops!!! Something went wrong."] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}
#pragma mark - end

#pragma mark - Hide Indicator
-(void)hideIndicator
{
    [myDelegate StopIndicator];
}
#pragma mark - end


#pragma  mark- Button Actions
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end


#pragma mark - Cell color conversion

//Converting the color hexcode in RGB values

-(UIColor*)colorWithHexString:(NSString*)hex
{

    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

}

@end
