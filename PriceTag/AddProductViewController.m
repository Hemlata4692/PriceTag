//
//  AddProductViewController.m
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "AddProductViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Base64.h"
#import "ProdcutDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface AddProductViewController (){
    int nowMeasure,nowOther;
    int storeID;
    NSString *globe_measure, *globe_other, *globe_location;
    NSString * txtFieldSelected;
    UIImage *image;
    NSDictionary *jsonDictionary;
    DataHolderClass *data;
    NSMutableArray *storearray;
    double latitude;
    double longitude;
    
    NSMutableDictionary *pickerDict;
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    UIImage *scaledImage;
    UIImagePickerController *picker;
    int sourceType;
    
    
}
@property(nonatomic,strong)BSKeyboardControls *keyboardControls;
@property(nonatomic,retain)  NSMutableArray *storearray;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@property(nonatomic,retain) NSMutableDictionary *pickerDict;

@end

@implementation AddProductViewController

@synthesize forwardGeocoder,locationManager,BarCodeValue,storearray,displayedResults,pickerArrayOther,pickerArrayMeasure,jsonDictionary,pickerDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle
-(void)dealloc
{
    [picker release];
    [pickerArrayMeasure release];
    [pickerArrayOther release];
    [storearray release];
    [manager release];
    [geocoder release];
    [locationManager release];
    [forwardGeocoder release];
    [myPickerView release];

    [super dealloc];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    picker = [[UIImagePickerController alloc] init];
    self.addPhoto.layer.cornerRadius = self.addPhoto.frame.size.width / 2;
    self.addPhoto.clipsToBounds = YES;
    
    [self addPickerViewMeasure];
    [self addPickerViewOther];
    pickerArrayOther=[[NSMutableArray alloc]init];
    storearray=[[NSMutableArray alloc]init];
    
    self.productName.delegate = self;
    self.barCode.delegate = self;
    self.other.delegate = self;
    self.storeName.delegate = self;
    self.location.delegate = self;
    self.price.delegate = self;
    self.weight.delegate = self;
    self.measure.delegate = self;
    
    [self modifyTextField:self.measure];
    
    _productName=[GlobalMethod customPadding:self.productName];
    _barCode=[GlobalMethod customPadding:self.barCode];
    _other=[GlobalMethod customPadding:self.other];
    _storeName=[GlobalMethod customPadding:self.storeName];
    _location=[GlobalMethod customPadding:self.location];
    _price=[GlobalMethod customPadding:self.price];
    _weight=[GlobalMethod customPadding:self.weight];
    
    [[self.other valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    [[self.measure valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    _barCode.text=BarCodeValue;
    _storeName.hidden=YES;
    _storenameImgView.hidden=YES;
    _storenamePNG.hidden=YES;
    
    self.location.enabled=NO;
    self.location.frame=CGRectMake(12, 256, 297, 40);
    self.locationImgView.frame=CGRectMake(12, 256, 297, 40);
    self.locationPNG.frame=CGRectMake(18, 265, 21, 21);
    
    
    self.price.frame=CGRectMake(12, 295, 297, 40);
    self.priceImgView.frame=CGRectMake(12, 295, 297, 40);
    self.pricePNG.frame=CGRectMake(18, 303, 21, 21);
    
    self.weight.frame=CGRectMake(12, 338, 162, 40);
    self.weightImgView.frame=CGRectMake(12, 338, 162, 40);
    self.weightPNG.frame=CGRectMake(18, 345, 21, 21);
    
    self.measure.frame=CGRectMake(188, 338, 121, 40);
    
    self.submitOutlet.frame=CGRectMake(12, 395, 297, 40);
    
    
    NSArray *fields = @[_productName,_barCode,_other,_price,_weight,_measure];
    //first character capital
    _productName.autocapitalizationType = UITextAutocapitalizationTypeSentences;

      //Keyboard toolbar action to display toolbar with keyboard to move next,previous
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    _barCode.enabled=YES;
    
    [myDelegate ShowIndicator];
    
    //Method for fetching store list from server which is called in seperate thread
    [NSThread detachNewThreadSelector:@selector(addProductStoreList) toTarget:self withObject:nil];
    
    manager=[[CLLocationManager alloc]init];
    geocoder=[[CLGeocoder alloc]init];
    
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Method used to clear the cache memory whenever app receives memory warning
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=@"ADD PRODUCT";
    
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.locationManager.delegate = nil;
}
#pragma  mark - end

#pragma mark - getStoreList API

//Fetching store names
-(void)addProductStoreList
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else{
        
        NSDictionary *requestDict = NULL;
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"getStoreList"];
        // NSLog(@"totalBodyData is %@",jsonDictionary);
        [myDelegate StopIndicator];
        if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 1)
        {
            
            storearray=[[NSMutableArray alloc]init];
            NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
            NSArray *arr=[tempDict objectForKey:@"storeList"];
            for (int i=0; i<[arr count]; i++) {
                data = [[DataHolderClass alloc]init];
                
                NSDictionary *b=arr[i];
                data.store_id=[b objectForKey:@"storeId"];
                data.store_location=[b objectForKey:@"storeLocation"];
                data.store_name=[b objectForKey:@"storeName"];
                [storearray addObject:data];
            }
            [storearray addObject:@"Other"];
            [myPickerView reloadAllComponents];
        }
        
    }
    [internet release];
}
#pragma mark - end


#pragma mark - Padding to Measure Textfield
- (void) modifyTextField:(UITextField *)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [paddingView release];
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
    
    //Setting picker values for pre added store names or adding other stores
    
    if (keyboardControls.activeField==_measure) {
        if (!nowMeasure) {
            _measure.text = [pickerArrayMeasure objectAtIndex:0] ;
            
        }
        else
            _measure.text = globe_measure;
        
        [_measure resignFirstResponder];
        
    }
    
    if (keyboardControls.activeField==_other) {
        if (!nowOther)
        {
            data = [[DataHolderClass alloc]init];
            
            if([storearray count]==1)
            {
                _other.text=[storearray objectAtIndex:0];
            }
            else
            {
                data = [storearray objectAtIndex:0];
            _other.text=data.store_name;
            }
            _location.text=data.store_location;
            storeID=[data.store_id intValue];
            
        }
        else
        {
            _other.text = globe_other;
            _location.text=globe_location;
            [_other resignFirstResponder];
        }
        
        //Reframing the textfields for store name and location in case of other
        if ([_other.text isEqualToString:@"Other"])
        {
            self.scrollView.scrollEnabled=TRUE;
            _storeName.hidden=NO;
            _storenameImgView.hidden=NO;
            _storenamePNG.hidden=NO;
            
            self.location.text=@"";
            self.location.enabled=YES;
            
            self.storeName.frame=CGRectMake(12, 256, 297, 40);
            self.storenameImgView.frame=CGRectMake(12, 256, 297, 40);
            self.storenamePNG.frame=CGRectMake(18, 265, 21, 21);
            
            self.location.frame=CGRectMake(12, 295, 297, 40);
            self.locationImgView.frame=CGRectMake(12, 295, 297, 40);
            self.locationPNG.frame=CGRectMake(18, 303, 21, 21);
            
            
            self.price.frame=CGRectMake(12, 332, 297, 40);
            self.priceImgView.frame=CGRectMake(12, 332, 297, 40);
            self.pricePNG.frame=CGRectMake(18, 340, 21, 21);
            
            self.weight.frame=CGRectMake(12, 375, 162, 40);
            self.weightImgView.frame=CGRectMake(12, 375, 162, 40);
            self.weightPNG.frame=CGRectMake(18, 382, 21, 21);
            
            
            self.measure.frame=CGRectMake(188, 375, 121, 40);
            
            self.submitOutlet.frame=CGRectMake(12, 432, 297, 40);
            //set bskeyboardcontrols fields
            self.keyboardControls.fields=@[_productName,_barCode,_other,_storeName,_location,_price,_weight,_measure];
        }
        else
        {
            
            self.scrollView.scrollEnabled=TRUE;
            _storeName.hidden=YES;
            _storenameImgView.hidden=YES;
            _storenamePNG.hidden=YES;
            
            self.location.enabled=NO;
            _location.hidden=NO;
            _locationImgView.hidden=NO;
            _locationPNG.hidden=NO;
            
            self.location.frame=CGRectMake(12, 256, 297, 40);
            self.locationImgView.frame=CGRectMake(12, 256, 297, 40);
            self.locationPNG.frame=CGRectMake(18, 265, 21, 21);
            
            self.price.frame=CGRectMake(12, 295, 297, 40);
            self.priceImgView.frame=CGRectMake(12, 295, 297, 40);
            self.pricePNG.frame=CGRectMake(18, 303, 21, 21);
            
            self.weight.frame=CGRectMake(12, 338, 162, 40);
            self.weightImgView.frame=CGRectMake(12, 338, 162, 40);
            self.weightPNG.frame=CGRectMake(18, 345, 21, 21);
            
            self.measure.frame=CGRectMake(188, 338, 121, 40);
            
            self.submitOutlet.frame=CGRectMake(12, 395, 297, 40);
            
            //set bskeyboardcontrols fields
            self.keyboardControls.fields=@[_productName,_barCode,_other,_price,_weight,_measure];
        }
        
    }
}
#pragma mark - end


