//
//  SSToken.m
//  SSToken
//
//  Created by iSamples on 9/6/13.
//  Copyright (c) 2013 SS. All rights reserved.
//

#import "SSToken.h"
#import <Quartz/Quartz.h>

#define TOKEN_HEIGHT 17.0
#define TOKEN_CLOSE_BUTTON_WIDTH 10.0

@interface SSUtilities : NSObject

+ (NSImage *)returnBadgeWithString:(NSString *)inBadgeString usingLeftCap:(NSImage *)inLeftCap centerImage:(NSImage *)inCenterImage
                       andRightCap:(NSImage *)inRightCap
                    withAlphaValue: (CGFloat)inAlpha
                         fontColor:(NSColor *)color;
@end

@implementation SSUtilities

+ (NSImage *)returnBadgeWithString:(NSString *)inBadgeString usingLeftCap:(NSImage *)inLeftCap centerImage:(NSImage *)inCenterImage
                       andRightCap:(NSImage *)inRightCap
                    withAlphaValue: (CGFloat)inAlpha
                         fontColor:(NSColor *)color
{
	NSImage *resultBadgeImage = nil;
    
    NSImage *centerImage = inCenterImage;
    NSImage *leftCap = inLeftCap;
    NSImage *rightCap = inRightCap;
    
    // Create attributes for drawing the count/string.
    NSDictionary * attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:16], NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    NSSize badgeStringSize = [inBadgeString sizeWithAttributes:attributes];
    
    NSRect badgeCenterRect = NSMakeRect(0 ,0 , badgeStringSize.width, [centerImage size].height);
    
    // Scale the center image  so the  count/string will fit inside.
    [centerImage setScalesWhenResized:YES];
    [centerImage setSize:badgeCenterRect.size];
    
    [attributes release];
    //ResultBadgeSize will be sum of  leftcap's size, center image's size and right cap's size.
    NSSize resultBadgeImageSize = NSMakeSize(badgeCenterRect.size.width+[leftCap size].width+[rightCap size].width, badgeCenterRect.size.height);
    resultBadgeImage = [[NSImage alloc] initWithSize:resultBadgeImageSize];
    [resultBadgeImage lockFocus];
    [leftCap drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:inAlpha];
    [centerImage drawAtPoint:NSMakePoint([leftCap size].width, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:inAlpha];
    [rightCap drawAtPoint:NSMakePoint([centerImage size].width + [leftCap size].width-0.5, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:inAlpha];
    [resultBadgeImage unlockFocus];
    [resultBadgeImage autorelease];
    
	return resultBadgeImage;
}

@end

@class SSTokenItem;
@protocol SSTokenItemDelegate <NSObject>

-(void)tokenButtonClicked:(SSTokenItem *)tokenItem;
-(void)tokenCloseButtonClicked:(SSTokenItem *)tokenItem;

@end

@interface SSTokenItem : NSObject

@property(nonatomic,retain) NSImageView *tokenBGView;
@property(nonatomic,retain) NSButton *token;
@property(nonatomic,retain) NSButton *tokenCloseButton;
@property(nonatomic,retain) id<SSTokenItem> representedObject;
@property(nonatomic,assign) id<SSTokenItemDelegate> delegate;

- (id)initWithRepresentedObject:(id<SSTokenItem>)tokenItem delegate:(id<SSTokenItemDelegate>)delegate;
-(NSView *)view;

@end

@implementation SSTokenItem

- (id)initWithRepresentedObject:(id<SSTokenItem>)tokenItem delegate:(id<SSTokenItemDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self = [super init];
        if (self)
        {
            self.representedObject = tokenItem;
            self.delegate = delegate;
            NSImage *leftTokenImage = [NSImage imageNamed:@"left.png"];
            NSImage *rightTokenImage = [NSImage imageNamed:@"right.png"];
            
            NSImage *image = [SSUtilities returnBadgeWithString:[self.representedObject tokenName]
                                                   usingLeftCap:leftTokenImage
                                                    centerImage:[NSImage imageNamed:@"mid.png"]
                                                    andRightCap:rightTokenImage
                                                 withAlphaValue: 1.0
                                                      fontColor:[NSColor whiteColor]];
            
            NSSize tokenSize = [image size];
            
            self.token = [[[NSButton alloc] initWithFrame:NSMakeRect(leftTokenImage.size.width, 0, tokenSize.width-leftTokenImage.size.width-rightTokenImage.size.width, TOKEN_HEIGHT)] autorelease];
            [self.token setBordered:NO];
            [self.tokenCloseButton setButtonType:NSMomentaryChangeButton];
            [self.token setTitle:[self.representedObject tokenName]];
            [self.token setTarget:self];
            [self.token setAction:@selector(tokenButtonClicked:)];
            [self.token setButtonType:NSMomentaryChangeButton];
            
            self.tokenCloseButton = [[[NSButton alloc] initWithFrame:NSMakeRect(tokenSize.width - TOKEN_CLOSE_BUTTON_WIDTH - 4.0, 0, TOKEN_CLOSE_BUTTON_WIDTH, TOKEN_HEIGHT)] autorelease];
            
            [self.tokenCloseButton setBordered:NO];
            [self.tokenCloseButton setFont:[NSFont systemFontOfSize:8.0]];
            [self.tokenCloseButton setButtonType:NSMomentaryChangeButton];
            [self.tokenCloseButton setImage:[NSImage imageNamed:@"Token_close.png"]];
            [self.tokenCloseButton setTarget:self];
            [self.tokenCloseButton setAction:@selector(tokenCloseButtonClicked:)];
            [self.tokenCloseButton setTitle:@""];
            [self.tokenCloseButton setHidden:YES];
            
            [self setTokenColor:[NSColor blackColor]];
            
            self.tokenBGView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, tokenSize.width, TOKEN_HEIGHT)] autorelease];
            [self.tokenBGView setImageScaling:NSImageScaleNone];
            [self.tokenBGView setImage:image];
            
            [self.tokenBGView addSubview:self.tokenCloseButton];
            [self.tokenBGView addSubview:self.token];
            [[self.tokenBGView animator]setAlphaValue:0.8];
            
            [self addTokenTrackingArea];
        }
        return self;
    }
    return self;
}

