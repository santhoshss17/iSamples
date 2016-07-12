//
//  SSShareController.m
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import "SSShareController.h"
#import <Social/Social.h>

@implementation SSShareController

- (void)viewDidLoad
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"Petal Data"
                                                          ofType: @"plist"];
    // Build the array from the plist
    self.selectorData = [[NSArray alloc] initWithContentsOfFile:plistPath];
	// Configure the Expander Select and add to view controllers view.
    self.sharingView = [[KLExpandingSelect alloc] initWithDelegate: self
                                                        dataSource: self];
    [self.view setExpandingSelect:self.sharingView];
    [self.view addSubview: self.sharingView];
}

#pragma mark - KLExpandingSelectDataSource Methods

- (NSInteger)expandingSelector:(id) expandingSelect numberOfRowsInSection:(NSInteger)section
{
    return [self.selectorData count];
}

- (KLExpandingPetal *)expandingSelector:(id) expandingSelect itemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dictForPetal = [self.selectorData objectAtIndex:indexPath.row];
    NSString* imageName = [dictForPetal objectForKey:@"image"];
    KLExpandingPetal* petal = [[KLExpandingPetal alloc] initWithImage:[UIImage imageNamed:imageName]];
    return petal;
}

#pragma mark - KLExpandingSelectDelegate Methods

- (void)expandingSelector:(id)expandingSelect didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSShare *shareData = nil;

    if([self.delegate respondsToSelector:@selector(shareDataForShareType:)])
        shareData = [self.delegate shareDataForShareType:indexPath.row];

    switch (indexPath.row)
    {
        case eDropBoxShare:
            
            break;
                        
        case eMail:
        {
            if(nil != shareData)
            {
                MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc] init];
                [mailViewController setMailComposeDelegate:self];
                [mailViewController setToRecipients:((SSMailShare *)shareData).recipients];
                [mailViewController setSubject:(nil != ((SSMailShare *)shareData).subject)?((SSMailShare *)shareData).subject:((SSMailShare *)shareData).title];
                [mailViewController setMessageBody:((SSMailShare *)shareData).body
                                            isHTML:NO];
                NSData *imageAttachment = UIImageJPEGRepresentation(shareData.attachment,1);
                [mailViewController addAttachmentData: imageAttachment
                                             mimeType:@"image/png"
                                             fileName:@"petal-email.png"];
                [self presentViewController: mailViewController
                                   animated: YES
                                 completion: nil];
            }
        }
            break;
            
        case eTwitterShare:
        case eFacebookShare:
        {
            SSShare *share = nil;
            if([self.delegate respondsToSelector:@selector(shareDataForShareType:)])
                share = [self.delegate shareDataForShareType:indexPath.row];

            SLComposeViewController *shareViewController = [SLComposeViewController composeViewControllerForServiceType:(indexPath.row == eFacebookShare)?SLServiceTypeFacebook:SLServiceTypeTwitter];
            
            [shareViewController addURL:[NSURL URLWithString:shareData.link]];
            [shareViewController setInitialText:shareData.title];
            [shareViewController addImage:shareData.attachment];
            
            if ([SLComposeViewController isAvailableForServiceType:shareViewController.serviceType]) {
                [self presentViewController:shareViewController
                                   animated:YES
                                 completion: nil];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - MFMailComposerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];

    if([self.delegate respondsToSelector:@selector(mailSent)])
        [self.delegate mailSent];
}

#pragma mark - 

@end
