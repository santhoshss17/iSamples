//
//  MCAppDelegate.h
//  SSToken
//
//  Created by iSamples on 9/6/13.
//  Copyright (c) 2013 SS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSToken.h"

@interface MCAppDelegate : NSObject <NSApplicationDelegate,SSTokenDelegate>

@property (assign) IBOutlet NSWindow *window;
@property(nonatomic,retain) NSMutableArray *contents;
- (IBAction)removeAll:(id)sender;

@end