- (void)addTokenTrackingArea
{
	if(nil != self.tokenBGView)
	{
		NSTrackingAreaOptions trackingOptions = NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp;
		
		NSTrackingArea *profileImageViewTrackingArea= [[NSTrackingArea alloc]
                                                       initWithRect: [self.tokenBGView bounds] // in our case track the entire view
                                                       options: trackingOptions
                                                       owner: self
                                                       userInfo: nil];
		[self.tokenBGView addTrackingArea: profileImageViewTrackingArea];
	}
}

-(void)setTokenColor:(NSColor *)color
{
    NSMutableAttributedString *colorTitle =
    [[NSMutableAttributedString alloc] initWithAttributedString:[self.token attributedTitle]];
    
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    
    [colorTitle addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:titleRange];
    
    [self.token setAttributedTitle:colorTitle];
    
    colorTitle =
    [[NSMutableAttributedString alloc] initWithAttributedString:[self.tokenCloseButton attributedTitle]];
    
    titleRange = NSMakeRange(0, [colorTitle length]);
    
    [colorTitle addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:titleRange];
    
    [self.tokenCloseButton setAttributedTitle:colorTitle];
}

-(NSView *)view
{
    return self.tokenBGView;
}

-(void)tokenButtonClicked:(NSButton *)button
{
    [self.delegate tokenButtonClicked:self];
}

-(void)tokenCloseButtonClicked:(NSButton *)button
{
    [self.delegate tokenCloseButtonClicked:self];
}

-(NSString *)description
{
    return [@{@"Token Name":[self.representedObject tokenName],@"Token Frame":NSStringFromRect(self.tokenBGView.frame)} description];
}

#pragma mark -
#pragma mark Mouse Responder Methods

- (void)mouseEntered:(NSEvent*)event
{
    [self.tokenCloseButton setHidden:NO];
    [[self.tokenBGView animator]setAlphaValue:1.0];
}

