//
//  BarCodeViewController.m
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "BarCodeViewController.h"
#import "ZBarReaderView.h"
#import "Base64.h"
#import "ProductNotAvailViewController.h"


@interface BarCodeViewController ()
{
    ZBarReaderView*reader;
    NSDictionary *jsonDictionary;
    NSString *tempBarCode;
    
}
@property (strong, nonatomic) IBOutlet UIView *barCodeView;
@property(nonatomic,retain) NSDictionary *jsonDictionary;
@property(nonatomic,retain)  NSString *tempBarCode;
@end


@implementation BarCodeViewController

@synthesize EnterCodeTxt,ScanLbl,barCodeView,BarCodeImage,enterCodeBtn,dataArray,jsonDictionary,tempBarCode;

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
    dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barcode_bg.png"]];
    self.ZbarBottomview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"barcode_bg.png"]];
    EnterCodeTxt.delegate=self;
    EnterCodeTxt.layer.cornerRadius=6;
    EnterCodeTxt.layer.masksToBounds=YES;
    EnterCodeTxt.layer.borderColor=[[UIColor grayColor]CGColor];
    BarCodeImage.hidden=YES;
    _bottomview1.hidden=YES;
    
    reader = [ZBarReaderView new];
    
    tempView.hidden=NO;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    ScanLbl.hidden=NO;
    BarCodeImage.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    
    _bottomview1.hidden=YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"SCAN BARCODE";
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.tabBarController.tabBar setHidden:YES];
    tempView.hidden=NO;
    
    //Adding scanner on view and framing the scanner view
    
    ZBarImageScanner * scanner;
    if(scanner==nil)
    {
        scanner= [ZBarImageScanner new];
    }
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    if ([GlobalMethod isIphone5])
    {
        reader.frame = CGRectMake(0, 10, 320, 560);
    }
    else
    {
        reader.frame = CGRectMake(0, 10, 320, 470);
    }
    
    reader = [reader initWithImageScanner:scanner];
    reader.torchMode = 0;
    reader.readerDelegate = self;
    reader.tracksSymbols = YES;
    [reader addSubview:tempView];
    [self.view addSubview:reader];
    reader.hidden=NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{[reader start];});
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    ScanLbl.hidden=NO;
    BarCodeImage.hidden=YES;
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.tabBarController.tabBar setHidden:NO];
    [EnterCodeTxt resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{[reader stop];});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - ZBAR Delegate
//Zbar delegate method to scan and produce related barcode and image of otem scanned
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    for(ZBarSymbol *sym in symbols)
    {
        
        EnterCodeTxt.text=sym.data;
        tempBarCode=sym.data;
        _bottomview1.hidden=NO;
        BarCodeImage.hidden=NO;
        BarCodeImage.frame = CGRectMake(0, 10, 320, 312);
        BarCodeImage.image=image;
        readerView.hidden=YES;
    }
    
    
}

#pragma mark - end
#pragma mark - Bar Code API Call
//Method for displaying scanned barcode list from server
-(void)callBarCodeWebservice:(NSString *)object
{
    //Internet check to check internet connection is connected or not
    Internet *internet=[[Internet alloc] init];
    if ([internet start])
    {
        [myDelegate StopIndicator];
    }
    else
    {
        
        NSDictionary *requestDict = @{@"userId":myDelegate.userId,@"barCode":object};
        
        
        jsonDictionary =[WebService generateJsonAndCallApi:requestDict methodName:@"scanBarCode"];
        
        
        //  NSLog(@"totalBodyData is %@",jsonDictionary);
        [self parseBarCodeData:jsonDictionary];
        [myDelegate StopIndicator];
        
    }
}


