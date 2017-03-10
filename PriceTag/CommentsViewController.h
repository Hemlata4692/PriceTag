//
//  CommentsViewController.h
//  PriceTag
//
//  Created by Sumit on 11/08/14.
//  Copyright (c) 2014 Sumit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class commentsCellTableViewCell;
@class ActivityCell;
@interface CommentsViewController : UIViewController
{
    
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIButton *activityBtn;
    __weak IBOutlet UIButton *timerBtn;
    __weak IBOutlet UIButton *commentsBtn;
    
    
    __weak IBOutlet UILabel *days_lbl;
    __weak IBOutlet UILabel *hours_lbl;
    __weak IBOutlet UILabel *minutes_lbl;
    __weak IBOutlet UILabel *seconds_lbl;
    __weak IBOutlet UIView *timer_view;
    
}
@property(nonatomic,assign)int screenCounter;
@property (strong, nonatomic) IBOutlet commentsCellTableViewCell *commentsCell;
@property (strong, nonatomic) IBOutlet ActivityCell *activityCell;
@property (weak, nonatomic) IBOutlet UILabel *noRecord;
@property(nonatomic,retain)NSString * todayDate;
@property(nonatomic,retain)NSString * endingDate;
@property(nonatomic,retain)NSTimer * timer;
@property(nonatomic,assign)int secondsLeft;
@property(nonatomic,assign)int day;
@property(nonatomic,assign)int hour;
@property(nonatomic,assign)int minute;
@property(nonatomic,assign)int second;
@property (weak, nonatomic) IBOutlet UILabel *savings;
@property (weak, nonatomic) IBOutlet UILabel *savingPercentage;
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@end