- (void)mouseExited:(NSEvent*)event
{
    [self.tokenCloseButton setHidden:YES];
    [[self.tokenBGView animator]setAlphaValue:0.8];
}

@end


#pragma mark - SSToken Interface

@interface SSToken()<SSTokenItemDelegate>

@property(nonatomic,retain)NSScrollView *tokenScrollView;
@property(nonatomic,retain)NSView *tokenHolderView;

@property(nonatomic,retain)NSMutableArray *contentTokens;
@property(nonatomic,assign)float minSSTokenHeight;
@property(nonatomic,retain)NSTextField *tokenTextField;

@end

@implementation SSToken

- (id)init
{
    return [self initWithFrame:NSMakeRect(0, 0, 300, 300)];
}

-(id)initWithFrame:(NSRect)frame
{
    self = [super init];
    if(self)
    {
        NSTextField *textfield = [[NSTextField alloc] initWithFrame:frame];
        [textfield setEditable:NO];
        [textfield setSelectable:NO];
        self.tokenTextField = textfield;
        
        CGRect contentRect = [self.tokenTextField bounds];
        self.tokenOffsetX = 5.0;
        self.tokenOffsetY = 5.0;
        self.tokenGap = 5.0;
        
        self.minSSTokenHeight = (contentRect.size.height < TOKEN_HEIGHT)?TOKEN_HEIGHT:contentRect.size.height;
        
        self.tokenScrollView  = [[[NSScrollView alloc] initWithFrame:contentRect] autorelease];
        [self.tokenScrollView setHasHorizontalScroller:NO];
        [self.tokenScrollView setHasVerticalScroller:NO];
        [self.tokenScrollView setDrawsBackground:NO];
        [self.tokenScrollView setBackgroundColor:[NSColor clearColor]];

        [self.tokenScrollView setAutoresizingMask:NSViewWidthSizable];
        self.tokenHolderView = [[[NSView alloc] init]  autorelease];

        [self.tokenScrollView setDocumentView:self.tokenHolderView];
        
        self.contentTokens = [NSMutableArray array];
        [textfield addSubview:self.tokenScrollView];
        [textfield release];
    }
    return self;
}

-(NSView *)contentView
{
    return self.tokenTextField;
}

-(void)removeAllTokens
{
    NSArray *allTokens = [NSArray arrayWithArray:self.contentTokens];
    for (SSTokenItem *tokenItem in allTokens)
    {
        [self removeToken:tokenItem.representedObject];
    }
}

-(NSArray *)addedTokens
{
    NSMutableArray *tokens = [NSMutableArray array];
    for (SSTokenItem *tokenItem in self.contentTokens)
    {
        [tokens addObject:tokenItem.representedObject];
    }
    
    return tokens;
}

-(void)setFrame:(NSRect)frame
{
    [self.tokenTextField setFrame:frame];
    [self.tokenScrollView setFrame:[self.tokenTextField bounds]];
    [self layoutSubviews];
}

-(void)setTokenTextColor:(NSColor *)color
{
    if(nil != color)
    {
        [self.contentTokens enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setTokenColor:color];
        }];
    }
}

//All objects to be of type SSTokenItem
-(void)setTokens:(NSArray *)tokens 
{    
    for (id<SSTokenItem>item in tokens)
    {
        [self addToken:item];
    }
}

-(void)addToken:(id<SSTokenItem>)item
{
    SSTokenItem *tokenItem = [[SSTokenItem alloc] initWithRepresentedObject:item delegate:self];
    [self.contentTokens addObject:tokenItem];
    [self.tokenHolderView addSubview:tokenItem.view];
    
    [self layoutSubviews];
}

-(void)removeToken:(id<SSTokenItem>)token
{
    BOOL canRemoveToken = YES;
    
    if([self.delegate respondsToSelector:@selector(canRemoveSSToken:)])
        canRemoveToken = [self.delegate canRemoveSSToken:token];
    
    if(canRemoveToken)
    {
        SSTokenItem *tokenItem = [self tokenItemFromToken:token];
        [tokenItem.view removeFromSuperview];
        [self.contentTokens removeObject:tokenItem];
        [self layoutSubviews];
    }
}