-(void)parseBarCodeData :(NSDictionary *)dataDict
{
    if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 1)
    {
        //Data parsing for scanned barcode product list
        [dataArray removeAllObjects];
        NSMutableDictionary * tempDict = [NullValueChecker checkDictionaryForNullValue:[NSMutableDictionary dictionaryWithDictionary:dataDict]];
        NSArray * barcodeArray = [tempDict objectForKey:@"barCodeDataList"];
        for (int i =0; i<barcodeArray.count; i++)
        {
            DataHolderClass * data = [[DataHolderClass alloc]init];
            
            NSDictionary * tempDict = [barcodeArray objectAtIndex:i];
            data.product_id=[tempDict objectForKey:@"productId"];
            data.productImg_url = [tempDict objectForKey:@"productImageUrl"];
            data.product_name = [tempDict objectForKey:@"productName"];
            data.product_barcode= [tempDict objectForKey:@"productBarCode"];
            data.product_weight=[tempDict objectForKey:@"productWeight"];
            data.product_unit=[tempDict objectForKey:@"productUnit"];
            [dataArray addObject:data];
        }
        [self nextStoryBoard];
    }
    else
    {
        if ([[jsonDictionary valueForKey:@"isSuccess"] intValue] == 0 && jsonDictionary !=NULL) {
            [self nextStoryBoard];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops!!! Something went wrong." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}

-(void)nextStoryBoard
{
    //Moving to scanned item list after scanning a product successfully
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProductNotAvailViewController *product=[sb instantiateViewControllerWithIdentifier:@"ProductNotAvailViewController"];
    product.ResultArray=[dataArray mutableCopy];
    product.myobj=self;
    product.BarCodeData=tempBarCode;
    [self.navigationController pushViewController:product animated:YES];
}

#pragma mark - end
#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y+210);
    [self.ScrollView setContentOffset:scrollPoint animated:YES];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.ScrollView setContentOffset:CGPointZero animated:YES];
    tempBarCode=EnterCodeTxt.text;
}
#pragma mark - end

#pragma mark - Button Action

// Action for entering bar code if not scanned
- (IBAction)EnterCode:(id)sender
{
    reader.hidden=YES;
    dispatch_async(dispatch_get_main_queue(), ^{[reader stop];});
    _bottomview1.hidden=NO;
    EnterCodeTxt.text=@"";
    ScanLbl.hidden=YES;
    BarCodeImage.hidden=NO;
    if ([GlobalMethod isIphone5])
    {
        BarCodeImage.frame = CGRectMake(0, 13, 320, 400);
        BarCodeImage.image=[UIImage imageNamed:@"barcodePlaceholder.png"];
    }
    else
    {
        BarCodeImage.frame = CGRectMake(0, 13, 320, 312);
        BarCodeImage.image=[UIImage imageNamed:@"barcodep2.png"];
        
    }
    _bottomview1.backgroundColor = [UIColor colorWithRed:(72.0/255.0) green:(72.0/255.0) blue:(72.0/255.0) alpha:0.6];
}

//Moving back to finder list
- (IBAction)moveBack:(id)sender
{
    UITabBarController * myTab = (UITabBarController *)self.tabBarController;
    [myTab setSelectedIndex:2];
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.5];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction
                                   functionWithName:kCAMediaTimingFunctionDefault]];
    [myTab.view.layer addAnimation:transition forKey:kCATransition];
    
}

//Action to call the bar code scan webservice
- (IBAction)matchCodeBtn:(id)sender
{
    [self.ScrollView setContentOffset:CGPointZero animated:YES];
    if ([EnterCodeTxt.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Please enter the barcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        
        [alert show];
        
    }
    else if ([EnterCodeTxt.text length] <6)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"The barcode length should be atleast 6 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        
        [alert show];
        
    }
    else
    {
        [myDelegate ShowIndicator];
        //Method for fetching all the products related to scanned barcode from server which is called in seperate thread
        [NSThread detachNewThreadSelector:@selector(callBarCodeWebservice:) toTarget:self withObject:EnterCodeTxt.text];
        
    }
    
    [EnterCodeTxt resignFirstResponder];
}
#pragma mark - end
@end
