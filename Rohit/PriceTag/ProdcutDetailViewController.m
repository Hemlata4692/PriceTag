//
//  ProdcutDetailViewController.m
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ProdcutDetailViewController.h"
#import "commentsCell.h"
#import "ProductDetailCell.h"
#import "GlobalMethod.h"
#import "WebService.h"
#import "StoreDetailView.h"
#import "UIImageView+WebCache.h"
#import "ProductAvailableViewController.h"
@interface ProdcutDetailViewController ()
{
    NSDictionary *jsonDictionary;
    int product_ID;
    NSTimer *timer;
    int hour1,minute,second,day;
    int secondsLeft;
}
@property(retain, nonatomic) UIToolbar *toolbar;
@property(retain, nonatomic) NSDictionary *jsonDictionary;
@property(nonatomic,assign) int hour1;
@property(nonatomic,assign) int minute;
@property(nonatomic,assign) int second;
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int secondLeft;
@end

@implementation ProdcutDetailViewController
@synthesize hour1,minute,second,secondLeft,day;
@synthesize jsonDictionary;
@synthesize storeTableView;
//@synthesize screenCounter,commentsBtn,addCommentBtn,commentTxtBox,nearbyBtn;
@synthesize productBarcode,productImage,productName,productWeight,timerLabel;
@synthesize comment,productCell,scrollView,productId,commentArray,nearByArray;
@synthesize Product_Barcode,product_Name,product_Unit,product_Weight,productImageUrl;
@synthesize todayDate,endingDate;

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
    product_ID=[productId intValue];
    
    commentArray=[[NSMutableArray alloc]init];
    nearByArray=[[NSMutableArray alloc]init];
    
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    self.tabBarController.tabBar.hidden=NO;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg.png"]];
//    commentTxtBox.hidden=YES;
//    addCommentBtn.hidden=YES;
//    nearbyBtn.enabled = NO;
//    [nearbyBtn setSelected:YES];
    
//    [commentsBtn setSelected:NO];
//    _textView.hidden=YES;
//    _textView.layer.cornerRadius=5;
//    _textView.layer.masksToBounds=YES;
//    _textView.layer.borderWidth=1.0f;
//    _textView.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
//    commentTxtBox.delegate=self;
//screenCounter=1;
   
    
    
    //Latitude,Longitude
//    myDelegate.locationManager = [[CLLocationManager alloc] init];
//    myDelegate.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//    myDelegate.locationManager.distanceFilter=kCLDistanceFilterNone;
//    
//	[myDelegate.locationManager startUpdatingLocation];
//    [myDelegate ShowIndicator];
//    //Method for fetching product detail with near by store details and comments on the product from server which is called in seperate thread
//    [NSThread detachNewThreadSelector:@selector(ProductDetail) toTarget:self withObject:nil];
    
    
    
    //Displaying toolbar with keyboard to resign keyboard
//    if(_toolbar==nil)
//    {
//        _toolbar=[[UIToolbar alloc] initWithFrame:(CGRectMake(0, 0, self.view.bounds.size.width, 44))];
//        
//        
//        UIBarButtonItem *ressign = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(reassignKeyboard:)];
//        
//        [_toolbar setItems:[[NSArray alloc] initWithObjects:ressign, nil]];
//    }
//    commentTxtBox.inputAccessoryView=_toolbar;


}
//Resign keyboard on done pressed
//-(void)reassignKeyboard:(id)sender
//{
////    [commentTxtBox resignFirstResponder];
//}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    self.tabBarController.tabBar.hidden=NO;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _noRecord.text = @"No price submitted yet, be the first to submit price on this item by clicking ‘submit price’.";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=@"PRODUCT DETAIL";
    //set selected button
//    if(screenCounter==1)
//    {
//        [nearbyBtn setSelected:YES];
//        [commentsBtn setSelected:NO];
    
//    [commentsBtn setSelected:NO];
    
    
//    }
//    else
//    {
//        [nearbyBtn setSelected:NO];
////        [commentsBtn setSelected:YES];
//    }
    
    self.navigationItem.leftBarButtonItem = nil;
    GlobalNavigationBackButton *global = [GlobalNavigationBackButton new];
    global.myVC = self;
    self.navigationItem.leftBarButtonItem = [GlobalNavigationBackButton customizeMyNavigationBar:self];
    
    myDelegate.locationManager = [[CLLocationManager alloc] init];
    myDelegate.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    myDelegate.locationManager.distanceFilter=kCLDistanceFilterNone;
    
    [myDelegate.locationManager startUpdatingLocation];
//    [nearByArray removeAllObjects];
//    [storeTableView reloadData];
    [myDelegate ShowIndicator];
    //Method for fetching product detail with near by store details and comments on the product from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(ProductDetail) toTarget:self withObject:nil];
    
    //[self setTopbarTitle];
    
}

