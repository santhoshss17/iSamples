//
//  SSMailShare.h
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com  on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSShare.h"

@interface SSMailShare : SSShare

@property (nonatomic,strong) NSArray *recipients;//Array of email address. nil if user wants it to enter.
@property (nonatomic,strong) NSString *subject;//if nil then [super title]
@property (nonatomic,strong) NSString *body;

@end
