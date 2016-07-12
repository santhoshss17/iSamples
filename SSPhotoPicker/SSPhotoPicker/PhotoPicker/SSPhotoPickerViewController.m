//
//  SSPhotoPickerViewController.m
//  SSPhotoPicker
//
//  Created by iSamples on 27/11/12.
//  Copyright (c) 2012 SS. All rights reserved.
//

#import "SSPhotoPickerViewController.h"
#import "WEPopoverController.h"

@interface SSPhotoPickerViewController ()

@property(nonatomic,retain)id imagePickerPopover;
@property(nonatomic,assign)CGRect presentRect;
@property(nonatomic,assign)UIViewController *parentContainerViewController; //iPhone only

@end

@implementation SSPhotoPickerViewController

@synthesize imagePickerPopover;
@synthesize delegate = delegate_;
@synthesize pickerDirection;
@synthesize dismissPickerOnImageSelection;
@synthesize presentRect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.parentContainerViewController = nil;
    self.imagePickerPopover = nil;
    self.delegate = nil;
    [super dealloc];
}

-(void)displayPhotoPickerFromRect:(CGRect)rect inViewController:(UIViewController *)viewController
{
    self.presentRect = rect;
    self.parentContainerViewController = viewController;
    
    NSString *popoverClass = @"UIPopoverController";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        popoverClass = @"WEPopoverController";
    
    id popoverController = [[NSClassFromString(popoverClass) alloc] initWithContentViewController:self];
    self.imagePickerPopover = popoverController;
    [popoverController setPopoverContentSize:self.view.frame.size];
    [popoverController release];

    if(![self.imagePickerPopover isPopoverVisible])
        [self.imagePickerPopover presentPopoverFromRect:rect inView:viewController.view permittedArrowDirections:self.pickerDirection animated:YES];
}

-(IBAction)choosePhotoFromLibrary:(UIButton *)chooseButton
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        
        id popoverController = [[WEPopoverController alloc] initWithContentViewController:pickerController];
        self.imagePickerPopover = popoverController;
        [popoverController setPopoverContentSize:pickerController.view.frame.size];
        [popoverController release];
        
        if(![self.imagePickerPopover isPopoverVisible])
            [self.imagePickerPopover presentPopoverFromRect:self.presentRect inView:self.parentContainerViewController.view permittedArrowDirections:self.pickerDirection animated:YES];
    }
    else
        [self.imagePickerPopover setContentViewController:pickerController];
    
    [pickerController release];
}

-(IBAction)choosePhotoFromCamera:(UIButton *)chooseButton
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [self.imagePickerPopover dismissPopoverAnimated:YES];
            
            id popoverController = [[WEPopoverController alloc] initWithContentViewController:pickerController];
            self.imagePickerPopover = popoverController;
            [popoverController setPopoverContentSize:pickerController.view.frame.size];
            [popoverController release];
            
            if(![self.imagePickerPopover isPopoverVisible])
                [self.imagePickerPopover presentPopoverFromRect:self.presentRect inView:self.parentContainerViewController.view permittedArrowDirections:self.pickerDirection animated:YES];
        }
        else
            [self.imagePickerPopover setContentViewController:pickerController];
        
        [pickerController release];
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Camera" message:@"Your device does not have the camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
}

-(void)cancelImageSelection
{
    [self.imagePickerPopover dismissPopoverAnimated:YES];
}

#pragma mark - Picker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([self.delegate respondsToSelector:@selector(newImageSelected:)] && nil != newImage)
    {
        [self.delegate newImageSelected:newImage];
    }
    
    if(self.dismissPickerOnImageSelection)
        [self cancelImageSelection];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if([self.delegate respondsToSelector:@selector(canceledImageSelection)])
    {
        [self.delegate canceledImageSelection];
    }
}

#pragma mark -

@end
