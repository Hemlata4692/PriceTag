//
//  ViewController.m
//  PriceTag
//
//  Created by Sumit on 05/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "TutorialViewController.h"
#import "LoginController.h"


@interface TutorialViewController ()


@end

@implementation TutorialViewController
@synthesize tutorialView1;
@synthesize tutorialView2;
@synthesize tutorialView3;
@synthesize viewsArray;
@synthesize tabbarcontroller;


#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    viewsArray = [[NSArray alloc]initWithObjects:tutorialView1,tutorialView2,tutorialView3, nil];
    pageControl.numberOfPages = [viewsArray count];
    counter = 0;
    pageControl.currentPage = counter;
   //Swipe gesture to swipe images to left
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    
    //Swipe gesture to swipe images to right

    mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    
    [mSwipeUpRecognizer setDirection:( UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    skip_btn.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end


#pragma mark - Swipe Gesture
//Swipe left action to swipe images to left
-(void)swipeLeft
{
       if (counter<[viewsArray count]-1)
    {
        UIView *GallaryView;
        counter++;
        skip_btn.hidden = YES;
        switch (counter)
        {
            case 0:
                GallaryView = tutorialView1;
                tutorialView1.hidden = NO;
                tutorialView2.hidden =YES;
                tutorialView3.hidden =YES;
                break;
            case 1:
                GallaryView = tutorialView2;
                tutorialView1.hidden = YES;
                tutorialView2.hidden =NO;
                tutorialView3.hidden =YES;
                break;
            case 2:
                GallaryView = tutorialView3;
                tutorialView1.hidden = YES;
                tutorialView2.hidden =YES;
                tutorialView3.hidden =NO;
                skip_btn.hidden = NO;
                break;
                
            default:
                break;
        }
        
        
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.50;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromRight;
        transition.delegate = self;
        [containerView.layer addAnimation:transition forKey:nil];
        pageControl.currentPage = counter;
    }
}

//Swipe right action to swipe images to right
-(void)swipeRight
{
       if (counter>0)
    {
        skip_btn.hidden = YES;
        counter--;
        UIView *GallaryView;
        switch (counter)
        {
            case 0:
                GallaryView = tutorialView1;
                tutorialView1.hidden = NO;
                tutorialView2.hidden =YES;
                tutorialView3.hidden =YES;
                break;
            case 1:
                GallaryView = tutorialView2;
                tutorialView1.hidden = YES;
                tutorialView2.hidden =NO;
                tutorialView3.hidden =YES;
                break;
            case 2:
                GallaryView = tutorialView3;
                tutorialView1.hidden = YES;
                tutorialView2.hidden =YES;
                tutorialView3.hidden =NO;
                break;
                
            default:
                break;
        }
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.50;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        transition.delegate = self;
        [containerView.layer addAnimation:transition forKey:nil];
        pageControl.currentPage = counter;
        
    }
    
}
#pragma mark - end

#pragma mark - Button Action
//Action to skip tutorial screen
- (IBAction)skipAction:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"login key is %@",[defaults objectForKey:@"IsUserLogin"]);
    if([[defaults objectForKey:@"IsUserLogin"] isEqualToString:@""] || [[defaults objectForKey:@"IsUserLogin"] isEqualToString:@"(null)"] ||[defaults objectForKey:@"IsUserLogin"] ==NULL )
    {
    [defaults setBool:YES forKey:@"rootView"];
    [defaults synchronize];
    
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
  
    LoginController *loginView=[sb instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController setViewControllers: [NSArray arrayWithObject: loginView]
                                         animated: YES];
    [self.navigationController pushViewController:loginView animated:YES];
    }
    else
    {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        tabbarcontroller=[sb instantiateViewControllerWithIdentifier:@"UITabBarController"];
        [self.navigationController pushViewController:tabbarcontroller animated:YES];
    
    
    }
    
}
#pragma mark - end

@end



