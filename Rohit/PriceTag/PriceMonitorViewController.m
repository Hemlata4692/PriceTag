//
//  PriceMonitorViewController.m
//  PriceTag
//
//  Created by Ranosys on 04/08/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "PriceMonitorViewController.h"
#import "PriceMonitorModal.h"
#import "ProdcutDetailViewController.h"

@interface PriceMonitorViewController (){
    NSMutableArray *webserviceData;
     UILabel *refreshDateTimeLabel;
    BOOL editFlag, deleteFlag, isEditRow;
    PriceMonitorModal *listData;
    int selectedIndex;
}

@end

@implementation PriceMonitorViewController
@synthesize priceMonitorListing ,noRecord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webserviceData = [NSMutableArray new];
    editFlag = NO;
    deleteFlag = NO;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    myDelegate.userId=[NSNumber numberWithInteger:[prefs integerForKey:@"checkUserId"]];
    
    noRecord.hidden = YES;
    selectedIndex = -1;
    _navigationView.frame = CGRectMake(88, 6, 144, 33);
//    self.navigationController.title = @"Price Monitor";
//    [self dateTimeMethod];
     [webserviceData removeAllObjects];
    [myDelegate ShowIndicator];
    [self callPriceMonitor];
//    [self webservice];
//    if (webserviceData.count == 0) {
//        editFlag = YES;
//        deleteFlag = YES;
//    }
//    else {
//        editFlag = NO;
//        deleteFlag = NO;
//    }
//
//    [self DoneActionMethod];
//    self.priceMonitorListing.editing = NO;
//    isEditRow = NO;
//    [self.priceMonitorListing reloadData];
    
   
}

-(void)callPriceMonitor
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
            [NSThread detachNewThreadSelector:@selector(priceMonitorList) toTarget:self withObject:nil];
            //Moving to product detail screen after successfully adding product
        }
}

-(void)priceMonitorList{
    
    NSDictionary *requestDict;
    NSLog(@"%@",myDelegate.userId);
      //requestDict = @{@"user_id":[NSNumber numberWithInt:4]};
    requestDict = @{@"user_id":myDelegate.userId};
    //    }
    
    NSDictionary *jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"priceMonitorListing"];
    NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
    
   
    [myDelegate StopIndicator];
    
    if ([[tempDict valueForKey:@"isSuccess"] intValue] == 1)
    {
    [webserviceData removeAllObjects];
    if (tempDict.count>0 )
    {
        
        webserviceData=[[NSMutableArray alloc]init];
        //Data parsing
//        "string IsSuccess=1/0
//        array priceMonitorList[
//                               string  product_name
//                               string store_name
//                               string currentPrice(lowest price)
//                               string previousPrice()
//                               ]
//        string Message"
        NSArray *data = [tempDict valueForKey:@"priceMonitorList"];
        for (int i=0;i<data.count;i++) {
            NSDictionary *temp = [data objectAtIndex:i];
            listData = [[PriceMonitorModal alloc]init];
            listData.product_id = [[temp objectForKey:@"product_id"] intValue];
            listData.product_name = [temp objectForKey:@"product_name"];
            listData.store_name = [temp objectForKey:@"store_name"];
            listData.previousPrice = [temp objectForKey:@"previousPrice"];
            listData.currentPrice = [temp objectForKey:@"currentPrice"];
            [webserviceData addObject:listData];
        }
    }
        
    }
     [self dateTimeMethod];
    if (webserviceData.count == 0) {
        noRecord.hidden = NO;
        priceMonitorListing.hidden = YES;
        editFlag = YES;
        deleteFlag = YES;
    }
    else {
        editFlag = NO;
        deleteFlag = NO;
        noRecord.hidden = YES;
        priceMonitorListing.hidden = NO;
    }
    
    
    [self DoneActionMethod];
    self.priceMonitorListing.editing = NO;
    isEditRow = NO;
    [self.priceMonitorListing reloadData];
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                         {
                             [self sendDeviceTokenToServer:myDelegate.deviceToken userId:myDelegate.userId];
                         });
}

//method to send device token to back end

-(void)sendDeviceTokenToServer : (NSString *)deviceToken userId:(NSNumber *)userId
{
    NSDictionary *requestDict = @{@"userId":userId,@"deviceToken" : deviceToken};
    NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"updateDeviceToken"];
    NSLog(@"dataDict is %@",dataDict);
    
}
//end