#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _other) {
        txtFieldSelected = @"other";
    }else if (textField == _measure) {
        txtFieldSelected = @"measure";
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y- (2.5 * textField.frame.size.height)) animated:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - end


#pragma mark - Picker View
//Setting store names in picker
-(void)addPickerViewOther
{
    nowOther=0;
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    _other.inputView = myPickerView;
    
}
//Setting weight measurements
-(void)addPickerViewMeasure
{
    nowMeasure=0;
    
    pickerArrayMeasure = [[NSArray alloc]initWithObjects:@"Kg",
                          @"gm",@"mg",@"Lt",@"ml", nil];
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    _measure.inputView = myPickerView;
    
}

//Picker view delegates
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([txtFieldSelected  isEqual: @"other"]) {
        return storearray.count;
    }else if ([txtFieldSelected  isEqual: @"measure"]) {
        return pickerArrayMeasure.count;
    }
    return 1;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([txtFieldSelected  isEqual: @"measure"]) {
        
        nowMeasure=1;
        globe_measure =[pickerArrayMeasure objectAtIndex:row];
    }else if ([txtFieldSelected  isEqual: @"other"]) {
        
        nowOther=1;
        if (row==storearray.count-1) {
            globe_other=[storearray objectAtIndex:row];
        }
        else{
            data = [[DataHolderClass alloc]init];
            data=[storearray objectAtIndex:row];
            globe_other=data.store_name;
            globe_location=data.store_location;
            storeID=[data.store_id intValue];
        }
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([txtFieldSelected  isEqual: @"other"]) {
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
    else if ([txtFieldSelected  isEqual: @"measure"])
    {
        return [pickerArrayMeasure objectAtIndex:row];
    }
    return (@"Good");
    
}
#pragma mark - end

#pragma mark - Gallery Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //Picking image from image gallery or capturing from device
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    if (sourceType==1)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else if (sourceType==0)
    {
        image = info[UIImagePickerControllerEditedImage];
    }
    
    self.addPhoto.image = image;
}

