//
//  HomeViewController.m
//  PriceTag
//
//  Created by Ranosys on 07/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "StoreDetailView.h"
#import "ProdcutDetailViewController.h"
#import "FinderCell.h"
@interface HomeViewController ()
{
    NSTimer *timer;
    int hour1,minute,second,day;
    int secondsLeft;
    UIRefreshControl *refreshControl;
    int numOfRecords;
    int currentIndex;
    int totalRecords;
    UITapGestureRecognizer *singleFingerTap;
    
    int totalUsers;
    int behindUsers;
    int leadingUsers;
    int UserPosition;
    NSDateComponents *components;
    NSString *sortedByString;
    NSString *userStatus;
    
    BOOL tempTimer1;
    
}
@property(nonatomic,assign) int hour1;
@property(nonatomic,assign) int minute;
@property(nonatomic,assign) int second;
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int secondLeft;

@end

@implementation HomeViewController
@synthesize hour1,minute,second,secondLeft,day;
@synthesize collectionView,days,hours,minutes,seconds,UserPositionLbl,behindUserLbl,leadingUserLabel;
@synthesize PriceClosedView,NextDay,NextHours,NextMinutes,NextSeconds,myPositionView,todayDate,endingDate,nextStartingDate,Product_ID,lastContentOffset;

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
    tempTimer1=false;
    sortedByString=@"All";
    userStatus=@"";
    numOfRecords=20;
    currentIndex=0;
    _PaginationView.hidden=YES;
    self.dayTimer.hidden=YES;
    self.hourTimer.hidden=YES;
    self.minTimer.hidden=YES;
    self.secondTimer.hidden=YES;
    self.data_array = [[NSMutableArray alloc]init];
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 52.0f, topVIew.frame.size.width, 1.5f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/225.0 alpha:0.7].CGColor;
    
    [topVIew.layer addSublayer:bottomBorder];
    
    // Pull To Refresh
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(160, 0, 20, 20)];
    [self.collectionView addSubview:refreshControl];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@""];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.collectionView.alwaysBounceVertical = YES;
    
    //Gesture action on timer pop-up and my positiom pop-up
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    PriceClosedView.layer.cornerRadius = 5;
    PriceClosedView.layer.masksToBounds = YES;
    PriceClosedView.layer.borderWidth=1.0f;
    PriceClosedView.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:2.0].CGColor;
    PriceClosedView.hidden=YES;
    
    myPositionView.layer.cornerRadius = 5;
    myPositionView.layer.masksToBounds = YES;
    myPositionView.layer.borderWidth=1.0f;
    myPositionView.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:2.0].CGColor;
    myPositionView.hidden=YES;
    
    coloredView.hidden=YES;
    
}

- (void)didReceiveMemoryWarning
{
    //Method used to clear the cache memory whenever app receives memory warning
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.data_array removeAllObjects];
    [collectionView reloadData];
    currentIndex = 0;
    userStatus=@"";
    [myDelegate ShowIndicator];
    //Method for fetching the my submission list from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(mySubmissionList:) toTarget:self withObject:sortedByString];
  
}



-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
}

//Handle gesture action for position view
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    coloredView.backgroundColor = [UIColor clearColor];
    coloredView.userInteractionEnabled=YES;
    myPositionView.hidden=YES;
    coloredView.hidden=YES;
    
}
#pragma mark - end


#pragma mark - Button Actions
//Action for displaying dropdown menu of sort by options
-(IBAction)showHideDropdown:(id)sender
{
    
    if([sender isSelected])
    {
        
        [self hideAnimation];
        // [sender setSelected:NO];
        
    }
    else
    {
        [self showAnimation];
        [sender setSelected:YES];
        
    }
    
    
}
//Action for my position webservice call
- (IBAction)myPositionAction:(id)sender
{
    coloredView.hidden=NO;
    coloredView.backgroundColor = [UIColor colorWithRed:(72.0/255.0) green:(72.0/255.0) blue:(72.0/255.0) alpha:0.5];
    
    [coloredView addGestureRecognizer:singleFingerTap];
    DataHolderClass * data =[self.data_array objectAtIndex:[sender tag]];
    
    Product_ID=[data.product_id intValue];
    [myDelegate ShowIndicator];
    
    //Method for fetching the my position data from server which is called in seperate thread and tells the current position of user with reference to others

    [NSThread detachNewThreadSelector:@selector(callMyPosition) toTarget:self withObject:nil];
}


