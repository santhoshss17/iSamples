//
//  SSRadioButton.m
//  iRadioButton
//
//  Created by SSRadioButton on 03/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SSRadioButton.h"
#import "SSRadioButtonCell.h"

#define SSRadioButtonLabelToLeftSideViewOffset 51.0
#define SSRadioButtonLabelToRightSideViewOffset 20.0
#define SSRadioButtonLabelMidOffset 22.0
#define SSRadioButtonOthersCellHeightFromLabel 50.0

@interface SSRadioButton()
@property(nonatomic,retain) NSArray *radioButtons;

@end

@implementation SSRadioButton
@synthesize radioButtons = radioButtons_;
@synthesize radioButtonTableView = radioButtonTableView_;
@synthesize radioButtonHolderView = radioButtonHolderView_;
@synthesize delegate = delegate_;
@synthesize shouldShowOthersOption = shouldShowOthersOption_;

- (id)init 
{
    return [self initWithRadioButtonTitle:nil];
}

-(id)initWithRadioButtonTitle:(NSArray *)radioButtons
{
    self = [super init];
    if (self) 
    {
        self.shouldShowOthersOption = YES;
        [[NSBundle mainBundle] loadNibNamed:@"SSRadioButton" owner:self options:nil];
        [self prepareViewForRadioButtonTitles:radioButtons];
    }
    
    return self;
}

- (void)dealloc 
{
    self.delegate = nil;
    self.radioButtons = nil;
    self.radioButtonHolderView = nil;
    self.radioButtonTableView = nil;
    [super dealloc];
}

-(void)prepareViewForRadioButtonTitles:(NSArray *)radioButtonTitles
{
    self.radioButtons = radioButtonTitles;
}

#pragma mark - Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.radioButtons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSRadioButtonCell *cell = (SSRadioButtonCell *)[tableView dequeueReusableCellWithIdentifier:@"SSRadioButtonCell"];
    
    if(nil == cell)
    {
        UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"SSRadioButtonCell" bundle:nil];
        
        cell = (SSRadioButtonCell *)[viewController view];
        [viewController release];
    }
    
    id<SSRadioButtonCellDatasource> radioItem = [self.radioButtons objectAtIndex:indexPath.row];
    [cell prepareRadioViewForItem:radioItem];
    [cell setIsAlternatingRow:(indexPath.row%2)];
    
    //By default the last cell of the model is considered as the others option cell.
    [cell setIsOthersOptionCell:[radioItem isOthersRadioItem]];    
    return cell;
}

#pragma mark - Tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<SSRadioButtonCellDatasource> radioItem = [self.radioButtons objectAtIndex:indexPath.row];
    [self radioButtonSelected:radioItem];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [tableView frame].size.width - (SSRadioButtonLabelToLeftSideViewOffset + SSRadioButtonLabelToRightSideViewOffset);
    
    id<SSRadioButtonCellDatasource> radioButton = [self.radioButtons objectAtIndex:indexPath.row];
    CGSize theSize = [radioButton.title sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]  constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if([radioButton isOthersRadioItem])
        theSize.height += SSRadioButtonOthersCellHeightFromLabel;
    
    return theSize.height + SSRadioButtonLabelMidOffset;
}

#pragma mark - Radio Selection 
-(void)radioButtonSelected:(id<SSRadioButtonCellDatasource>)radioItem
{
    if(![radioItem isSelected])
    {
        [self.radioButtons makeObjectsPerformSelector:@selector(resetSelection)];
        [radioItem setSelected:YES];
        
        [self.radioButtonTableView reloadData];
        
        if([radioItem isOthersRadioItem])
        {
            int index = [self.radioButtons indexOfObject:radioItem];
            NSIndexPath *othersCellIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            SSRadioButtonCell *othersRadioButtonCell = (SSRadioButtonCell *)[self.radioButtonTableView cellForRowAtIndexPath:othersCellIndexPath];
            [[othersRadioButtonCell othersOptionTextField] becomeFirstResponder];
        }
            
        if([self.delegate respondsToSelector:@selector(radioButtonSelectionDidChange:)])
            [self.delegate radioButtonSelectionDidChange:radioItem];
    }
}

#pragma mark - Helper Methods 
-(UIView *)contentView
{
    return self.radioButtonHolderView;
}

@end
