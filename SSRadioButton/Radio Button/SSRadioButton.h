//
//  SSRadioButton.h
//  iRadioButton
//
//  Created by SSRadioButton on 03/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSRadioButtonProtocol.h"

@protocol SSRadioButtonCellDelegateProtocol <NSObject>

-(void)radioButtonSelectionDidChange:(id<SSRadioButtonCellDatasource>)selectedRadioButton;

@end

@interface SSRadioButton : NSObject 
{
    UITableView *radioButtonTableView_;
    UIView *radioButtonHolderView_;
    
    id<SSRadioButtonCellDelegateProtocol> delegate_;
    BOOL shouldShowOthersOption_;
}
@property(nonatomic,retain)IBOutlet UITableView *radioButtonTableView;
@property(nonatomic,retain)IBOutlet UIView *radioButtonHolderView;
@property(nonatomic,assign)id<SSRadioButtonCellDelegateProtocol> delegate;
@property(nonatomic,assign)BOOL shouldShowOthersOption;

-(id)initWithRadioButtonTitle:(NSArray *)radioButtons;

-(void)prepareViewForRadioButtonTitles:(NSArray *)radioButtonTitles;

#pragma mark - Radio Selection 
-(void)radioButtonSelected:(id<SSRadioButtonCellDatasource>)radioItem;

-(UIView *)contentView;

@end

