//
//  BTCMessageNotificationWindowController.h
//  SS Growl
//
//  Created by  iSamples on 11/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SSMessageNotificationWindowController : NSWindowController<NSAnimationDelegate> {
@private
    
    IBOutlet NSButton *notificationWindowMessageButton_;
    IBOutlet NSButton *notificationWindowCloseButton_;

    IBOutlet NSTextField *titleText_;
    IBOutlet NSTextField *subTitleText_;
    NSTrackingArea *profileNotificationWindowTrackingArea_;

    NSPoint notificationWindowOrigin_;
    NSTimer *notificationDisplayTimer_;
    
    BOOL canWindowClose_;
}
@property(nonatomic,assign)NSPoint notificationWindowOrigin;

-(IBAction)messageWindowClicked:(NSButton *)button;
-(IBAction)messageWindowCloseClicked:(NSButton *)button;

-(void)showNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end
