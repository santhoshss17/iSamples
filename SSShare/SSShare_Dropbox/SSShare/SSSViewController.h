//
//  SSSViewController.h
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSShareController.h"

@interface SSSViewController : UIViewController<SSShareControllerDelegate>

@property(nonatomic,strong) SSShareController *shareController;

@end
