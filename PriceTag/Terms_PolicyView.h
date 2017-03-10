//
//  Terms_PolicyView.h
//  PriceTag
//
//  Created by Ranosys on 12/09/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Terms_PolicyView : UIViewController<UIWebViewDelegate>

- (IBAction)moveBack:(id)sender;

@property(nonatomic,assign) int buttonTag;
@property(nonatomic,retain) NSString *TermsPolicy;
@property (weak, nonatomic) IBOutlet UIWebView *termsPrivacyWebView;
@end
