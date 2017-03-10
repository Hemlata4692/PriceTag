//
//  ProductAvailableViewController.m
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ProductAvailableViewController.h"
#import "ProdcutDetailViewController.h"
#import "UIImageView+WebCache.h"


@interface ProductAvailableViewController (){
    int nowOther;
    int storeID;
    NSString *globe_other, *globe_location;
    NSDictionary *jsonDictionary;
    DataHolderClass *data;
    NSMutableDictionary *pickerDict;
    NSMutableArray *storearray;
    NSArray *fields;
    double latitude;
    double longitude;
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
}
@property(nonatomic,strong)BSKeyboardControls *keyboardControls;
@property(nonatomic,retain)  NSDictionary *jsonDictionary;
@property(nonatomic,retain)  NSMutableDictionary *pickerDict;
@property(nonatomic,retain)  NSMutableArray *storearray;
@property(nonatomic,retain) NSArray *fields;
@end

@implementation ProductAvailableViewController
@synthesize productId,productImage,productName,productUnit,productWeight;
@synthesize locationManager,forwardGeocoder,pickerArray,displayedResults;
@synthesize jsonDictionary,pickerDict,storearray,fields;

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
    
    //Latitude,Longitude
    manager=[[CLLocationManager alloc]init];
    geocoder=[[CLGeocoder alloc]init];
    self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
    
    //Picker View
    [self addPickerView];
    pickerArray=[[NSMutableArray alloc]init];
    storearray=[[NSMutableArray alloc]init];
    
    //Displaying selected product details
    _subViewDesc.text=[NSString stringWithFormat:@"%@, %@%@",productName,productWeight,productUnit];
    
    NSURL * url = [NSURL URLWithString:productImage];
    [_subViewImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _priceTextField=[GlobalMethod customPadding:self.priceTextField];
    _otherTextField=[GlobalMethod customPadding:self.otherTextField];
    _storeNameTextField=[GlobalMethod customPadding:self.storeNameTextField];
    _locationTextField=[GlobalMethod customPadding:self.locationTextField];
    
    [[self.otherTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
  
    //Textfield delegates
    self.priceTextField.delegate = self;
    self.otherTextField.delegate = self;
    self.storeNameTextField.delegate = self;
    self.locationTextField.delegate = self;
    
    _locationTextField.enabled=NO;
    
    _storeNameTextField.hidden=YES;
    _storeNameImgView.hidden=YES;
    _storeNamePNG.hidden=YES;

    self.locationTextField.frame=CGRectMake(12, 217, 297, 40);
    self.locationImgView.frame=CGRectMake(12, 217, 297, 40);
    self.locationPNG.frame=CGRectMake(19, 226, 21, 21);
    
    self.submitOutlet.frame=CGRectMake(12, 280, 297, 40);
    
    fields = @[_priceTextField,_otherTextField];
      //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    CALayer *BottomBorder = [CALayer layer];
    BottomBorder.frame = CGRectMake(0.0f, 97.0f, self.topSubView.frame.size.width, 1.0f);
    BottomBorder.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    [self.topSubView.layer addSublayer:BottomBorder];
    [myDelegate ShowIndicator];
    
    //Method for fetching store list from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(getStoreList) toTarget:self withObject:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=@"SUBMIT PRICE";
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.locationManager.delegate=nil;
    
}

-(void)dealloc
{
    [pickerArray release];
    [storearray release];
    [manager release];
    [geocoder release];
    [locationManager release];
    [forwardGeocoder release];
    [myPickerView release];
    
    [super dealloc];
    
}

#pragma mark - end

#pragma mark - getStoreList

//Fetching store names

-(void)getStoreList
{
     //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        //Json request
        NSDictionary *requestDict = NULL;
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"getStoreList"];
        
        NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
        
        // NSLog(@"totalBodyData is %@",tempDict);
        
        [myDelegate StopIndicator];
        if (tempDict.count>0 )
        {
            
            storearray=[[NSMutableArray alloc]init];
            //Data parsing
            NSArray *arr=[tempDict objectForKey:@"storeList"];
            for (int i=0; i<[arr count]; i++) {
                data = [[DataHolderClass alloc]init];
                NSDictionary *b=arr[i];
                data.store_id=[b objectForKey:@"storeId"];
                data.store_name=[b objectForKey:@"storeName"];
                data.store_location=[b objectForKey:@"storeLocation"];
                [storearray addObject:data];
            }
            [storearray addObject:@"Other"];
            
            [myPickerView reloadAllComponents];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
}
#pragma mark - end

#pragma mark - Keyboard Controls Delegate
//Keyboard toolbar delegate actions adding keyboard controls
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    UIView *view;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]< 7.0) {
        view = field.superview.superview;
    } else {
        view = field.superview.superview.superview;
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
    
    //Setting up the fetched values of stores in store list picker
    if (keyboardControls.activeField==_otherTextField)
    {
        if (!nowOther)
        {
            data = [[DataHolderClass alloc]init];
            if([storearray count]==1)
            {
                _otherTextField.text=[storearray objectAtIndex:0];
            }
            else
            {
                data = [storearray objectAtIndex:0];
                _otherTextField.text=data.store_name;
            }
            _otherTextField.text=data.store_name;
            _locationTextField.text=data.store_location;
            storeID=[data.store_id intValue];
        }
        else
        {
            _otherTextField.text = globe_other;
            _locationTextField.text=globe_location;
            if ([_otherTextField.text isEqualToString:@"Other"])
            {
                self.storeNameTextField.text=@"";
                _locationTextField.text=@"";
            }
            
            
            [_otherTextField resignFirstResponder];
        }
    }
    
    if ([_otherTextField.text isEqualToString:@"Other"])
    {
        //Reframing textfields in case of other picker
        self.storeNameTextField.hidden=NO;
        self.storeNameImgView.hidden=NO;
        self.storeNamePNG.hidden=NO;
        
        
        _locationTextField.enabled=YES;
        
        self.locationTextField.frame=CGRectMake(12, 265, 297, 40);
        self.locationImgView.frame=CGRectMake(12, 265, 297, 40);
        self.locationPNG.frame=CGRectMake(19, 274, 21, 21);
        self.submitOutlet.frame=CGRectMake(12, 331, 297, 40);
        //set bskeyboardcontrols fields
        self.keyboardControls.fields=@[_priceTextField,_otherTextField,_storeNameTextField,_locationTextField];
        
    }
    else
    {
        _storeNameTextField.hidden=YES;
        _storeNameImgView.hidden=YES;
        _storeNamePNG.hidden=YES;
        _locationTextField.enabled=NO;
        
        self.locationTextField.frame=CGRectMake(12, 217, 297, 40);
        self.locationImgView.frame=CGRectMake(12, 217, 297, 40);
        self.locationPNG.frame=CGRectMake(19, 226, 21, 21);
        
        self.submitOutlet.frame=CGRectMake(12, 280, 297, 40);
        //set bskeyboardcontrols fields
        self.keyboardControls.fields=@[_priceTextField,_otherTextField];
        
    }
    
    
}

