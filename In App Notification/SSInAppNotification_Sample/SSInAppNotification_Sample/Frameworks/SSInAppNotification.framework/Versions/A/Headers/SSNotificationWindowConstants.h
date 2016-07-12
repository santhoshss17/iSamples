//
//  SSNotificationWindowConstants.h
//  SS Growl
//
//  Created by iSamples 11/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define NOTIFICATION_WINDOW_WIDTH 329
#define NOTIFICATION_WINDOW_HEIGHT 96

extern const NSString *kNotificationWindowDidCloseNotification;

typedef enum
{
    eTopLeftNotification = 1, //Not Implemented Yet
    eTopRightNotification,
    eBottomLeftNotification,  //Not Implemented Yet
    eBottomRightNotification
    
}EBTCNotificationType;