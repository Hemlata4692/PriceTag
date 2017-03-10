//
//  StoreDetailView.m
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "StoreDetailView.h"
#import "StoreDetailCell.h"
#import "UIImageView+WebCache.h"

@interface StoreDetailView (){
    NSArray *nameArray;
    NSArray *dateArray;
    NSArray *priceArray;
    BOOL isSelected;
    NSTimer *timer;
    int hour1,minute,second,day;
    int secondsLeft;
    UILabel *refreshDateTimeLabel;
    
}

@property(nonatomic,retain)NSArray *nameArray;
@property(nonatomic,retain) NSArray *dateArray;
@property(nonatomic,retain)NSArray *priceArray;
@property(nonatomic,assign) int hour1;
@property(nonatomic,assign) int minute;
@property(nonatomic,assign) int second;
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int secondLeft;
@end

@implementation StoreDetailView
@synthesize hour1,minute,second,secondLeft,day;
@synthesize cell;
@synthesize data_array,nameArray,priceArray,dateArray;
@synthesize product_id,productname_nearby,productWeight_nearby,productUnit_nearby,ProductImageUrl_nearby,Product_Barcode,product_Weight,productImage,Product_Name,productBarcode_nearby;
@synthesize nameProduct,weightProduct,unitProduct,barcodeProduct,imageUrlProduct;
@synthesize start_date;
@synthesize end_date, refreshDatetime, tabChecker;


#pragma mark - View Life Cycle
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
    // Do any additional setup after loading the view.
    
    if (self.tabBarController.selectedIndex == 1) {
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
            storeTableView.frame =CGRectMake(storeTableView.frame.origin.x, storeTableView.frame.origin.y, storeTableView.frame.size.width, storeTableView.frame.size.height-44);
        }
    }

    
    self.data_array = [[NSMutableArray alloc]init];
    self.separator1View.backgroundColor=[UIColor lightGrayColor];
    self.separator2View.backgroundColor=[UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    if(timer.isValid)
    {
        [timer invalidate];
    }
}

-(void)dateTimeMethod{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    
    //    NSString *dateString = [dateFormatter stringFromDate: localDate];
    
    
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"dd-MMM-yyyy HH:mm:ss";
    
    
    refreshDatetime.text = [timeFormatter stringFromDate: localDate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self dateTimeMethod];
    [myDelegate ShowIndicator];
    
    //Method for fetching submitted price list for products from server which is called in seperate thread
    [self performSelector:@selector(callSubmittedPriceList) withObject:nil afterDelay:.3];

}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
}


#pragma mark - end

#pragma mark - Submitted Price API Calling
//Submitted price list Web service
-(void)callSubmittedPriceList
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
    NSDictionary *requestDict = @{@"product_id":self.product_id,@"user_id":myDelegate.userId};
  
    NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"submittedPriceList"];
   // NSLog(@"dataDict is %@",dataDict);
    [self parseSubmittedPriceData:dataDict];
    
    }
}

