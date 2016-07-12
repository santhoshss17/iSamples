//
//  ViewController.h
//  SSPhotoPicker
//
//  Created by iSamples on 26/11/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPhotoPickerViewController.h"

@interface ViewController : UIViewController<SSPhotoPickerViewControllerDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)photoChangeButtonTapped:(UIButton *)button;

@end
