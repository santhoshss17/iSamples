//
//  MCAppDelegate.m
//  SSToken
//
//  Created by iSamples on 9/6/13.
//  Copyright (c) 2013 SS. All rights reserved.
//

#import "MCAppDelegate.h"
#import "SSToken.h"
#import "SSTokenObject.h"
#import <Quartz/Quartz.h>

@interface MCAppDelegate()

@property(nonatomic,strong)SSToken *token;

@end

@implementation MCAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib
{
    [self prepareModel];
    
    SSToken *token = [[SSToken alloc] initWithFrame:CGRectMake(20, 320, 400, 24)];
    self.token = token;
    token.delegate = self;
    [token setTokens:self.contents];
    [[self.window contentView] addSubview:token.contentView];
        
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addToken:) userInfo:nil repeats:YES];
}

-(void)prepareModel
{
    NSArray *arr = @[@"I Love",@"My",@"Country",@"India",@"Happy",@"Coding"];
    self.contents = [NSMutableArray array];
    for (NSString *str in arr)
    {
        SSTokenObject *obj = [[SSTokenObject alloc] init];
        obj.title = str;
        [self.contents addObject:obj];
        [obj release];
    }
}

-(void)addToken:(NSTimer *)timer
{
    SSTokenObject *obj = [[SSTokenObject alloc] init];
    obj.title = [NSString stringWithFormat:@"Token-%d",arc4random_uniform(33)];
    [self.contents addObject:obj];
    [obj release];

    [self.token addToken:obj];    
}

- (IBAction)removeAll:(id)sender
{
    [self.token removeAllTokens];
}

#pragma mark - SSTokenDelegate Methods

-(BOOL)canRemoveSSToken:(id<SSTokenItem>)token
{
    return YES;
}

-(void)SSTokenFrameDidChanged:(NSRect)frame
{
    //Resize superviews here if needed.
}

@end
