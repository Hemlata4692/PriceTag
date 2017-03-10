//
//  ViewController.h
//  PriceTag
//
//  Created by Sumit on 05/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

@interface TutorialViewController : UIViewController
{

    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIPageControl *pageControl;
    int counter;
    __weak IBOutlet UIButton *skip_btn;

}
- (IBAction)skipAction:(id)sender;

@property(nonatomic,retain)NSArray * viewsArray;
@property (weak, nonatomic) IBOutlet UIView *tutorialView1;
@property (weak, nonatomic) IBOutlet UIView *tutorialView2;
@property (weak, nonatomic) IBOutlet UIView *tutorialView3;
@property (strong, nonatomic) UITabBarController *tabbarcontroller;
@end