-(void)editActionMethod{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    if (deleteFlag == NO) {
        UIButton *deleteAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
        [deleteAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        //    [deleteAllButton setBackgroundColor:[UIColor greenColor]];
        [deleteAllButton setTitle:@"Delete all" forState:UIControlStateNormal];
        [deleteAllButton addTarget:self action:@selector(deleteAllActionMethod) forControlEvents:UIControlEventTouchUpInside];
        [deleteAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:deleteAllButton];
        self.navigationItem.leftBarButtonItem = item;
    }
    else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [doneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
//    [doneButton setBackgroundColor:[UIColor greenColor]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(DoneActionMethod) forControlEvents:UIControlEventTouchUpInside];
   [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = item1;
    
    isEditRow = YES;
    self.priceMonitorListing.editing = YES;
    [self.priceMonitorListing reloadData];

}

-(void)deleteAllActionMethod{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to delete all products?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
//    if (webserviceData.count == 0) {
//        editFlag = YES;
//        deleteFlag = YES;
//    }
//    else {
//        editFlag = NO;
//        deleteFlag = NO;
//    }
//    [self DoneActionMethod];
//    isEditRow = NO;
//    self.priceMonitorListing.editing = NO;
//    [self.priceMonitorListing reloadData];
}

#pragma mark - alertview delegate method
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [myDelegate ShowIndicator];
        [self performSelector:@selector(callDeleteMethod:) withObject:[NSNumber numberWithInt:0] afterDelay:.1];
//        [self callDeleteMethod:[NSNumber numberWithInt:0]];
    }
}

#pragma mark - end

-(void)callDeleteMethod:(NSNumber*)productid
{
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
        [NSThread detachNewThreadSelector:@selector(DeletePriceMonitorData:) toTarget:self withObject:productid];
        //Moving to product detail screen after successfully adding product
    }
    
}

-(void)DeletePriceMonitorData:(NSNumber*)productid{
    
    NSDictionary *requestDict;
//    "int user_id
//    int product_id
//    (if product id empty then delete all products else particular product)"
    
    NSLog(@"%@",myDelegate.userId);
 //   requestDict = @{@"user_id":[NSNumber numberWithInt:4],@"product_Id":productid};
    
//    "int user_id
//    int product_id
//    (if product id empty then delete all products else particular product)"
    
  requestDict = @{@"user_id":myDelegate.userId,@"product_id":productid};
    //    }
    
    NSDictionary *jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"deletePriceMonitor"];
    NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
    
    [myDelegate StopIndicator];
    if ([[tempDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        if ([productid intValue] == 0) {
             [webserviceData removeAllObjects];
//            if (webserviceData.count == 0) {
                editFlag = YES;
                deleteFlag = YES;
                noRecord.hidden = NO;
                priceMonitorListing.hidden = YES;
           
            
//            }
//            else {
//                editFlag = NO;
//                deleteFlag = NO;
//            }
            [self DoneActionMethod];
            isEditRow = NO;
            self.priceMonitorListing.editing = NO;
            [self.priceMonitorListing reloadData];

        }
        else{
            [webserviceData removeObjectAtIndex:selectedIndex];
            if (webserviceData.count == 0) {
                deleteFlag = YES;
                editFlag = YES;
                isEditRow = NO;
                noRecord.hidden = NO;
                priceMonitorListing.hidden = YES;
                self.priceMonitorListing.editing = NO;
                [self DoneActionMethod];
            }
            else {
                deleteFlag = NO;
                editFlag = NO;
                isEditRow = YES;
                noRecord.hidden = YES;
                priceMonitorListing.hidden = NO;
                self.priceMonitorListing.editing = YES;
                [self editActionMethod];
            }
            
            
            
            //    self.priceMonitorListing.editing = NO;
            [self.priceMonitorListing reloadData];
        }
       
//        if (webserviceData.count == 0) {
//            editFlag = YES;
//            deleteFlag = YES;
//        }
//        else {
//            editFlag = NO;
//            deleteFlag = NO;
//        }
//        [priceMonitorListing reloadData];
    }
    
}


-(void)DoneActionMethod{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    if (editFlag == NO) {
        UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [editButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        //    [editButton setBackgroundColor:[UIColor greenColor]];
        [editButton addTarget:self action:@selector(editActionMethod) forControlEvents:UIControlEventTouchUpInside];
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
//        [edititem setCustomView:editButton];
        UIBarButtonItem* edititem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        
        self.navigationItem.leftBarButtonItem = edititem;

    }
    else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 , 30)];
    [refreshButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
//    [refreshButton setBackgroundColor:[UIColor greenColor]];
    [refreshButton setImage:[UIImage imageNamed: @"refresh.png"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshActionMethod) forControlEvents:UIControlEventTouchUpInside];
    //    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = item1;

    isEditRow = NO;
    self.priceMonitorListing.editing = NO;
//    [self.priceMonitorListing reloadData];
}

-(void)refreshActionMethod{
     [webserviceData removeAllObjects];
    NSLog(@"refresh");
//    [self dateTimeMethod];
//    [self webservice];
    [myDelegate ShowIndicator];
    [self callPriceMonitor];
//    if (webserviceData.count == 0) {
//        editFlag = YES;
//        deleteFlag = YES;
//    }
//    else {
//        editFlag = NO;
//        deleteFlag = NO;
//    }
//    
//    
//    [self DoneActionMethod];
////    if (webserviceData.count == 0) {
////        edititem.enabled = NO;
////    }
////    else {
////        edititem.enabled = YES;
////    }
//    
//    isEditRow = NO;
//    self.priceMonitorListing.editing = NO;
//    [self.priceMonitorListing reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return webserviceData.count;
}
//
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return isEditRow;
}


