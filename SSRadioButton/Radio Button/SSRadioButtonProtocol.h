//
//  SSRadioButtonProtocol.h
//  iRadioButton
//
//  Created by SSRadioButton on 07/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSRadioButtonCellDatasource <NSObject>

-(NSString *)title;

-(BOOL)isSelected;
-(void)setSelected:(BOOL)selected;

-(BOOL)isOthersRadioItem;

@end
