//
//  CommentsViewController.m
//  PriceTag
//
//  Created by Sumit on 11/08/14.
//  Copyright (c) 2014 Sumit. All rights reserved.
//

#import "CommentsViewController.h"
#import "commentsCellTableViewCell.h"
#import "ActivityCell.h"
#import "UIImageView+WebCache.h"

@interface CommentsViewController ()
{
    NSDictionary *jsonDictionary;
    NSMutableArray *tableData;
}
@property(nonatomic,retain)NSDictionary *jsonDictionary;
@property(nonatomic,retain)NSMutableArray *tableData;
@end

@implementation CommentsViewController
@synthesize screenCounter;
@synthesize commentsCell;
@synthesize activityCell;
@synthesize jsonDictionary;
@synthesize tableData;
@synthesize todayDate;
@synthesize endingDate;
@synthesize timer;
@synthesize secondsLeft;
@synthesize day;
@synthesize minute;
@synthesize second;
@synthesize hour;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.tabBarController.tabBar setHidden:NO];
    
}
//Action to hide bottom tab
-(void)hideTabbar
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:0.1];
     [self performSelector:@selector(setTopbarTitle) withObject:nil afterDelay:0.1];
    //[self setTopbarTitle];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     //Method used to clear the cache memory whenever app receives memory warning
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end

#pragma mark - Top Bar Title
//Action for setting top bar title
-(void)setTopbarTitle
{
    self.noRecord.hidden=YES;
    switch (screenCounter)
    {
        case 1:
            
            self.navigationItem.title=@"COMMENTS";
            [commentsBtn setSelected:YES];
            [timerBtn setSelected:NO];
            tableView.hidden = NO;
            [activityBtn setSelected:NO];
            [myDelegate ShowIndicator];
            //Calling comments web service to display comments added on the products
            [self performSelector:@selector(CommentsActivityWebservice:) withObject:@"myComments" afterDelay:.1];
            
            break;
            
        case 2:
            
            self.navigationItem.title=@"MY ACTIVITY";
            [commentsBtn setSelected:NO];
            [timerBtn setSelected:NO];
             tableView.hidden = NO;
            [activityBtn setSelected:YES];
            [myDelegate ShowIndicator];
        //Calling my activity web service to display my activity list of product added
             //[NSThread detachNewThreadSelector:@selector(CommentsActivityWebservice:) toTarget:self withObject:@"myActivity"];
            [self performSelector:@selector(CommentsActivityWebservice:) withObject:@"myActivity" afterDelay:.1];
            break;
            
        case 4:
             self.navigationItem.title=@"TIMER";
            [tableData removeAllObjects];
            tableView.hidden = YES;
            [commentsBtn setSelected:NO];
            [timerBtn setSelected:YES];
            [activityBtn setSelected:NO];
            timer_view.hidden = NO;
            //***----calling of timer timer details here----***
            [myDelegate ShowIndicator];
            //[NSThread detachNewThreadSelector:@selector(CommentsActivityWebservice:) toTarget:self withObject:@"getTimerDetails"];
            [self performSelector:@selector(CommentsActivityWebservice:) withObject:@"getTimerDetails" afterDelay:.1];
            break;
            
        default:
            break;
    }
    
}
#pragma mark - end

#pragma mark - Call Comment and Activity API
//Comments and my activity method to fetch data from server
-(void)CommentsActivityWebservice:(NSString *)method
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        [tableData removeAllObjects];
        
