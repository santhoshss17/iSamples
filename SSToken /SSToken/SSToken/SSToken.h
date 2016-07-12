//
//  SSToken.h
//  SSToken
//
//  Created by iSamples on 9/6/13.
//  Copyright (c) 2013 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSTokenItem <NSObject>

-(NSString *)tokenName;

@end

@protocol SSTokenDelegate <NSObject>

@optional
-(void)SSTokenFrameDidChanged:(NSRect)newRect;
-(BOOL)canRemoveSSToken:(id<SSTokenItem>)token;
-(void)SSTokenSelected:(id<SSTokenItem>)token;
-(void)didRemoveSSToken:(id<SSTokenItem>)token;

@end

typedef enum
{
    eDefaultScroll = 0,
    eHorizontalScrollOnly = 1>>0,
    eVericalScrollOnly = 2>>0
    
}SSTokenScrollType;

@interface SSToken : NSObject

@property(nonatomic,assign)id<SSTokenDelegate> delegate;

@property(nonatomic,assign)float tokenOffsetX;
@property(nonatomic,assign)float tokenOffsetY;

@property(nonatomic,assign)int tokenGap;// Token-Token Gap

@property(nonatomic,assign)SSTokenScrollType scrollType;
@property(nonatomic,retain)NSColor *tokenColor;

-(NSView *)contentView;
-(NSArray *)addedTokens;
-(void)removeAllTokens;

-(id)initWithFrame:(NSRect)frame;
-(void)setFrame:(NSRect)frameRect;

-(void)setTokens:(NSArray *)tokens; //All objects to be of type SSTokenItem
-(void)addToken:(id<SSTokenItem>)tokenItem;
-(void)removeToken:(id<SSTokenItem>)tokenItem;

@end
