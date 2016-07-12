//
//  MessageNotifyManager.h
//  SS Growl
//
//  Created by iSamples on 11/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNotificationWindowConstants.h"

@interface SSMessageNotificationManager : NSObject {
@private
    
    EBTCNotificationType notificationType_;
    NSMutableArray *notificationControllersArray_;
}
@property(nonatomic,assign)EBTCNotificationType notificationType;

+(SSMessageNotificationManager *)sharedMessageNotifyManager;

//Invoke this API to display the title and sub title text in the notifier window.
-(void)displayNotifierWithTitleText:(NSString *)titleText subTitle:(NSString *)subTitle;

@end
