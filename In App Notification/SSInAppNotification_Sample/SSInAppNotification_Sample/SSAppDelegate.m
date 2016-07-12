//
//  SSAppDelegate.m
//  SSInAppNotification_Sample
//
//  Created by iSamples on 2/24/12.
//  Copyright (c) 2012 CastleRockResearch. All rights reserved.
//

#import "SSAppDelegate.h"
#import <SSInAppNotification/SSMessageNotificationManager.h>

@implementation SSAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

-(IBAction)test:(id)sender
{
	[[SSMessageNotificationManager sharedMessageNotifyManager] displayNotifierWithTitleText:@"In App Notification" subTitle:@"My Notification"];
}

@end
