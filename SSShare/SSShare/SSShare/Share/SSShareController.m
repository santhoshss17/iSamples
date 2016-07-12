//
//  SSShareController.m
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com  on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import "SSShareController.h"
#import <Social/Social.h>

static SSShareController *sharedShareController;
@interface SSShareController()

@property (nonatomic,strong) DBRestClient *restClient;

@end

@implementation SSShareController

+(SSShareController *)sharedShareController
{
    if(nil == sharedShareController)
    {
        sharedShareController = [[SSShareController alloc] init];
    }
    
    return sharedShareController;
}

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

-(BOOL)handleOpenURL:(NSURL *)url
{
    BOOL handle = NO;
    if ([[DBSession sharedSession] handleOpenURL:url])
    {
		if ([[DBSession sharedSession] isLinked])
        {
            [self dropboxLinkedToApplication];
            handle = YES;
		}
	}
    return handle;
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
            
            [self addFileToDropbox:shareData.attachment];
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

#pragma mark - Dropbox Related Methods

-(void)addFileToDropbox:(UIImage *)dropbox
{
    [self linkDropboxAccount];
}

-(void)linkDropboxAccount
{
    NSString* appKey = [[self delegate] dropboxAppKey];
	NSString* appSecret = [[self delegate] dropboxSecretKey];
	NSString *root = kDBRootDropbox; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	// You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
	// from https://dropbox.com/developers/apps
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	NSString* errorMsg = nil;
	if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in Delegate Method -(NSString *)dropboxAppKey";
	} else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in -(NSString *)dropboxSecretKey";
	} else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	} else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist =
        [NSPropertyListSerialization
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in YourAPP-Info.plist";
		}
	}

    DBSession* session =
    [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    
    if (![[DBSession sharedSession] isLinked])
		[[DBSession sharedSession] linkFromController:self];
    else
        [self dropboxLinkedToApplication];
}

- (DBRestClient*)restClient
{
    if (_restClient == nil)
    {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

-(void)dropboxLinkedToApplication
{
    SSShare *shareData = nil;
    
    if([self.delegate respondsToSelector:@selector(shareDataForShareType:)])
        shareData = [self.delegate shareDataForShareType:eDropBoxShare];

    NSString *title = (nil == shareData.title)?@"FromSShare":shareData.title;
    
    NSString *path = NSTemporaryDirectory();
    path = [[path stringByAppendingPathComponent:title] stringByAppendingPathExtension:@"png"];
    NSData *fileData = UIImagePNGRepresentation(shareData.attachment);
    [fileData writeToFile:path atomically:YES];
    
    [[self restClient] uploadFile:[path lastPathComponent] toPath:@"/Photos" withParentRev:nil fromPath:path];
}

#pragma mark - DBRestClientDelegate Methods
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    if([self.delegate respondsToSelector:@selector(shareSucceededForType:)])
        [self.delegate shareSucceededForType:eDropBoxShare];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    if([self.delegate respondsToSelector:@selector(shareFailedForType:error:)])
        [self.delegate shareFailedForType:eDropBoxShare error:error];
}

#pragma mark - DBSessionDelegate Methods
- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    NSError *error = [NSError errorWithDomain:NSURLErrorKey code:kCFSOCKS4ErrorRequestFailed userInfo:nil];
    if([self.delegate respondsToSelector:@selector(shareFailedForType:error:)])
       [self.delegate shareFailedForType:eDropBoxShare error:error];
}

#pragma mark -

@end