//
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = (int)indexPath.row;
    listData = [[PriceMonitorModal alloc]init];
    listData = [webserviceData objectAtIndex:indexPath.row];
    
  
    [myDelegate ShowIndicator];
    [self callDeleteMethod:[NSNumber numberWithInt:listData.product_id]];
//    if (webserviceData.count == 0) {
//        deleteFlag = YES;
//        editFlag = YES;
//         isEditRow = NO;
//        self.priceMonitorListing.editing = NO;
//        [self DoneActionMethod];
//    }
//    else {
//        deleteFlag = NO;
//        editFlag = NO;
//         isEditRow = YES;
//        self.priceMonitorListing.editing = YES;
//        [self editActionMethod];
//    }
//    
////    self.priceMonitorListing.editing = NO;
//    [self.priceMonitorListing reloadData];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
//    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (indexPath.row == [controller countOfList]-1) {
//        return UITableViewCellEditingStyleInsert;
//    } else {
        return UITableViewCellEditingStyleDelete;
//    }
}



//- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation: (UITableViewRowAnimation)animation{
//    NSLog(@"check");
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
  
    listData = [[PriceMonitorModal alloc]init];
    listData = [webserviceData objectAtIndex:indexPath.row];
    UILabel *productName = (UILabel*)[cell viewWithTag:1];
   
    productName.text = listData.product_name;
    
    UILabel *storeName = (UILabel*)[cell viewWithTag:5];
    storeName.text = listData.store_name;
    
    UILabel *currentPrice = (UILabel*)[cell viewWithTag:2];
    currentPrice.text = listData.currentPrice;
    
    NSString *aString = listData.currentPrice;
    NSString * strippedNumber = [aString stringByReplacingOccurrencesOfString:@"[^\\.0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [aString length])];
    NSLog(@"%@", strippedNumber);
    
    float current = [strippedNumber floatValue];
    aString = listData.previousPrice;
    strippedNumber = [aString stringByReplacingOccurrencesOfString:@"[^\\.0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [aString length])];
    
    float previous = [strippedNumber floatValue];
    float difference = current - previous;
    UILabel *differenceValue = (UILabel*)[cell viewWithTag:4];
    
    
    UIImageView *graphicImage = (UIImageView*)[cell viewWithTag:3];
    if (difference<0) {
        differenceValue.text = [NSString stringWithFormat:@"RM$%.2f",-difference];
        graphicImage.image = [UIImage imageNamed:@"down.png"];
    }
    else
    {
        differenceValue.text = [NSString stringWithFormat:@"RM$%.2f",difference];
        graphicImage.image = [UIImage imageNamed:@"mid.png"];
    }
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Moving to submit price screen of selected product
    listData = [[PriceMonitorModal alloc]init];
    listData = [webserviceData objectAtIndex:indexPath.row];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProdcutDetailViewController *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"ProdcutDetailViewController"];
    objProductDetail.productId = [NSString stringWithFormat:@"%d",listData.product_id];
    [self.navigationController pushViewController:objProductDetail animated:YES];
}


-(void)dateTimeMethod{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"dd-MMM-yyyy HH:mm:ss";
    
    _dateTimeLabel.text = [timeFormatter stringFromDate: localDate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
