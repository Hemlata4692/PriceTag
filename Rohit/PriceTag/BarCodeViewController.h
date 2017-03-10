//
//  BarCodeViewController.h
//  PriceTag
//
//  Created by Ranosys on 12/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "ZBarSDK.h"

@interface BarCodeViewController : UIViewController<UITextFieldDelegate,ZBarReaderDelegate,ZBarReaderViewDelegate>
{
    __weak IBOutlet UIView *tempView;
}
@property (nonatomic, strong) id <ZBarReaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *BarCodeImage;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

- (IBAction)EnterCode:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *EnterCodeTxt;
@property (weak, nonatomic) IBOutlet UILabel *ScanLbl;
- (IBAction)moveBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *enterCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomview1;
- (IBAction)matchCodeBtn:(id)sender;

@property(nonatomic,retain)NSMutableArray * dataArray;

@property (weak, nonatomic) IBOutlet UIView *ZbarBottomview;

@end