#pragma mark - end
#pragma mark - API Calling
//this method will fired when user's account has been deactivated. It will destroy user's existing session.
- (void)logout
{
    
    //[self normalAnimation];
    
    
        
        //Facebook logout
        if (!([FBSession activeSession].state != FBSessionStateOpen &&
              [FBSession activeSession].state != FBSessionStateOpenTokenExtended))
        {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginController *firstVC=[sb instantiateViewControllerWithIdentifier:@"LoginController"];
        [myDelegate.navigationController setViewControllers: [NSArray arrayWithObject: firstVC]
                                                   animated: YES];
        myDelegate.window.rootViewController=myDelegate.navigationController;
        [myDelegate.window makeKeyAndVisible];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"checkLoginText"];
        [defaults removeObjectForKey:@"checkUserId"];
        
        myDelegate.DBemail=@"";
        myDelegate.DBimage=nil;
        myDelegate.DBuserFbId=@"";
        myDelegate.DBuserName=@"";
        myDelegate.userId=nil;
        [defaults synchronize];
        
        CATransition* transition = [CATransition animation];
        [transition setDuration:0.5];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setFillMode:kCAFillModeBoth];
        [transition setTimingFunction:[CAMediaTimingFunction
                                       functionWithName:kCAMediaTimingFunctionDefault]];
        [myDelegate.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [myDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    
    
    
}

//My submission webservice method used to fetch data from server

-(void)mySubmissionList:(NSString *)object
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        myDelegate.userId=[NSNumber numberWithInteger:[prefs integerForKey:@"checkUserId"]];
        // NSLog(@"%@",myDelegate.userId);
        
        NSDictionary *requestDict = @{@"userId":myDelegate.userId,@"indexPage":[NSNumber numberWithInt:currentIndex],@"noOfRecords":[NSNumber numberWithInt:numOfRecords],@"shortBy":object};
        NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"watchList"];
        NSLog(@"dataDict is %@",dataDict);
        [self parseSubmissionListData:dataDict];
        [myDelegate StopIndicator];
    }
}
-(void)parseSubmissionListData :(NSDictionary *)dataDict
{
    if ([[dataDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        //Parsing data fetched from server
        
        todayDate=[dataDict objectForKey:@"today_date"];
        endingDate=[dataDict objectForKey:@"submission_close_date"];
        nextStartingDate=[dataDict objectForKey:@"nextStartingDate"];
//        todayDate=@"2014-10-1512:22:30";
//        endingDate=@"2014-10-1512:22:40";
//        nextStartingDate=@"2014-10-1512:22:40";
        totalRecords=[[dataDict objectForKey:@"totalRecords"]intValue];
        userStatus=[dataDict objectForKey:@"userLoginStatus"];
        
        tempTimer1=false;
        [self performSelectorOnMainThread:@selector(countTimer) withObject:nil waitUntilDone:NO];
        NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
        NSArray * tempAry = [tempDict objectForKey:@"watchList"];
        if (currentIndex==0)
        {
            [self.data_array removeAllObjects];
        }
        for (int i =0; i<tempAry.count; i++)
        {
            DataHolderClass * data = [[DataHolderClass alloc]init];
            NSDictionary * tempDict = [tempAry objectAtIndex:i];
            data.product_id = [tempDict objectForKey:@"product_Id"];
            data.productImg_url = [tempDict objectForKey:@"product_ImageUrl"];
            data.product_name = [tempDict objectForKey:@"product_Name"];
            data.product_price = [tempDict objectForKey:@"product_Price"];
            [self.data_array addObject:data];
            
        }
         self.data_array = (NSMutableArray *)[[self.data_array reverseObjectEnumerator] allObjects];
        [self performSelectorOnMainThread:@selector(hideLabel) withObject:nil waitUntilDone:NO];
       
        [collectionView reloadData];
    }
    else if ([[dataDict valueForKey:@"isSuccess"] intValue] == 2)
    {
        [self performSelectorOnMainThread:@selector(callLogoutMethod) withObject:nil waitUntilDone:NO];
        
        return;
    
    }
    else
    {
        if ([[dataDict valueForKey:@"isSuccess"] intValue] == 0 && dataDict !=NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                         {
                             [self sendDeviceTokenToServer:myDelegate.deviceToken userId:myDelegate.userId];
                         });
    
}

    //[self performSelectorOnMainThread:@selector(callLogoutMethod) withObject:nil waitUntilDone:NO];


//method to send device token to back end

-(void)sendDeviceTokenToServer : (NSString *)deviceToken userId:(NSNumber *)userId
{
    NSDictionary *requestDict = @{@"userId":myDelegate.userId,@"deviceToken" : deviceToken};
    NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"updateDeviceToken"];
    NSLog(@"dataDict is %@",dataDict);

}
//end

//Logout 
-(void)callLogoutMethod
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your account has been deactivated by administrator" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag=001;
    [alert show];
    //[self performSelector:@selector(logout) withObject:nil afterDelay:.1];

}

//My position webservice call
-(void)callMyPosition
{
   
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        NSDictionary *requestDict = @{@"userId":myDelegate.userId,@"productId":[NSNumber numberWithInt:Product_ID]};
        
        NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"getUserPosition"];
        NSLog(@"dataDict is %@",dataDict);
        [self parseMyPositionData:dataDict];
        [myDelegate StopIndicator];
    }
    
}
//No record found label action
-(void)hideLabel
{
    if(self.data_array.count<1)
    {
        self.noRecord.hidden = NO;
    }
    else
    {
        self.noRecord.hidden = YES;
    }
    
}

