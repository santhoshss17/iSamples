//
//  SSShareController.h
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLExpandingSelect.h"

#import <MessageUI/MessageUI.h>

#import "SSMailShare.h"

typedef enum
{
    eDropBoxShare,
    eTwitterShare,
    eMail,
    eFacebookShare
    
}ESSShareType;

@protocol SSShareControllerDelegate <NSObject>

@optional

-(void)mailSent;

-(SSShare *)shareDataForShareType:(ESSShareType)type;

@end

@interface SSShareController : UIViewController<KLExpandingSelectDelegate,KLExpandingSelectDataSource,
MFMailComposeViewControllerDelegate>

@property(nonatomic,strong)id<SSShareControllerDelegate> delegate;
@property(nonatomic,strong)KLExpandingSelect *sharingView;
@property(nonatomic,strong)NSArray *selectorData;

@end