#pragma mark - end


#pragma mark - TextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-(2.5* textField.frame.size.height)) animated:YES];
    
    [self.keyboardControls setActiveField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - end

#pragma mark - Picker View

//Adding picker for store names
-(void)addPickerView
{
    nowOther=0;
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    _otherTextField.inputView = myPickerView;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [storearray count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Setting selected picker values
    nowOther=1;
    if (row==storearray.count-1)
    {
        globe_other=[storearray objectAtIndex:row];
    }
    else
    {
        data = [[DataHolderClass alloc]init];
        data=[storearray objectAtIndex:row];
        globe_other=data.store_name;
        globe_location=data.store_location;
        storeID=[data.store_id intValue];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (row==storearray.count-1) {
        return [storearray objectAtIndex:row];
    }
    else{
        data = [[DataHolderClass alloc]init];
        data=[storearray objectAtIndex:row];
        
        globe_other=data.store_name;
        globe_location=data.store_location;
        storeID=[data.store_id intValue];
        
        return data.store_name;
    }
    
}

#pragma mark - end


#pragma mark - Submit Price API

//Submitt new price for product web service to submit new price for the product
-(void)submitProductPrice
{
    //Json request
    NSDictionary *requestDict;
    if ([_otherTextField.text isEqualToString:@"Other"])
    {
        
        requestDict = @{@"user_id":myDelegate.userId,@"store_id":[NSNumber numberWithInt:-1],@"product_price":[NSNumber numberWithDouble:[self.priceTextField.text doubleValue]],@"store_name":self.storeNameTextField.text,@"store_location":self.locationTextField.text,@"store_latitude":[NSNumber numberWithDouble:latitude],@"store_longitude":[NSNumber numberWithDouble:longitude],@"product_id":productId};
        
    }
    else
    {
        requestDict = @{@"user_id":myDelegate.userId,@"store_id":[NSNumber numberWithInt:storeID],@"product_price":[NSNumber numberWithDouble:[self.priceTextField.text doubleValue]],@"store_location":self.locationTextField.text,@"store_name":self.otherTextField.text,@"product_id":productId};
    }
    jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"submitPrice"];
    
    NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
    
    // NSLog(@"totalBodyData is %@",tempDict);
    
    [myDelegate StopIndicator];
    if ([[tempDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        _storeNameTextField.text=@"";
        _priceTextField.text=@"";
        _locationTextField.text=@"";
        _otherTextField.text=@"";
        //Moving tp product detail screen after submitting new price for product
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProdcutDetailViewController *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"ProdcutDetailViewController"];
        objProductDetail.productId=self.productId;
        [self.navigationController pushViewController:objProductDetail animated:YES];
    }
    else if ([[tempDict valueForKey:@"isSuccess"] intValue]==0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[tempDict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if ([[tempDict valueForKey:@"isSuccess"] intValue] == 2)
    {
        [self performSelectorOnMainThread:@selector(callLogoutMethod) withObject:nil waitUntilDone:NO];
        
        return;
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

//alert shows that user's account has deactivated by admin
-(void)callLogoutMethod
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your account has been deactivated by administrator" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag=002;
    [alert show];
    //[self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    
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
#pragma mark - end

#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alert.tag==002)
    {
        [self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    }
}

#pragma mark - end
#pragma mark - Button Action
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Action for submitting price for a product
- (IBAction)submitPriceBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    //Alert displaying if the textfields are not filled
    if(self.priceTextField.text.length==0)
    {
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the product price." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        [wrongfield release];
        return;
    }
    else if(self.otherTextField.text.length==0){
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
         [wrongfield release];
        return;
    }
    else if([self.otherTextField.text isEqual:@"Other"])
    {
        if(self.storeNameTextField.text.length==0){
            
            UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [wrongfield show];
             [wrongfield release];
            return;
        }
        else if(self.locationTextField.text.length==0){
            
            UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [wrongfield show];
             [wrongfield release];
            return;
        }
    }
    
    else if(self.locationTextField.text.length==0){
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
         [wrongfield release];
        return;
    }
    
    [myDelegate ShowIndicator];
    
    if(!forwardGeocoder){
        forwardGeocoder = [[MJGeocoder alloc] init];
        forwardGeocoder.delegate = self;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *string=[NSString stringWithFormat:@"%@",_locationTextField.text];
    
    [forwardGeocoder findLocationsWithAddress:string title:nil];
}
#pragma mark - end

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	//show network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	
}
#pragma mark - end

#pragma mark - MJGeocoderDelegate

//Sending lat long of store in particular location
- (void)geocoder:(MJGeocoder *)geocoder didFindLocations:(NSArray *)locations{
	//hide network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [displayedResults release];
    displayedResults = [locations retain];
    Address *address = [displayedResults objectAtIndex:0];
    latitude=[address.latitude doubleValue];
    longitude=[address.longitude doubleValue];
    
    //Submit price for product web service call
    [self performSelector:@selector(submitProductPrice) withObject:nil afterDelay:.1];
    
}
//Displaying error message if user enters invalid location
- (void)geocoder:(MJGeocoder *)geocoder didFailWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    [myDelegate StopIndicator];
//    if([error code] == 1){
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have entered an invalid location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//        
//    }
    latitude=0.0;
    longitude=0.0;
    
    //Submit price for product web service call
    
    [self performSelector:@selector(submitProductPrice) withObject:nil afterDelay:.1];

}
#pragma mark - end
@end
