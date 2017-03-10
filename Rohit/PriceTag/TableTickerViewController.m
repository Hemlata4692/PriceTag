//
//  TableTickerViewController.m
//  PriceTag
//
//  Created by Ranosys on 11/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "TableTickerViewController.h"
#import "CustomCell.h"
#import "OfferTickerDetailView.h"

@interface TableTickerViewController (){
    NSDictionary *jsonDictionary;
    NSMutableArray *data_array;
}
@property(nonatomic,retain)  NSDictionary *jsonDictionary;
@property(nonatomic,retain)   NSMutableArray *data_array;
@end

@implementation TableTickerViewController
@synthesize offerTickerId,jsonDictionary,data_array,categoryName;

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg.png"]];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    data_array=[[NSMutableArray alloc]init];
    [myDelegate ShowIndicator];
    //Method for fetching offer feed sub category from server which is called in seperate thread
     [NSThread detachNewThreadSelector:@selector(offerTickerSubCategory) toTarget:self withObject:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=categoryName;
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

#pragma mark - Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Table view method used to display offer feed name subcategory
    static NSString *CellIdentifier = @"cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //adding border to cell
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Setting textcolor and accessory for cell 
    cell.title.textColor = [UIColor colorWithRed:(223.0/255.0) green:(57.0/255.0) blue:(47.0/255.0) alpha:1.0];
    cell.arrow.image=[UIImage imageNamed:@"profileArrow.png"];
    
    DataHolderClass *data;
    data=[data_array objectAtIndex:indexPath.row];
    cell.title.text=[NSString stringWithFormat:@"%@",data.subcategory_name];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Action to move to offer feed detail screen when ever an offer feed sub category is selected
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OfferTickerDetailView *cont=[storyboard instantiateViewControllerWithIdentifier:@"OfferTickerDetailView"];
    DataHolderClass *data;
    data=[data_array objectAtIndex:indexPath.row];
    cont.offerTickerImage=data.offerImg_url;
     cont.offerName=data.offer_name;
    [self.navigationController pushViewController:cont animated:YES];
    
}
#pragma mark - end



#pragma mark -  offer Feed SubCategory List API Calling
//Offer feed sub category list web service
-(void)offerTickerSubCategory
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSDictionary *requestDict =@{@"tickerCategoryId":offerTickerId};
        
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"offerTickerSubCategoryList"];
       
      //  NSLog(@"totalBodyData is %@",jsonDictionary);
        [self parseOfferTickerSubCategoryData:jsonDictionary];
        
        [myDelegate StopIndicator];
        
    }
}

-(void)parseOfferTickerSubCategoryData :(NSDictionary *)dataDict
{
    [data_array removeAllObjects];
    NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
    NSArray * tempAry = [tempDict1 objectForKey:@"offerTickerDetailList"];
    //Data Parsing
    for (int i =0; i<tempAry.count; i++)
    {
        DataHolderClass * data = [[DataHolderClass alloc]init];
        NSDictionary * tempDict = [tempAry objectAtIndex:i];
        data.offer_id = [tempDict objectForKey:@"subCategoryId"];
        data.offerImg_url = [tempDict objectForKey:@"contentImageUrl"];
        data.subcategory_name = [tempDict objectForKey:@"subCategoryName"];
        data.offer_name=[tempDict objectForKey:@"offerName"];
        [data_array addObject:data];
    }
    [self.tableView reloadData];
    
}
#pragma mark - end

#pragma mark - Button Actions

//Navigating to previous screen
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