-(void)parseMyPositionData :(NSDictionary *)dataDict
{
    //Parsing my position data from server
    
    if ([[dataDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        
        UserPosition=[[dataDict objectForKey:@"userPosition"] intValue];
        totalUsers=[[dataDict objectForKey:@"totalUser"]intValue];
        if (UserPosition==0 && totalUsers==0) {
            behindUsers=0;
            leadingUsers=0;
            
        }
        else
        {
            behindUsers=totalUsers-UserPosition;
            leadingUsers=totalUsers-(behindUsers+1);
        }
        myPositionView.hidden=NO;
        UserPositionLbl.text=[NSString stringWithFormat:@"%d",UserPosition];
        behindUserLbl.text=[NSString stringWithFormat:@"%d",behindUsers];
        leadingUserLabel.text=[NSString stringWithFormat:@"%d",leadingUsers];
        
    }
    else
    {
        if ([[dataDict valueForKey:@"isSuccess"] intValue] == 0 && dataDict !=NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Table view method used to display sorted by drop down options
    static NSString *CellIdentifier = @"DropdownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //adding border to cell
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel * txtLbl = (UILabel *)[cell viewWithTag:1];
    UIImageView *divider =(UIImageView *)[cell viewWithTag:2];
    
    //Switch cases used to toggle in sort by functionality
    switch (indexPath.row)
    {
        case 0:
            txtLbl.text = @"All";
            break;
        case 1:
            txtLbl.text = @"Yesterday";
            break;
        case 2:
            txtLbl.text = @"One Week";
            break;
        case 3:
            txtLbl.text = @"Two Week";
            break;
        case 4:
            txtLbl.text = @"Three Week";
            divider.hidden = YES;
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UILabel * txtLbl;
    for (int i=0; i<=4; i++)
    {
        NSIndexPath *indexValue=[NSIndexPath indexPathForRow:i inSection:0];
        
        cell = [tableView cellForRowAtIndexPath:indexValue];
        
        txtLbl = (UILabel *)[cell viewWithTag:1];
        
        txtLbl.font=[UIFont fontWithName:@"OpenSans" size:14.0];
    }
    cell = [tableView cellForRowAtIndexPath:indexPath];
    txtLbl = (UILabel *)[cell viewWithTag:1];
    txtLbl.font=[UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    //Displaying drop down menu for sorting data by All, yesterday, one week, two week, three week
    [UIView animateWithDuration:0.3f animations:^{
        dropDownView.frame =CGRectMake(dropDownView.frame.origin.x, dropDownView.frame.origin.y, dropDownView.frame.size.width, 0);
        [_dropDownTable setFrame:CGRectMake(self.dropDownTable.frame.origin.x, self.dropDownTable.frame.origin.y, self.dropDownTable.frame.size.width, 0)];
    }completion:^(BOOL finished) {
        
        [_dropDownBtn setSelected:NO];
        currentIndex=0;
        [myDelegate ShowIndicator];
        sortedByString=txtLbl.text;
        //Method for fetching the my submission list from server which is called in seperate thread
        [NSThread detachNewThreadSelector:@selector(mySubmissionList:) toTarget:self withObject:sortedByString];
    }];
    
}
#pragma mark - end

#pragma mark - Collection View
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.data_array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FinderCell *myCell = [collectionView1
                          dequeueReusableCellWithReuseIdentifier:@"FinderListCell"
                          forIndexPath:indexPath];
    //Displaying My submission list data
    
    DataHolderClass * data = [self.data_array objectAtIndex:indexPath.row];
    
    myCell.nameProductLbl.text = data.product_name;
    myCell.priceLbl.text= data.product_price;
    
    myCell.myPositionbtn.layer.cornerRadius=10;
    myCell.myPositionbtn.clipsToBounds=YES;
    
    [myCell.myPositionbtn addTarget:self action:@selector(myPositionAction:) forControlEvents:UIControlEventTouchDown];
    myCell.myPositionbtn.tag=indexPath.row;
    [myCell.ProductImageView sd_setImageWithURL:[NSURL URLWithString:data.productImg_url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return myCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView1
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Action to move to store detail screen when ever a product is selected
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreDetailView *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"StoreDetailView"];
    
    DataHolderClass * data = [self.data_array objectAtIndex:indexPath.row];
    objProductDetail.product_id = data.product_id;
    [self.navigationController pushViewController:objProductDetail animated:YES];
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 50, 10);
}
#pragma mark - end

#pragma mark - Refresh Table
//Pull to refresh implementation on my submission data
- (void)refreshTable
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [refreshControl endRefreshing];
    }
    else
    {
        currentIndex=0;
        // self.noRecord.hidden=YES;
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                             {
                                 //Calling my submission web service to refresh
                                 [self mySubmissionList:sortedByString];
                                 
                                 [refreshControl endRefreshing];
                                 [self.collectionView reloadData];
                             });
    }
}
#pragma mark - end

#pragma mark - Timer
//Action for diaplaying running competition timer and cometition over timer
-(void)countTimer
{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSString * start = todayDate;
    NSDate *startDate1 = [f dateFromString:start];
    NSString * end = endingDate;
    NSDate *endDate = [f dateFromString:end];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    components = [gregorianCalendar components:unitFlags
                                      fromDate:startDate1
                                        toDate:endDate
                                       options:0];
    
    [timer invalidate];
    secondsLeft = [endDate timeIntervalSinceDate:startDate1];
    //Method for calculating timer difference
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)updateCounter:(NSTimer *)theTimer
{
    //Calculating seconds difference for timer calculations
    if(secondsLeft > 0 )
    {
        topVIew.frame=CGRectMake(0, 60, 320, 53);
        secondsLeft -- ;
        day=(secondsLeft/86400);
        hour1 = (secondsLeft / 3600)%24;
        minute = (secondsLeft /60) % 60;
        second = (secondsLeft  % 60);
        //Running cometition timer calculation displayed
        if (PriceClosedView.hidden==YES)
        {
            days.text = [NSString stringWithFormat:@"%02i",day];
            hours.text = [NSString stringWithFormat:@"%02i",hour1];
            minutes.text = [NSString stringWithFormat:@"%02i",minute];
            seconds.text=[NSString stringWithFormat:@"%02i",second ];
            
        }
        else
        {
            days.text = [NSString stringWithFormat:@"%02i",0];
            hours.text = [NSString stringWithFormat:@"%02i",0];
            minutes.text = [NSString stringWithFormat:@"%02i",0];
            seconds.text=[NSString stringWithFormat:@"%02i",0 ];
        }
        
        self.dayTimer.hidden=NO;
        self.hourTimer.hidden=NO;
        self.minTimer.hidden=NO;
        self.secondTimer.hidden=NO;
        
        //Cometition over timer calculation displayed
        NextDay.text = [NSString stringWithFormat:@"%02i",day];
        NextHours.text = [NSString stringWithFormat:@"%02i",hour1];
        NextMinutes.text = [NSString stringWithFormat:@"%02i",minute];
        NextSeconds.text=[NSString stringWithFormat:@"%02i",second];
        
        if (PriceClosedView.hidden==NO && [NextDay.text intValue]==0 && [NextHours.text intValue]==0 && [NextMinutes.text intValue]==0 && [NextSeconds.text intValue]==0)
        {
            PriceClosedView.hidden=YES;
            coloredView.hidden=YES;
            
            [myDelegate ShowIndicator];
            //Method for fetching the my submission list from server which is called in seperate thread
            [NSThread detachNewThreadSelector:@selector(mySubmissionList:) toTarget:self withObject:sortedByString];
        }
        
    }
    

    else
    {
        //Cometition over timer updation
        if (tempTimer1==false)
        {
            tempTimer1=true;
            endingDate=nextStartingDate;
            [self countTimer];
            
            PriceClosedView.hidden=NO;
            coloredView.hidden=NO;
            coloredView.backgroundColor = [UIColor colorWithRed:(72.0/255.0) green:(72.0/255.0) blue:(72.0/255.0) alpha:0.5];
            [coloredView removeGestureRecognizer:singleFingerTap];
            

        }
        
    }
    
}
#pragma mark - end


#pragma mark - Pagignation

//Handling pagination in collection view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.PaginationView.hidden==YES)
    {
        if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
        {
            if (self.data_array.count<totalRecords)
            {
                if ([GlobalMethod isIphone5])
                {
                    _PaginationView.frame=CGRectMake(0, 470,320 ,50);
                    _PaginationView.hidden=NO;
                }
                else
                {
                    _PaginationView.frame=CGRectMake(0, 392, 320 ,50);
                    _PaginationView.hidden=NO;
                }
                
                dispatch_group_t group = dispatch_group_create();
                
                dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                                     {
                                         //calling my submission list using pagignation i.e it displays the next 20 values in the list
                                         currentIndex++;
                                         [self mySubmissionList:sortedByString];
                                         //hides indicatior after pagination
                                         [self performSelectorOnMainThread:@selector(hideactivityIndicator) withObject:nil waitUntilDone:NO];
                                         
                                         
                                     });
            }
            
        }
    }
    
//    if (self.lastContentOffset > scrollView.contentOffset.y)
//    {
//        NSLog(@"Scrolling Up");
//        if(self.navigationController.navigationBarHidden==YES)
//        {
//            [self.navigationController setNavigationBarHidden: NO animated:YES];
//        }
//    }
//    else if (self.lastContentOffset < scrollView.contentOffset.y)
//    {
//        
//            [self.navigationController setNavigationBarHidden: YES animated:YES];
//        
//        NSLog(@"Scrolling Down");
//    }
    
    
}
#pragma mark - end