//Parsing and displaying data
-(void)parseSubmittedPriceData :(NSDictionary *)dataDict
{
    if ([[dataDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        [self.data_array removeAllObjects];
       //Data parsing
        NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
        nameProduct=[tempDict objectForKey:@"productName"];
        weightProduct=[tempDict objectForKey:@"productWeight"];
        unitProduct=[tempDict objectForKey:@"productUnit"];
        barcodeProduct=[tempDict objectForKey:@"productBarCode"];
         imageUrlProduct=[tempDict objectForKey:@"productImageUrl"];
        
        NSArray * tempAry = [tempDict objectForKey:@"submittedPriceList"];
        start_date = [tempDict objectForKey:@"today_date"];
        end_date = [tempDict objectForKey:@"submission_close_date"];
        for (int i =0; i<tempAry.count; i++)
        {
            DataHolderClass * data = [[DataHolderClass alloc]init];
            data.likeDislikeFlag = YES;
            NSDictionary * tempDict = [tempAry objectAtIndex:i];
            data.flagForLike = [tempDict objectForKey:@"flagForLike"];
            if ([data.flagForLike isEqualToString:@"like"] || [data.flagForLike isEqualToString:@"dislike"]) {
                data.likeDislikeFlag = NO;
            }
            else{
                data.likeDislikeFlag = YES;
            }
            
            data.product_price = [tempDict objectForKey:@"submittedPrice"];
            data.submittedProductPriceId = [tempDict objectForKey:@"submittedProductPriceId"];
            data.timeSubmitted = [tempDict objectForKey:@"timeSubmitted"];
            data.totalDislikes = [tempDict objectForKey:@"totalDislikes"];
            data.totalLikes = [tempDict objectForKey:@"totalLikes"];
            data.userName = [tempDict objectForKey:@"userName"];
            data.currentRank = [[tempDict objectForKey:@"currentRank"] intValue];
            data.previousRank = [[tempDict objectForKey:@"previousRank"] intValue];
            data.userId = [[tempDict objectForKey:@"userId"] intValue];
            [self.data_array addObject:data];
        }
//        [self dateTimeMethod];
        //Displaying data
       // product_Weight.text=[NSString stringWithFormat:@"Weight:%@%@",weightProduct,unitProduct];
        Product_Name.text=[NSString stringWithFormat:@"%@, %@%@",nameProduct,weightProduct,unitProduct];
        [productImage sd_setImageWithURL:[NSURL URLWithString:imageUrlProduct] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        Product_Barcode.text=barcodeProduct;

        if(self.data_array.count<1)
        {
            noRecord_lbl.hidden = NO;
        }
        else
        {
            noRecord_lbl.hidden = YES;
        }
        [myDelegate StopIndicator];
        //Timer
        [self performSelectorOnMainThread:@selector(submittedPriceTimer) withObject:nil waitUntilDone:NO];
        [storeTableView reloadData];
    }
    else
    {
        if ([[dataDict valueForKey:@"isSuccess"] intValue] == 0 && dataDict !=NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dataDict valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    [self dateTimeMethod];
}


//LikeUnlike Web service to like and unlike a product
-(void)callLikeDislikeWebservice :(NSString *)productPriceId flag:(NSString *) flag
{
    NSDictionary *requestDict = @{@"userId":myDelegate.userId,@"submittedPriceId":productPriceId,@"flag":flag};
    NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"LikeUnlike"];
     NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
    NSLog(@"dataDict is %@",tempDict);
    [myDelegate StopIndicator];
    if ([[tempDict valueForKey:@"isSuccess"] intValue] == 2)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];

     }
    
}
#pragma mark - end

#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   
        [myDelegate ShowIndicator];
        [self performSelector:@selector(callSubmittedPriceList) withObject:nil afterDelay:0.3];
    

}
#pragma mark - end


#pragma mark - Remaining timer countdown
//Running cometition timer
-(void)submittedPriceTimer
{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
  
    NSString * start = start_date;
    NSDate *startDate1 = [f dateFromString:start];
    NSString * end = end_date;
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
    secondsLeft = [endDate timeIntervalSinceDate:startDate1];
    //Timer updation
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}
//Method for updating timer after calculations
- (void)updateCounter:(NSTimer *)theTimer
{
    
    if(secondsLeft > 0 )
    {
        secondsLeft -- ;
        timer_lbl.hidden=NO;
        day=(secondsLeft/86400);
        hour1 = (secondsLeft / 3600);
        minute = (secondsLeft /60) % 60;
        second = (secondsLeft  % 60);
        timer_lbl.text = [NSString stringWithFormat:@"Time Left: %02i:%02i:%02i",hour1,minute,second];
        
    }
    
    else
    {
        timer_lbl.text = [NSString stringWithFormat:@"Time Left: %02i:%02i:%02i",0,0,0];
        [timer invalidate];
        timer = nil;
    }
    
}
#pragma mark - end

#pragma mark - Table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return self.data_array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *customclassIdentifier=@"customcellIdentifier";
	cell=(StoreDetailCell*)[tableView dequeueReusableCellWithIdentifier:customclassIdentifier];
	if(cell==nil)
	{
        [[NSBundle mainBundle] loadNibNamed:@"StoryDetailCell" owner:self options:nil];
        
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
	}
    DataHolderClass * data = [self.data_array objectAtIndex:indexPath.row];
    cell.nameLabel.text=data.userName;
    cell.nameLabel.textColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0];
    
    cell.dateLabel.text=data.timeSubmitted;
    cell.dateLabel.textColor = [UIColor colorWithRed:(31.0/255.0) green:(31.0/255.0) blue:(31.0/255.0) alpha:1.0];
    
    cell.priceLabel.text=[NSString stringWithFormat:@"%@",data.product_price];
    cell.priceLabel.textColor = [UIColor colorWithRed:(219.0/255.0) green:(53.0/255.0) blue:(44.0/255.0) alpha:1.0];
    
    cell.totalLikes_lbl.text = [NSString stringWithFormat:@"%@",data.totalLikes];
    cell.totalDislikes_lbl.text = [NSString stringWithFormat:@"%@",data.totalDislikes];
    cell.rankingLabel.text = [NSString stringWithFormat:@"%d",data.currentRank];
    
    int rankDifference = data.currentRank - data.previousRank;
    if (rankDifference>0) {
        cell.upDownEqualImage.image = [UIImage imageNamed:@"down.png"];
    }
    else if(rankDifference<0){
         cell.upDownEqualImage.image = [UIImage imageNamed:@"up.png"];
    }
   /* else{
         cell.upDownEqualImage.image = [UIImage imageNamed:@"mid.png"];
    }
    */
    cell.likeOutlet.tag=(indexPath.row + 1) * 1;
	cell.unlikeOutlet.tag=(indexPath.row + 1) * -10;
    
    //NSLog(@"%ld",(long)cell.likeOutlet.tag);
   
    if([data.flagForLike isEqualToString:@"like"])
    {
        
        [cell.likeOutlet setSelected:YES];
        [cell.unlikeOutlet setSelected:NO];
        
    }
    else if ([data.flagForLike isEqualToString:@"dislike"])
    {
        [cell.likeOutlet setSelected:NO];
        [cell.unlikeOutlet setSelected:YES];
        
    }
    
    [cell.unlikeOutlet addTarget:self action:@selector(likeAndDislikeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeOutlet addTarget:self action:@selector(likeAndDislikeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - end

#pragma mark - Button Actions
//Like and dislike logic implementation
-(IBAction)likeAndDislikeBtnClicked:(UIButton *)sender
{
    
    int tempDislike;
    UIView *contentView;
    StoreDetailCell *Tempcell;
    
    contentView = [sender superview];
    
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:storeTableView];
    NSIndexPath *indexPath = [storeTableView indexPathForRowAtPoint:rootViewPoint];
    //    IndexrowCliniclist = indexPath;
    //    UITableViewCell *maincell = [storeTableView cellForRowAtIndexPath:indexPath];
    
    Tempcell = (StoreDetailCell *)[storeTableView cellForRowAtIndexPath:indexPath];
    
    //    NSIndexPath *indexPath = [storeTableView indexPathForCell:Tempcell];
    DataHolderClass * data = [data_array objectAtIndex:indexPath.row];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int myUserId =(int) [prefs integerForKey:@"checkUserId"];
    if (data.userId != myUserId) {
        if (data.likeDislikeFlag) {
            
            if ((sender.tag==(indexPath.row + 1) * 1) && !Tempcell.likeOutlet.isSelected)
            {
                //likes increment logic
                data.flagForLike = @"like";
                int likes = [data.totalLikes intValue];
                likes++;
                data.totalLikes = [NSString stringWithFormat:@"%d",likes];
                //end
                //dislike decrement logic
                int dislikes = [data.totalDislikes intValue];
                if(dislikes>0)
                {
                    dislikes--;
                    data.totalDislikes = [NSString stringWithFormat:@"%d",dislikes];
                }
                //end
                [Tempcell.likeOutlet setSelected:YES];
                [Tempcell.unlikeOutlet setSelected:NO];
                [self.data_array replaceObjectAtIndex:indexPath.row withObject:data];
            }
            else if ((sender.tag == (indexPath.row + 1) * -10) && !Tempcell.unlikeOutlet.isSelected)
            {
                //dislike decrement logic
                int dislikes = [data.totalDislikes intValue];
                
                dislikes++;
                data.totalDislikes = [NSString stringWithFormat:@"%d",dislikes];
                tempDislike=dislikes;
                
                //end
                //like logic
                int likes = [data.totalLikes intValue];
                if(likes>0)
                {
                    likes--;
                    data.totalLikes = [NSString stringWithFormat:@"%d",likes];
                    
                }
                //end
                [Tempcell.likeOutlet setSelected:NO];
                [Tempcell.unlikeOutlet setSelected:YES];
                data.flagForLike = @"dislike";
                
                [self.data_array replaceObjectAtIndex:indexPath.row withObject:data];
                
            }
            if (tempDislike==5) {
                [myDelegate ShowIndicator];
                [self performSelector:@selector(callLikeDislikeWebserviceInMainThread:) withObject:data afterDelay:0.3];
            }
            else
            {
                
                dispatch_group_t group = dispatch_group_create();
                
                dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                                     {
                                         [self callLikeDislikeWebservice:data.submittedProductPriceId flag:data.flagForLike];
                                     });
                
            }
            [storeTableView reloadData];
        }
    }
}
-(void)callLikeDislikeWebserviceInMainThread:(id)data
{
    DataHolderClass *d=(DataHolderClass *)data;
    [self callLikeDislikeWebservice:d.submittedProductPriceId flag:d.flagForLike];
}

- (IBAction)refresh:(UIButton *)sender {
//    [self dateTimeMethod];
    [myDelegate ShowIndicator];
    
    //Method for fetching submitted price list for products from server which is called in seperate thread
    [self performSelector:@selector(callSubmittedPriceList) withObject:nil afterDelay:.3];
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

@end