//        if(screenCounter == 1)
//        {
//            
//            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            NSString *myUserId =[NSString stringWithFormat:@"%ld", (long)[prefs integerForKey:@"checkUserId"] ];
//            
//            NSDictionary *requestDict = @{@"userId":myUserId};
//            jsonDictionary=[NSDictionary new];
//            jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:method];
//             NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
//            //NSLog(@"totalBodyData is %@",tempDict1);
//            
//            //Comments List parsing data
//            if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
//            {
//                NSArray *arrData=[tempDict1 objectForKey:@"commentList"];
//                for (NSDictionary *data in arrData)
//                {
//                    [tableData addObject:data];
//                }
//                
//                if(tableData.count<1)
//                {
//                    self.noRecord.hidden = NO;
//                    self.noRecord.text=@"You have not commented on any product yet.";
//                }
//                else
//                {
//                    self.noRecord.hidden = YES;
//                }
//                [myDelegate StopIndicator];
//                
//                [tableView reloadData];
//            }
//            else
//            {
//                if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 0 && tempDict1 !=NULL) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    [alert show];
//                    [myDelegate StopIndicator];
//                }
//                else
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server is down" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    [alert show];
//                    [myDelegate StopIndicator];
//                }
//                
//            }
//        }
//        //MyActivity List data parsing
//        else
        if (screenCounter == 2)
        {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *myUserId =[NSString stringWithFormat:@"%ld", (long)[prefs integerForKey:@"checkUserId"] ];
            NSDictionary *requestDict = @{@"userId":myUserId};
            jsonDictionary=[NSDictionary new];
            jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:method];
             NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
          //  NSLog(@"totalBodyData is %@",tempDict1);
            
            if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
            {
                NSArray *arrData=[tempDict1 objectForKey:@"myActivityList"];
                for (NSDictionary *data in arrData)
                {
                    [tableData addObject:data];
                }
                
                if(tableData.count<1)
                {
                    self.noRecord.hidden = NO;
                    self.noRecord.text=@"No record found.";
                }
                else
                {
                    self.noRecord.hidden = YES;
                    
                }
                [myDelegate StopIndicator];
                [tableView reloadData];
            }
            else
            {
                if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict1 valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    [myDelegate StopIndicator];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    [myDelegate StopIndicator];
                }
                
            }
        }
        else
        {
            NSDictionary *requestDict;
            jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:method];
            NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
            //NSLog(@"totalBodyData is %@",tempDict1);
            
            //Timer details from server
            if ([[tempDict1 valueForKey:@"isSuccess"] intValue] == 1)
            {
                self.todayDate = [jsonDictionary objectForKey:@"today_date"];
                self.endingDate = [jsonDictionary objectForKey:@"submission_close_date"];
                self.savings.text=[jsonDictionary objectForKey:@"totalSaving"];
                self.savingPercentage.text=[jsonDictionary objectForKey:@"totalSavingPercentage"];

                
                NSString *dateString = todayDate;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                // this is imporant - we set our input date format to match our input string
                // if format doesn't match you'll get nil from your string, so be careful
                [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                NSDate *dateFromString = [[NSDate alloc] init];
                dateFromString = [dateFormatter dateFromString:dateString];
               
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateFromString];
                int year = (int)[components year];
                int month = (int)[components month];
                int today = (int)[components day];
                
                self.currentDate.text=[NSString stringWithFormat:@"%d-%d-%d",year,month,today];
                
                //method to start timer countdown till product submission date
                [timer invalidate];
                [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
                NSLog(@"totalBodyData is %@",tempDict1);
                [myDelegate StopIndicator];
            }

        
        
        
        }
    }
}
#pragma mark - end
#pragma mark - timer countdown methods
//Timer calculations for winner logic
-(void)startTimer
{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSString * start = todayDate;
    NSDate *startDate1 = [f dateFromString:start];
    NSString * end = endingDate;
    NSDate *endDate = [f dateFromString:end];
    
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:startDate1
                                                          toDate:endDate
                                                         options:0];
    
    if(components.day == 0)
        if(components.hour == 0)
            if(components.minute == 0)
            {
                [timer invalidate];
            }
       //Timer diiference calculations
    secondsLeft = [endDate timeIntervalSinceDate:startDate1];
    //updating Timer calculations
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}
- (void)updateCounter:(NSTimer *)theTimer
{
    //setting timer values after calculations
    if(secondsLeft > 0 )
    {
        secondsLeft -- ;
        day=(secondsLeft/86400);
        hour = (secondsLeft / 3600)%24;
        minute = (secondsLeft /60) % 60;
        second = (secondsLeft  % 60);
        days_lbl.text = [NSString stringWithFormat:@"%02i",day];
        hours_lbl.text = [NSString stringWithFormat:@"%02i",hour];
        minutes_lbl.text = [NSString stringWithFormat:@"%02i",minute];
        seconds_lbl.text=[NSString stringWithFormat:@"%02i",second ];
        
    }
    
    else
    {
        [timer invalidate];
        timer = nil;
    }
    
}


#pragma mark -end