-(void)goBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    if(timer.isValid)
    {
        [timer invalidate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end


//#pragma mark - Text Field Delegate
////Moving cursor to next line when pressing return key in textview
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    [textView.text isEqualToString:@"\n"];
//    
//    return YES;
//}
//
//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y+150);
//    [self.scrollView setContentOffset:scrollPoint animated:YES];
//    
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self.scrollView setContentOffset:CGPointZero animated:YES];
//}
//#pragma mark - end

#pragma mark - Button Action
//Reframing table view according to iPhone5 and iPhone4
-(void)reFrameTableview
{

//    if([nearbyBtn isSelected])
//    {
        if ([GlobalMethod isIphone5])
        {
            storeTableView.frame=CGRectMake(0, 190, 320, 260);
        }
        else
        {
            storeTableView.frame=CGRectMake(0, 190, 320, 170);
        }
//    }
//    else{
//        if ([GlobalMethod isIphone5])
//        {
//            storeTableView.frame=CGRectMake(0, 285, 320,160);
//        }
//        else
//        {
//            storeTableView.frame=CGRectMake(0, 285, 320,80);
//        }
//    
//    }
        [storeTableView reloadData];

}
// Action to set selected tab
//- (IBAction)selectedButton:(id)sender
//{
//    _noRecord.hidden = YES;

//    screenCounter = (int)[sender tag];
//    switch (screenCounter)
//    {
//        
//        case 1:
    
            //near by tab set selected
//            [nearbyBtn setSelected:YES];
    
//            [commentsBtn setSelected:NO];
    
//            commentTxtBox.hidden=YES;
//            addCommentBtn.hidden=YES;
//            _textView.hidden=YES;
//            self.noRecord.frame=CGRectMake(0, 325, 320, 21);
//            if(nearByArray.count<1)
//            {
//                _noRecord.hidden = NO;
//            }
//            else
//            {
//                self.noRecord.text=@"No record found for Nearby.";
//                _noRecord.hidden = YES;
//            }
    
//            break;
//            
//        case 2:
//            //Comments tab set selected
//            [commentsBtn setSelected:YES];
//            [nearbyBtn setSelected:NO];
//             self.noRecord.frame=CGRectMake(0, 325, 320, 21);
//            if(commentArray.count<1)
//            {
//                _noRecord.hidden = NO;
//            }
//            else
//            {
//               self.noRecord.text=@"You have not commented on any product yet.";
//                _noRecord.hidden = YES;
//            }
//            
//            commentTxtBox.hidden=NO;
//            addCommentBtn.hidden=NO;
//            _textView.hidden=NO;
//            break;
//    }
//    [self reFrameTableview];
    
    
    
//}

- (IBAction)moveBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - end
#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (screenCounter == 1)
//    {
        return nearByArray.count;
//    }
//    else
//    {
//        return commentArray.count;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)ttableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (screenCounter == 1)
//    {
       //Displaying near by stores on table view
        NSString *CellIdentifier = [NSString stringWithFormat:@"productCell"];
        productCell = (ProductDetailCell *)[ttableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(productCell == nil)
        {
            
            [[NSBundle mainBundle] loadNibNamed:@"ProductDetailCell" owner:self options:nil];
            
            
        }
        
        DataHolderClass * data=[nearByArray objectAtIndex:indexPath.row];
        float distance;
        if([data.storeDistance_nearby floatValue]<1.0)
        {
            distance = [data.storeDistance_nearby floatValue]*1000.0;
            productCell.distanceLbl.text=[NSString stringWithFormat:@"%.02f",distance];
        productCell.distanceUnitLbl.text = @"m";
        }
        else
        {
            distance = [data.storeDistance_nearby floatValue];
            productCell.distanceLbl.text=[NSString stringWithFormat:@"%.02f",distance];
            productCell.distanceUnitLbl.text = @"km";
        
        }
        
        productCell.storeNameLbl.text=data.storeName_nearby;
        productCell.dollarLbl.text=data.productPrice_nearby;
        return  productCell;
//    }
//    else
//    {
//        //Displaying comments on table view
//        NSString *CellIdentifier = [NSString stringWithFormat:@"CommentCell"];
//        comment = (commentsCell *)[ttableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if(comment == nil)
//        {
//            
//            [[NSBundle mainBundle] loadNibNamed:@"commentsCell" owner:self options:nil];
//            
//            
//        }
//        DataHolderClass * data=[commentArray objectAtIndex:indexPath.row];
//        comment.iconImgView.layer.cornerRadius = comment.iconImgView.frame.size.width / 2;
//        comment.iconImgView.clipsToBounds = YES;
//        
//        [comment.iconImgView sd_setImageWithURL:[NSURL URLWithString:data.user_image_url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//        
//        comment.nameLbl.text=data.user_name;
//        comment.commentLbl.text=data.user_comment;
//        
//        return  comment;
//        
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	if (screenCounter == 1)
//	{
		return 70;
//	}
//	else
//	{
//		return 80;
//	}
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (screenCounter == 1)
//	{
        //Moving to store detail view on selecting the store from list
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        StoreDetailView * objStoreDetail = [storyboard instantiateViewControllerWithIdentifier:@"StoreDetailView"];
        objStoreDetail.product_id = self.productId;
        objStoreDetail.tabChecker = YES;
        [self.navigationController pushViewController:objStoreDetail animated:YES];
        
//    }
    
    
}

#pragma mark - end

#pragma mark - Product detail api Calling
//Logout
-(void)callLogoutMethod
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your account has been deactivated by administrator" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag=004;
    [alert show];
    //[self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    
}
//Adding comment on product
//- (IBAction)addComment:(id)sender
//{
//    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    commentTxtBox.text= [commentTxtBox.text stringByTrimmingCharactersInSet:whitespace];
//    if ([commentTxtBox.text length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter the comment." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        return;
//    }
//    
//    [myDelegate ShowIndicator];
//   //Method for adding comment tp product request from server which is called in seperate thread
//    [NSThread detachNewThreadSelector:@selector(addCommentWebservice:) toTarget:self withObject:commentTxtBox.text];
//    [commentTxtBox resignFirstResponder];
//    
//}

