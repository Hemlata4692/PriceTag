//
//  Terms_PolicyView.m
//  PriceTag
//
//  Created by Ranosys on 12/09/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "Terms_PolicyView.h"

@interface Terms_PolicyView ()

@end

@implementation Terms_PolicyView
@synthesize buttonTag,termsPrivacyWebView,TermsPolicy;

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
    //Displaying terms and privacy policy pages
    NSString *fullURL = TermsPolicy;
    [self.termsPrivacyWebView loadHTMLString:fullURL baseURL:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (buttonTag==1)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.title=@"TERMS OF USE";
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.title=@"PRIVACY POLICY";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action

- (IBAction)moveBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - end
@end
