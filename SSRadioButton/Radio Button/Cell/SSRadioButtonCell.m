//
//  SSRadioButtonCell.m
//  iRadioButton
//
//  Created by SSRadioButton on 03/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SSRadioButtonCell.h"

#define OthersOptionCellOffsetY 40.0
#define OthersOptionCellHeight 30.0

@implementation SSRadioButtonCell
@synthesize radioButton = radioButton_;
@synthesize radioButtonTitle = radioButtonTitle_;
@synthesize radioItem = radioItem_;
@synthesize isAlternatingRow = isAlternatingRow_;
@synthesize isOthersOptionCell = isOthersOptionCell_;
@synthesize othersOptionTextField = othersOptionTextField_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.othersOptionTextField = nil;
    self.radioButtonTitle = nil;
    self.radioButton = nil;
    self.radioItem = nil;
    [super dealloc];
}

-(void)prepareRadioViewForItem:(id<SSRadioButtonCellDatasource>)radioItem
{
    self.radioItem = radioItem;
    [[self radioButtonTitle]setText:[radioItem title]];
    [[self radioButton] setSelected:[radioItem isSelected]];
}

-(IBAction)radioButtonSelected:(UIButton *)selected
{
    SSRadioButton *radioController = (SSRadioButton *)[(UITableView *)[self superview] delegate];
    
    if([radioController respondsToSelector:@selector(radioButtonSelected:)])
        [radioController radioButtonSelected:self.radioItem];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setBackgroundColor:(self.isAlternatingRow)?[UIColor colorWithRed:251.0/255.0 green:244.0/255.0 blue:237.0/255.0 alpha:1.0]:[UIColor colorWithRed:252.0/255.0 green:248.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    CGSize theSize = [self.radioItem.title sizeWithFont:[[self radioButtonTitle] font]  constrainedToSize:CGSizeMake([[self radioButtonTitle] frame].size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect multiLineTextFrame = [self.radioButtonTitle frame];
    [self.radioButtonTitle setNumberOfLines:0];
    multiLineTextFrame.size.height = theSize.height;    
    [self.radioButtonTitle setFrame:multiLineTextFrame];    
}

-(void)setIsOthersOptionCell:(BOOL)isOthersOptionCell
{
    isOthersOptionCell_ = isOthersOptionCell;
    if(isOthersOptionCell)
    {
        if(nil == self.othersOptionTextField)
        {
            CGRect othersOptionRect = [self.radioButtonTitle frame];
            othersOptionRect.origin.y += OthersOptionCellOffsetY;
            othersOptionRect.size.height = OthersOptionCellHeight;
            UITextField *othersTextfield = [[UITextField alloc] initWithFrame:othersOptionRect];
            [othersTextfield setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [othersTextfield setBorderStyle:UITextBorderStyleRoundedRect];
            [othersTextfield setDelegate:self];
            self.othersOptionTextField = othersTextfield;
            [self addSubview:othersTextfield];
            [othersTextfield release];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self radioButtonSelected:nil];
    
    CGPoint pnt = [(UITableView *)self.superview convertPoint:othersOptionTextField_.bounds.origin fromView:othersOptionTextField_];
    NSIndexPath* path = [(UITableView *)self.superview indexPathForRowAtPoint:pnt];
    
    [(UITableView *)self.superview scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
