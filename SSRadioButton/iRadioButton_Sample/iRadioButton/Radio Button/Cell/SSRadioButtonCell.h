//
//  SSRadioButtonCell.h
//  iRadioButton
//
//  Created by SSRadioButton on 03/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSRadioButton.h"
#import "SSRadioButtonProtocol.h"

@interface SSRadioButtonCell : UITableViewCell <UITextFieldDelegate>
{
    UIButton *radioButton_;
    UILabel *radioButtonTitle_;
    UITextField *othersOptionTextField_;
    BOOL isAlternatingRow_;
    BOOL isOthersOptionCell_;

    id<SSRadioButtonCellDatasource> radioItem_;
}
@property(nonatomic,retain)IBOutlet UIButton *radioButton;
@property(nonatomic,retain)IBOutlet UILabel *radioButtonTitle;
@property(nonatomic,retain)UITextField *othersOptionTextField;
@property(nonatomic,retain)id<SSRadioButtonCellDatasource> radioItem;
@property(nonatomic,assign)BOOL isAlternatingRow;
@property(nonatomic,assign)BOOL isOthersOptionCell;

-(void)prepareRadioViewForItem:(id<SSRadioButtonCellDatasource>)radioItem;

-(IBAction)radioButtonSelected:(UIButton *)selected;

@end