#pragma mark - Hide Indicator
 //hides indication after pagination
-(void)hideactivityIndicator
{
    _PaginationView.hidden=YES;
    [self.collectionView reloadData];
}
#pragma mark - end

//Handling animation for drop down menu
//Show animation
-(void)showAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        dropDownView.frame =CGRectMake(dropDownView.frame.origin.x, dropDownView.frame.origin.y, dropDownView.frame.size.width, 150);
        [_dropDownTable setFrame:CGRectMake(self.dropDownTable.frame.origin.x, self.dropDownTable.frame.origin.y, self.dropDownTable.frame.size.width, 150)];
        
    }];
    
}

//Hide animation

-(void)hideAnimation{
    [UIView animateWithDuration:0.3f animations:^{
        dropDownView.frame =CGRectMake(dropDownView.frame.origin.x, dropDownView.frame.origin.y, dropDownView.frame.size.width, 0);
        [_dropDownTable setFrame:CGRectMake(self.dropDownTable.frame.origin.x, self.dropDownTable.frame.origin.y, self.dropDownTable.frame.size.width, 0)];
    }completion:^(BOOL finished) {
        
        [_dropDownBtn setSelected:NO];
        
    }];
    
}
#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alert.tag==001)
    {
         [self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    }
}

#pragma mark - end

@end
