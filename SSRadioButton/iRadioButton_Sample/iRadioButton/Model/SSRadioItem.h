//
//  SSRadioItem.h
//  iRadioButton
//
//  Created by SSRadioButton on 07/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSRadioButtonProtocol.h"

@interface SSRadioItem : NSObject<SSRadioButtonCellDatasource>
{
    NSString *title_;
    BOOL selected_;
    BOOL isOthersRadioItem_;
}
@property(nonatomic,retain)NSString *title;
@property(nonatomic,assign,getter = isSelected)BOOL selected;
@property(nonatomic,assign)BOOL isOthersRadioItem;

@end

