//
//  iRadioButtonAppDelegate_iPhone.m
//  iRadioButton
//
//  Created by SSRadioButton on 03/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "iRadioButtonAppDelegate_iPhone.h"
#import "SSRadioItem.h"

@implementation iRadioButtonAppDelegate_iPhone

- (void)dealloc
{
	[super dealloc];
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSArray *array = [NSArray arrayWithObjects:@"Showing Multiline text supports. Showing Multiline text supports. Showing Multiline text supports. Showing Multiline text supports. Showing Multiline text supports. Showing Multiline text supports.",@"Green",@"Black",@"Brown", nil];
    
    int i = 0;
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *title in array)
    {
        SSRadioItem *radioItem = [[SSRadioItem alloc] init];
        radioItem.title = title;
        
        if(i++ == ([array count]-1))
            radioItem.isOthersRadioItem = YES;
        
        [items addObject:radioItem];
    }
    
    SSRadioButton *radioButton = [[SSRadioButton alloc] initWithRadioButtonTitle:items];
    [radioButton setDelegate:self];
    CGRect rect = [self.window bounds];
    rect.origin.y = 20;
    [[radioButton contentView] setFrame:rect];
    [self.window addSubview:[radioButton contentView]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)radioButtonSelectionDidChange:(id<SSRadioButtonCellDatasource>)selectedRadioButton
{
    NSLog(@"Selected - %@",[selectedRadioButton title]);
}

@end
