//
//  RedeemViewController.h
//  PriceTag
//
//  Created by Ranosys on 08/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//


@interface RedeemViewController : UIViewController<UITextFieldDelegate,BSKeyboardControlsDelegate>

- (IBAction)backButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *BankName;
@property (weak, nonatomic) IBOutlet UITextField *BankDetails;
- (IBAction)submit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