//Add comment Web service
//-(void)addCommentWebservice:(NSString *)object
//{
//    
//    NSDictionary *requestDict = @{@"userId":myDelegate.userId,@"productId":[NSNumber numberWithInt:product_ID],@"commentContent":object};
//    
//    
//    jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"addComment"];
//    
//    
//   // NSLog(@"totalBodyData is %@",jsonDictionary);
//    [myDelegate StopIndicator];
//    
//    
//    if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 1)
//        
//    {
//       // NSString * tempStr;
//        [self performSelectorOnMainThread:@selector(changeTxtboxText) withObject:nil waitUntilDone:NO];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[jsonDictionary valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        alert.tag = 007;
//        [alert show];
//        
//    }
//    else if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 2)
//    {
//    
//        [self performSelectorOnMainThread:@selector(callLogoutMethod) withObject:nil waitUntilDone:NO];
//        
//        return;
//    
//    }
//    else
//    {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[jsonDictionary valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//    }
//    
//}
//-(void)changeTxtboxText
//{

//    commentTxtBox.text = @"";

//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(alertView.tag==007)
    {
        [commentArray removeAllObjects];
        [nearByArray removeAllObjects];
        [myDelegate ShowIndicator];
        //Method for fetching product detail with near by store details and comments on the product from server which is called in seperate thread
        [NSThread detachNewThreadSelector:@selector(ProductDetail) toTarget:self withObject:nil];

    
    }
    else if (alertView.tag == 004)
    {
    [self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    
    }

}
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
//Product details web service to fetch details of product
-(void)ProductDetail
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        //json request
        NSDictionary *requestDict = @{@"product_id":productId,@"current_position_latitude":[NSString stringWithFormat:@"%f",[GlobalMethod getCurrentLatitude]],@"current_position_longitude":[NSString stringWithFormat:@"%f",[GlobalMethod getCurrentLongitude]]};
       
        NSDictionary* dataDict =[WebService generateJsonAndCallApi:requestDict methodName:@"productDetails"];
        NSLog(@"dataDict is %@",dataDict);
        [self parseProductDetailData:dataDict];
        [myDelegate StopIndicator];
    }
}
//Data parsing and displaying
-(void)parseProductDetailData :(NSDictionary *)dataDict
{
    [nearByArray removeAllObjects];
    if ([[dataDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        _noRecord.hidden = YES;
        
        NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
        todayDate=[dataDict objectForKey:@"today_date"];
        endingDate=[dataDict objectForKey:@"submission_close_date"];
        
        //Timer
        
        [self performSelectorOnMainThread:@selector(productDetailTimer) withObject:nil waitUntilDone:NO];
        //Parsing data to display product detail
        productImageUrl = [tempDict objectForKey:@"productImageUrl"];
        product_Name = [tempDict objectForKey:@"productName"];
        product_Unit= [tempDict objectForKey:@"productUnit"];
        product_Weight=[tempDict objectForKey:@"productWeight"];
        Product_Barcode=[tempDict objectForKey:@"productBarCode"];
        
        //Parsing comments list
//        NSArray * tempAry = [tempDict objectForKey:@"commentList"];
//        
//        for (int i =0; i<tempAry.count; i++)
//        {
//            DataHolderClass * data = [[DataHolderClass alloc]init];
//            NSDictionary *commentdict=tempAry[i];
//            data.user_image_url=[commentdict objectForKey:@"userImageUrl"];
//            data.user_name=[commentdict objectForKey:@"userName"];
//            data.user_comment=[commentdict objectForKey:@"commentContent"];
//            [commentArray addObject:data];
//            
//        }
        
        NSMutableDictionary * tempDict1 = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
        NSArray * nearByarr = [tempDict1 objectForKey:@"nearByList"];
        //Parsing nearby store list data
        for (int i =0; i<nearByarr.count; i++)
        {
            DataHolderClass * data = [[DataHolderClass alloc]init];
            NSDictionary *nearbyDict=nearByarr[i];
            data.storeDistance_nearby=[nearbyDict objectForKey:@"distance"];
            data.storeLocation_nearby=[nearbyDict objectForKey:@"storeLocation"];
            data.productPrice_nearby=[nearbyDict objectForKey:@"productPrice"];
            data.storeName_nearby=[nearbyDict objectForKey:@"storeName"];
            [nearByArray addObject:data];
            
        }
        
        if(nearByArray.count<1)
                        {
                            _noRecord.hidden = NO;
                        }
                        else
                        {
//                            self.noRecord.text=@"No record found for Nearby.";
                            _noRecord.hidden = YES;
             }
            
        //Data displaying
      //  productWeight.text=[NSString stringWithFormat:@"Weight:%@%@",product_Weight,product_Unit];
        productName.text=[NSString stringWithFormat:@"%@, %@%@",product_Name,product_Weight,product_Unit];
        [productImage sd_setImageWithURL:[NSURL URLWithString:productImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        productBarcode.text=Product_Barcode;

        //Setting button Text
        
//        NSString *nearString = [NSString stringWithFormat:@" Nearby Stores (%lu)",(unsigned long)nearByArray.count];
        _nearByLabel.text = [NSString stringWithFormat:@" Nearby Stores (%lu)",(unsigned long)nearByArray.count];

//        [nearbyBtn setTitle:nearString forState:UIControlStateNormal];
//        [nearbyBtn setTitle:nearString forState:UIControlStateSelected];
//        NSString *commentString = [NSString stringWithFormat:@" Comments (%lu)",(unsigned long)commentArray.count];
//        [commentsBtn setTitle:commentString forState:UIControlStateNormal];
//        [commentsBtn setTitle:commentString forState:UIControlStateSelected];

//        if(nearByArray.count<1)
//        {
//            _noRecord.hidden = NO;
//        }
//        else
//        {
//            _noRecord.hidden = YES;
//        }
        [self reFrameTableview];
        
    }
    
    else
    {
         [self reFrameTableview];
        if ([[dataDict valueForKey:@"isSuccess"] intValue] == 0 && dataDict !=NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[dataDict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

#pragma mark - Remaining timer countdown
//Running competition timer
-(void)productDetailTimer
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
    secondsLeft = [endDate timeIntervalSinceDate:startDate1];
    [timer invalidate];
    //Updating Timer values
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}
//Method for updating Timer values
- (void)updateCounter:(NSTimer *)theTimer
{
    
    if(secondsLeft > 0 )
    {
        
        secondsLeft -- ;
        timerLabel.hidden=NO;
        day=(secondsLeft/86400);
        hour1 = (secondsLeft / 3600);
        minute = (secondsLeft /60) % 60;
        second = (secondsLeft  % 60);
        timerLabel.text = [NSString stringWithFormat:@"Time Left: %02i:%02i:%02i",hour1,minute,second];
        
    }
    
    else
    {
        timerLabel.text = [NSString stringWithFormat:@"Time Left: %02i:%02i:%02i",0,0,0];
        [timer invalidate];
        timer = nil;
    }
    
}

#pragma mark - end


- (IBAction)submitPrice:(UIButton *)sender {
//    productImageUrl = [tempDict objectForKey:@"productImageUrl"];
//    product_Name = [tempDict objectForKey:@"productName"];
//    product_Unit= [tempDict objectForKey:@"productUnit"];
//    product_Weight=[tempDict objectForKey:@"productWeight"];
//    Product_Barcode=[tempDict objectForKey:@"productBarCode"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductAvailableViewController *cont=[storyboard instantiateViewControllerWithIdentifier:@"ProductAvailableViewController"];
//    DataHolderClass *data=[ResultArray objectAtIndex:indexPath.row];
    cont.productId = productId;
    cont.productImage=productImageUrl;
    cont.productName=product_Name;
    cont.productWeight=product_Weight;
    cont.productUnit=product_Unit;
    [self.navigationController pushViewController:cont animated:YES];
}
@end
