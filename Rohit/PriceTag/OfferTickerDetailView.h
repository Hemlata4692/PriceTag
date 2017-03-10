//
//  OfferTickerDetailView.h
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>


@interface OfferTickerDetailView : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate> {
    
    UIWebView *webview;
    SLComposeViewController *slComposerSheet;
}


- (IBAction)actionsheetBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) NSString  *offerTickerImage;
@property (weak, nonatomic) NSString  *offerName;
@property (retain, nonatomic) UIImageView  *imageShare;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;
@property (retain) UIDocumentInteractionController * documentInteractionController;

@end