-(void)saveImage :(UIImage *)Pickerimage
{
    
    self.addPhoto.image = Pickerimage;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - end



#pragma mark - Actionsheet

//Setting product image using camera or gallery
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1)
    {
        //Ading product image from gallery
        sourceType = 1;
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex==0)
    {
        
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            [myAlertView release];
            
        }
        else
        {
            //Capturing product image from camera
            sourceType = 0;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
        
    }
    
}
#pragma mark - end


#pragma mark - Button Actions
//Back action
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Action for adding new product
- (IBAction)submitBtn:(id)sender
{
    [self.view endEditing:YES];
    //Alert if the textfileds are not filled
    if(self.productName.text.length==0)
    {
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the product name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        [wrongfield release];
        return;
    }
    else if(self.other.text.length==0)
    {
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        [wrongfield release];
        return;
    }
    else if([self.other.text isEqual:@"Other"])
    {
        if(self.storeName.text.length==0)
        {
            
            UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [wrongfield show];
            [wrongfield release];
            
            return;
        }
        else if(self.location.text.length==0)
        {
            UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the store location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [wrongfield show];
            [wrongfield release];
            
            return;
        }
    }
    
    else if(self.price.text.length==0){
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the product price." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        [wrongfield release];
        return;
    }
    else if(self.weight.text.length==0){
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the product weight." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        [wrongfield release];
        return;
    }
    else if(self.measure.text.length==0){
        
        UIAlertView *wrongfield=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter the product unit." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [wrongfield show];
        [wrongfield release];
        return;
    }
    
    [myDelegate ShowIndicator];
    
    
    if ([self.other.text isEqualToString:@"Other"])
    {
        if(!forwardGeocoder){
            forwardGeocoder = [[MJGeocoder alloc] init];
            forwardGeocoder.delegate = self;
        }
        
        //show network indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *string=[NSString stringWithFormat:@"%@",_location.text];
        
        [forwardGeocoder findLocationsWithAddress:string title:nil];
    }
    else
    {
        //Method for adding new product at server which is called in seperate thread
        [NSThread detachNewThreadSelector:@selector(addProduct) toTarget:self withObject:nil];
    }
    
}

