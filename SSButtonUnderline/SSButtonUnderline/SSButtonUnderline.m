//
//  SSButtonUnderline.m
//  MyAuto
//
//  Created by Santosh Shanbhag on 20/05/13.
//  Copyright (c) 2013 Santosh Shanbhag. All rights reserved.
//

#import "SSButtonUnderline.h"

#define Y_OFFSET 3.0

@implementation SSButtonUnderline

+ (SSButtonUnderline*) underlinedButton {
    SSButtonUnderline* button = [[SSButtonUnderline alloc] init];
    return button;
}

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender + Y_OFFSET);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + Y_OFFSET);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
