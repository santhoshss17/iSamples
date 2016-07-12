//
//  SSRadioItem.m
//  iRadioButton
//
//  Created by SSRadioButton on 07/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SSRadioItem.h"

@implementation SSRadioItem
@synthesize title = title_;
@synthesize selected = selected_;
@synthesize isOthersRadioItem = isOthersRadioItem_;

- (id)init {
    self = [super init];
    if (self) 
    {
        selected_ = NO;
    }
    return self;
}

- (void)dealloc 
{
    self.title = nil;
    [super dealloc];
}

-(void)resetSelection
{
    [self setSelected:NO];
}

@end