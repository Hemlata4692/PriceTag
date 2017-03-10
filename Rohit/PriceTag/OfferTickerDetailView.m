//
//  OfferTickerDetailView.m
//  PriceTag
//
//  Created by Ranosys on 13/08/14.
//  Copyright (c) 2014 Ranosys. All rights reserved.
//

#import "OfferTickerDetailView.h"
#import "UIImageView+WebCache.m"

@interface OfferTickerDetailView ()

@end

@implementation OfferTickerDetailView
@synthesize offerTickerImage,offerName;

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
    //Fetching image from given url
    NSURL * url = [NSURL URLWithString:offerTickerImage];
    [self.imageIndicator startAnimating];
    [_offerImage sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if (_offerImage.image==nil)
        {
            _shareBtn.enabled=NO;
        }
        else
        {
            _shareBtn.enabled=YES;
        }
        [self.imageIndicator stopAnimating];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title=offerName;
    
    self.navigationItem.leftBarButtonItem = nil;
    GlobalNavigationBackButton *global = [GlobalNavigationBackButton new];
    global.myVC = self;
    self.navigationItem.leftBarButtonItem = [GlobalNavigationBackButton customizeMyNavigationBar:self];
    
    //[self setTopbarTitle];
    
}

-(void)goBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    self.tabBarController.hidesBottomBarWhenPushed= NO;
    
    self.tabBarController.tabBar.hidden=NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - end



#pragma mark - Actionsheet
//Actions to share image
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0)
    {
        //Share image on facebook
        if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=6)
        {
            
            slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [slComposerSheet setInitialText:@"PriceTag"];
            [slComposerSheet addImage:_offerImage.image];
            [slComposerSheet addURL:[NSURL URLWithString:nil]];
            [self presentViewController:slComposerSheet animated:YES completion:nil];
            
            
            [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                NSString *output;
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        output = @"Action Cancelled";
                        break;
                    case SLComposeViewControllerResultDone:
                        output = @"Your Post has been shared successfully.";
                        break;
                    default:
                        break;
                }
                if (result != SLComposeViewControllerResultCancelled)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }];
            
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
        }
        
    }
    else if (buttonIndex==1)
    {
        
        //Share image on twitter
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"PriceTag"];
            [tweetSheet addImage:_offerImage.image];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
//    //Share image via email
//    else if (buttonIndex==2)
//    {
//        // Email Subject
//        NSString *emailTitle = @"PriceTag";
//        NSArray *toRecipents = [NSArray arrayWithObject:@""];
//        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//        mc.mailComposeDelegate = self;
//        [mc setSubject:emailTitle];
//        UIImage *image =_offerImage.image;
//        NSData *imageData = UIImagePNGRepresentation(image);
//        [mc addAttachmentData:imageData mimeType:@"image/png" fileName:@"image.png"];
//        [mc setToRecipients:toRecipents];
//        
//        // Present mail view controller on screen
//        [self presentViewController:mc animated:YES completion:NULL];
//    }
    //Share image using whatsapp
    else if (buttonIndex==2)
    {
        
        if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
            
            UIImage     * iconImage = _offerImage.image;
            NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
            
            [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
            _documentInteractionController.UTI = @"net.whatsapp.image";
            _documentInteractionController.delegate = self;
            
            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
            
            
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}
#pragma mark - end

//#pragma mark - Mail Composer
//
//- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    //Actions for composing the email
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            //  NSLog(@"Mail cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            // NSLog(@"Mail saved");
//            break;
//        case MFMailComposeResultSent:
//            // NSLog(@"Mail sent");
//            break;
//        case MFMailComposeResultFailed:
//            // NSLog(@"Mail sent failure: %@", [error localizedDescription]);
//            break;
//        default:
//            break;
//    }
//    
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//#pragma mark - end


#pragma mark - Social Sharing Button
//Action to share image
- (IBAction)actionsheetBtn:(id)sender
{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"Cancel"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"Facebook", @"Twitter",@"Email",@"Whatsapp", nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook", @"Twitter",@"Whatsapp", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
    
}
#pragma mark - end

#pragma mark - Button Action
//Navigating to the previous screen
- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
