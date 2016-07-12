//
//  SSShare.h
//  SSShare
//
//  Created by iSamples - isamples.wordpress.com on 04/12/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSShare : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *link;
@property (nonatomic,strong) id attachment; //Currently Pictures only.

@end