#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)ttableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (screenCounter == 1)
//    {
//        NSString *CellIdentifier = [NSString stringWithFormat:@"commentsCell"];
//        commentsCell = (commentsCellTableViewCell *)[ttableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if(commentsCell == nil)
//        {
//            [[NSBundle mainBundle] loadNibNamed:@"commentsCellTableViewCell" owner:self options:nil];
//            
//        }
//        //Comments list display
//        commentsCell.ImageFrame.layer.cornerRadius = 5;
//        commentsCell.ImageFrame.layer.borderWidth = 1;
//        commentsCell.ImageFrame.layer.borderColor = [[UIColor colorWithRed:221.0/255.0 green:218.0/255.0 blue:221.0/255.0 alpha:1.0] CGColor];
//        NSDictionary *getData=[tableData objectAtIndex:indexPath.row];
//        commentsCell.productName.text=[getData objectForKey:@"productName"];
//        
//        NSString *newOutput = [NSString stringWithFormat:@"\"%@\"", [getData objectForKey:@"myComment"]];
//        commentsCell.myComment.text=newOutput;
//
//        [commentsCell.commentImage sd_setImageWithURL:[NSURL URLWithString:[getData valueForKey:@"productImageUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//
//        return  commentsCell;
//    }
//    else
//    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"activityCell"];
        activityCell = (ActivityCell *)[ttableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(activityCell == nil)
        {
            
            [[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:self options:nil];
           
        }
        NSDictionary *getData=[tableData objectAtIndex:indexPath.row];
        //Activity list display
        activityCell.header_lbl.text=[getData objectForKey:@"activityHeading"];
        activityCell.timeDate_lbl.text=[getData objectForKey:@"timeSubmittedPrice"];
        [activityCell.product_Imageview sd_setImageWithURL:[NSURL URLWithString:[getData objectForKey:@"productImageUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        return  activityCell;
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(screenCounter == 1)
//    {
//        
//        cell.contentView.backgroundColor = [UIColor clearColor];
//        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(0,5,320,85)];
//        whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
//        whiteRoundedCornerView.layer.masksToBounds = NO;
//        whiteRoundedCornerView.layer.cornerRadius = 1.0;
//        //whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
//        //whiteRoundedCornerView.layer.shadowOpacity = 0.1;
//        [cell.contentView addSubview:whiteRoundedCornerView];
//        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
//        //add top view
//        UIView *vwTop=[[UIView alloc] initWithFrame:CGRectMake(1, 5, 320, 1)];
//        [vwTop setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:183.0/255.0 blue:186.0/255.0 alpha:0.2]];
//        [[cell contentView] addSubview:vwTop];
//        //end
//        //add bottom view
//        UIView *BottomVw=[[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 1)];
//        [BottomVw setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:183.0/255.0 blue:186.0/255.0 alpha:0.2]];
//        [[cell contentView] addSubview:BottomVw];
//    }
    
    //end
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	if (screenCounter == 1)
//	{
//		return 90;
//	}
//	else
    if (screenCounter == 2)
	{
		return 100.0;
	}
	else
	{
		return 80.0;
	}
    
}


#pragma mark - end

#pragma mark - Button Actions
//Action for tab bar button selection
- (IBAction)upperTabBtnSelected:(id)sender
{
    screenCounter = (int)[sender tag];
    switch ([sender tag])
    {
        //comments button set selected to display comments
//        case 1:
//            [commentsBtn setSelected:YES];
//            [timerBtn setSelected:NO];
//            [activityBtn setSelected:NO];
//            timer_view.hidden = YES;
//            [self setTopbarTitle];
//            break;
            //Activity button set selected to display my activity
        case 2:
            [commentsBtn setSelected:NO];
            [timerBtn setSelected:NO];
            [activityBtn setSelected:YES];
            timer_view.hidden = YES;
            [self setTopbarTitle];
            break;
            //Display offer feed screen
        case 3:
            timer_view.hidden = YES;
            [self gotoOfferTicker];
            screenCounter = 2;
            break;
            //timer button selected to display timer
        case 4:
            [tableData removeAllObjects];
            [commentsBtn setSelected:NO];
            [timerBtn setSelected:YES];
            [activityBtn setSelected:NO];
            timer_view.hidden = NO;
            [self setTopbarTitle];
            break;
            
        default:
            break;
    }
    
}
- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

#pragma mark - Navigate to Offer Ticker
//Navigating to offer feed module
-(void)gotoOfferTicker
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *cont=[storyboard instantiateViewControllerWithIdentifier:@"OfferTickerViewController"];
    [self.navigationController pushViewController:cont animated:YES];
}
#pragma mark - end


@end
