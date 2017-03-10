//
//  HomeViewController.h
//  PriceTag
//
//  Created by Ranosys on 07/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

@class myButton;
@interface HomeViewController : UIViewController
{
    __weak IBOutlet UIView *topVIew;
    __weak IBOutlet UIView *dropDownView;
    __weak IBOutlet UIView *coloredView;
    __weak IBOutlet UINavigationItem *item;
    UIView * footerView;
    
}
@property (weak, nonatomic) IBOutlet UIView *PriceClosedView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *days;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UILabel *minutes;
@property (weak, nonatomic) IBOutlet UILabel *seconds;
@property (weak, nonatomic) IBOutlet UIView *myPositionView;


@property (weak, nonatomic) IBOutlet UILabel *NextDay;
@property (weak, nonatomic) IBOutlet UILabel *NextHours;
@property (weak, nonatomic) IBOutlet UILabel *NextMinutes;
@property (weak, nonatomic) IBOutlet UILabel *NextSeconds;

- (IBAction)myPositionAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;

@property(nonatomic,retain)NSMutableArray * data_array;
@property (nonatomic) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIView *PaginationView;
@property (strong, nonatomic) NSString *todayDate;
@property (strong, nonatomic) NSString *endingDate;
@property (strong, nonatomic) NSString *nextStartingDate;

@property (weak, nonatomic) IBOutlet UILabel *noRecord;

@property (weak, nonatomic) IBOutlet UILabel *behindUserLbl;
@property (weak, nonatomic) IBOutlet UILabel *UserPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *leadingUserLabel;

//Timer Label outlets
@property (weak, nonatomic) IBOutlet UILabel *dayTimer;
@property (weak, nonatomic) IBOutlet UILabel *hourTimer;
@property (weak, nonatomic) IBOutlet UILabel *minTimer;
@property (weak, nonatomic) IBOutlet UILabel *secondTimer;
@property(assign,nonatomic) int Product_ID;

@property (weak, nonatomic) IBOutlet UITableView *dropDownTable;

@end
