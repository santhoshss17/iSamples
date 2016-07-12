//
//  SSSViewController.m
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com  on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import "SSSViewController.h"

@interface SSSViewController ()

@end

@implementation SSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self configureShareOptions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureShareOptions
{
    [SSShareController sharedShareController].delegate = self;
    [self.view addSubview:[SSShareController sharedShareController].view];
}

#pragma mark - SSShareControllerDelegate Methods

-(SSShare *)shareDataForShareType:(ESSShareType)type
{
    id shareData = nil;
    
    switch (type)
    {
        case eDropBoxShare:
            shareData = [[SSMailShare alloc] init];
            [shareData setTitle:@"iSamples SSShare"];
            [shareData setAttachment:[UIImage imageNamed:@"Attachment.png"]];
            break;
            
        case eMail:
        {
            shareData = [[SSMailShare alloc] init];
            [shareData setRecipients:@[@"iSamples@wordpress.com"]];
            [shareData setSubject:@"SSShare"];
            [shareData setBody:@"SShare made sharing simple"];
            [shareData setAttachment:[UIImage imageNamed:@"Attachment.png"]];
        }
            
        case eTwitterShare:
        case eFacebookShare:
        {
            shareData = [[SSShare alloc] init];
            [shareData setTitle:@"iSamples SSShare"];
            [shareData setLink:@"www.isamples.wordpress.com"];
            [shareData setAttachment:[UIImage imageNamed:@"Attachment.png"]];
        }
            break;
            
        default:
            break;
    }
    
    return shareData; //ARC enabled. No need to autorelease.
}

-(void)mailSent
{
    NSLog(@"Mail Sent Successfully");
}

-(NSString *)dropboxAppKey
{
    return @"wbwfx9cvakjhy8f"; //Don't forget to update URL types/URL Schemes in the info.plist
}

-(NSString *)dropboxSecretKey
{
    return @"kph244vi3fpwi0x";
}

@end
