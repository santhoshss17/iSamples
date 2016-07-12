//
//  ViewController.m
//  SSPhotoPicker
//
//  Created by iSamples on 26/11/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,retain)SSPhotoPickerViewController *photoPicker;
@end

@implementation ViewController
@synthesize photoPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.photoPicker = nil;
    [_imageView release];
    [super dealloc];
}

-(IBAction)photoChangeButtonTapped:(UIButton *)button
{
    if(nil == self.photoPicker)
    {
        SSPhotoPickerViewController *newImageController = [[SSPhotoPickerViewController alloc] initWithNibName:@"SSPhotoPickerViewController" bundle:nil];
        newImageController.delegate = self;
        self.photoPicker = newImageController;
        [newImageController release];
    }
    
    self.photoPicker.pickerDirection = SSPickerPopoverArrowDirectionUp;
    self.photoPicker.dismissPickerOnImageSelection = YES;
    
    //Universal API for iPhone and iPad
    [self.photoPicker displayPhotoPickerFromRect:[button frame] inViewController:self];
}

#pragma Mark -
#pragma SSPhotoPickerViewController Delegate Methods

-(void)newImageSelected:(UIImage *)newImage
{
    NSLog(@"New Image Selected");
    [self.imageView setImage:newImage];
}

-(void)canceledImageSelection
{
    NSLog(@"User has canceled the Image selection");
}

@end
