//
//  SSPhotoPickerViewController.h
//  SSPhotoPicker
//
//  Created by  iSamples  on 27/11/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    SSPickerPopoverArrowDirectionUp = 1UL << 0,
    SSPickerPopoverArrowDirectionDown = 1UL << 1,
    SSPickerPopoverArrowDirectionLeft = 1UL << 2,
    SSPickerPopoverArrowDirectionRight = 1UL << 3,
    SSPickerPopoverArrowDirectionAny = SSPickerPopoverArrowDirectionUp | SSPickerPopoverArrowDirectionDown | SSPickerPopoverArrowDirectionLeft | SSPickerPopoverArrowDirectionRight // Default
    
}SSPickerDirection;

@protocol SSPhotoPickerViewControllerDelegate <NSObject>

-(void)newImageSelected:(UIImage *)newImage;
-(void)canceledImageSelection;

@end

@interface SSPhotoPickerViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    id<SSPhotoPickerViewControllerDelegate> delegate_;
}
@property(nonatomic,assign)id<SSPhotoPickerViewControllerDelegate> delegate;
@property(nonatomic,assign)SSPickerDirection pickerDirection;
@property(nonatomic,assign)BOOL dismissPickerOnImageSelection;

-(IBAction)choosePhotoFromLibrary:(UIButton *)chooseButton;
-(IBAction)choosePhotoFromCamera:(UIButton *)chooseButton;

#pragma Mark Public Methods
-(void)displayPhotoPickerFromRect:(CGRect)rect inViewController:(UIViewController *)viewController;
-(void)cancelImageSelection;

@end