-(SSTokenItem *)tokenItemFromToken:(id<SSTokenItem>)token
{
    SSTokenItem *tokenItem = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"representedObject == %@",token];
    NSArray *filteredArray = [self.contentTokens filteredArrayUsingPredicate:predicate];
    if([filteredArray count])
        tokenItem = [filteredArray lastObject];
    
    return tokenItem;
}

-(void)layoutSubviews
{
    [self resizeDocumentView];
    
    float tokenOffsetX = 0;
    float tokenOffsetY = self.tokenHolderView.frame.size.height;
    int line = 1;
 
    SSTokenItem *lastToken = nil;
    for (SSTokenItem *token in self.contentTokens)
    {
        NSRect tokenRect = token.view.frame;
        tokenOffsetX = tokenOffsetX + lastToken.view.frame.size.width + self.tokenOffsetX;
        tokenOffsetY = self.tokenHolderView.frame.size.height - (line * (tokenRect.size.height + self.tokenOffsetY));
        
        if(tokenOffsetX + token.view.frame.size.width > self.tokenScrollView.frame.size.width)
        {
            line++;
            tokenOffsetX = self.tokenOffsetX;
            tokenOffsetY = self.tokenHolderView.frame.size.height - (line * (tokenRect.size.height + self.tokenOffsetY));
        }

        tokenRect.origin.x = tokenOffsetX;
        tokenRect.origin.y = tokenOffsetY;

        [token.view setFrame:tokenRect];

//        NSLog(@"Token - %@ Frame - %@ Line - %d",[token.representedObject tokenName],NSStringFromRect(token.view.frame),line);

        lastToken = token;
    }    
}

-(void)resizeDocumentView
{
    CGFloat totalHeight = 0;
    CGFloat totalWidth  = 0;
    
    int requiredLines = 1;

    for (SSTokenItem *token in self.contentTokens)
    {
        totalWidth += (self.tokenOffsetX + token.view.frame.size.width);

        if(totalWidth  > self.tokenScrollView.frame.size.width)
        {
            requiredLines++;
            totalWidth = (self.tokenOffsetX + token.view.frame.size.width);
        }
    }
    
    SSTokenItem *anyToken = [self.contentTokens lastObject];
    totalHeight = (requiredLines * (anyToken.view.frame.size.height + self.tokenOffsetY));
    
    NSRect documentViewRect = [self.tokenHolderView frame];
    documentViewRect.size.width = self.tokenScrollView.frame.size.width;
    documentViewRect.size.height = totalHeight;
    [self.tokenHolderView setFrame:documentViewRect];
    
    CGFloat newHeight = documentViewRect.size.height;
    NSRect newRect = self.tokenScrollView.frame;
    newRect.size.height = (newHeight < self.minSSTokenHeight)?self.minSSTokenHeight:newHeight;
    [self.tokenScrollView setFrame:newRect];
    
    newHeight = newRect.size.height;
    newRect = self.tokenTextField.frame;
    newRect.size.height = newHeight;
    newRect.origin.y = NSMaxY(self.tokenTextField.frame)-newHeight;
    [self.tokenTextField setFrame:newRect];

    if([self.delegate respondsToSelector:@selector(SSTokenFrameDidChanged:)])
        [self.delegate SSTokenFrameDidChanged:newRect];
}

#pragma mark - SSTokenItemDelegate Methods

-(void)tokenButtonClicked:(SSTokenItem *)tokenItem
{
    if([self.delegate respondsToSelector:@selector(canRemoveToken:)])
        [self.delegate SSTokenSelected:tokenItem.representedObject];
}

-(void)tokenCloseButtonClicked:(SSTokenItem *)tokenItem
{
    BOOL canRemove = YES;
    if([self.delegate respondsToSelector:@selector(canRemoveSSToken:)])
        canRemove = [self.delegate canRemoveSSToken:tokenItem.representedObject];
    
    if(canRemove)
    {
        [self removeToken:tokenItem.representedObject];
        if([self.delegate respondsToSelector:@selector(didRemoveSSToken:)])
            [self.delegate didRemoveSSToken:tokenItem.representedObject];
    }
}

#pragma mark -

@end