//Action for adding photo
- (IBAction)addPhotoAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
    
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
    [actionSheet release];
    
}
#pragma mark - end


#pragma mark - addProduct API

//Rescaling image to avoid memory pressure
-(UIImage *)imageWithImage:(UIImage *)image1 scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image1 drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//Adding new product web service call
-(void)addProduct
{
    NSString *strEncoded;
    if (self.addPhoto.image==[UIImage imageNamed:@"add_photo.png"])
    {
        strEncoded = @"";
    }
    else
    {
        //Rescaling image to avoid memory presure
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.01f;
        int maxFileSize = 200*200;
        
        NSData *imageData = UIImageJPEGRepresentation(image, compression);
        
        while ([imageData length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(image, compression);
        }
        scaledImage=[UIImage imageWithData:imageData];
        CGSize scale;
        scale.height=200;
        scale.width=200;
        scaledImage = [self imageWithImage:scaledImage scaledToSize:scale];
        imageData = UIImageJPEGRepresentation(scaledImage, 0.01);
        strEncoded = [Base64 encode:imageData];
    }
    //Json request
    NSDictionary *requestDict;
    if ([_other.text isEqualToString:@"Other"])
    {
        requestDict = @{@"product_image":strEncoded,@"user_id":myDelegate.userId,@"product_name":self.productName.text,@"product_barcode":self.barCode.text,@"store_id":[NSNumber numberWithInt:-1],@"price":[NSNumber numberWithDouble:[self.price.text doubleValue]],@"weight":[NSNumber numberWithDouble:[self.weight.text doubleValue]],@"unit":self.measure.text,@"store_name":self.storeName.text,@"store_location":self.location.text,@"store_latitude":[NSNumber numberWithDouble:latitude],@"store_longitude":[NSNumber numberWithDouble:longitude]};
    }
    else
    {
        requestDict = @{@"product_image":strEncoded,@"user_id":myDelegate.userId,@"product_name":self.productName.text,@"product_barcode":self.barCode.text,@"store_id":[NSNumber numberWithInt:storeID],@"price":[NSNumber numberWithDouble:[self.price.text doubleValue]],@"weight":[NSNumber numberWithDouble:[self.weight.text doubleValue]],@"unit":self.measure.text};
    }
    jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"addProduct"];
    
    NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary]];
    
    NSLog(@"totalBodyData is %@",tempDict);
    
    [myDelegate StopIndicator];
    
    
    if ([[tempDict valueForKey:@"isSuccess"] intValue] == 1)
    {
        _productName.text=@"";
        _other.text=@"";
        _measure.text=@"";
        _price.text=@"";
        _storeName.text=@"";
        _weight.text=@"";
        _location.text=@"";
        _addPhoto.image=[UIImage imageNamed:@"add_photo.png"];
       
        //Moving to product detail screen after successfully adding product
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProdcutDetailViewController *objProductDetail =[storyboard instantiateViewControllerWithIdentifier:@"ProdcutDetailViewController"];
        objProductDetail.productId=[jsonDictionary objectForKey:@"productId"];
        [self.navigationController pushViewController:objProductDetail animated:YES];
        
        
    }
    else if ([[tempDict valueForKey:@"isSuccess"] intValue]==0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[tempDict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

    }
    else if ([[tempDict valueForKey:@"isSuccess"] intValue]==2)
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
    alert.tag=003;
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
#pragma mark - alertview delegate method
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alert.tag==003)
    {
        [self performSelector:@selector(logout) withObject:nil afterDelay:.1];
    }
}

#pragma mark - end

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	//show network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	
}
#pragma mark - end


#pragma mark - MJGeocoderDelegate
//Getting the location of store added
- (void)geocoder:(MJGeocoder *)geocoder didFindLocations:(NSArray *)locations{
	//hide network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    
    [displayedResults release];
    displayedResults = [locations retain];
    Address *address = [displayedResults objectAtIndex:0];
    
    latitude=[address.latitude doubleValue];
    longitude=[address.longitude doubleValue];
    // NSLog(@"%@ ,%@",address.latitude,address.longitude);
    
    [self performSelector:@selector(addProduct) withObject:nil afterDelay:.1];
}
//Error message displayed when user enters invalid location
- (void)geocoder:(MJGeocoder *)geocoder didFailWithError:(NSError *)error
{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [myDelegate StopIndicator];
//    
//    if([error code] == 1)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have entered an invalid location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	latitude=0.0;
    longitude=0.0;
    [self performSelector:@selector(addProduct) withObject:nil afterDelay:.1];
}
#pragma mark - end

@end
