//
//  CameraHelper.m
//  InstaCC
//
//  Created by Fang Yung-An on 12/9/19.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "CameraHelper.h"

#import <MobileCoreServices/MobileCoreServices.h>

static CameraHelper *_sharedHelper = nil;

@interface CameraHelper () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIViewController *baseViewController;
@property (nonatomic, strong) NSString *instagramCaption;

- (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  usingDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
                                     sourceType:(UIImagePickerControllerSourceType)sourceType
                                  allowsEditing:(BOOL)allowsEditing;

- (void)showActionSheetFromView:(UIView *)view;
@end

@implementation CameraHelper
#pragma mark - Singleton pattern
+ (CameraHelper *)sharedHelper
{
    if (_sharedHelper == nil) {
        _sharedHelper = [[CameraHelper alloc] init];
    }
    
    return _sharedHelper;
}

#pragma mark - Private properties
@synthesize baseViewController = _baseViewController;

#pragma mark - Public methods
- (void)showCameraHelperFromViewController:(UIViewController *)viewController withDelegate:(id<CameraHelperDelegate>)delegate
{
    self.baseViewController = viewController;
    self.delegate = delegate;
    [self showActionSheetFromView:viewController.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // Camera
        [self startCameraControllerFromViewController:self.baseViewController usingDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera allowsEditing:YES];
    } else if (buttonIndex == 1) { // Library
        DLog(@"[%@ %@ %d] library ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        [self startCameraControllerFromViewController:self.baseViewController usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
    }
    
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:^{
        [self.delegate cameraHelper:self didReceiveImage:imageToSave];
        self.baseViewController = nil;
        self.delegate = nil;
    }];
}


#pragma mark - Private Methods
- (void)showActionSheetFromView:(UIView *)view
{
    // Init
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    // Style
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    // Show
    [actionSheet showInView:view];
}

- (BOOL)startCameraControllerFromViewController:(UIViewController *)controller
                                  usingDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
                                     sourceType:(UIImagePickerControllerSourceType)sourceType
                                  allowsEditing:(BOOL)allowsEditing
{
    if (([UIImagePickerController isSourceTypeAvailable:sourceType] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        DLog(@"[%@ %@ %d] can't open camera or library", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        return NO;
    }
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.delegate = delegate;
    cameraUI.sourceType = sourceType;
    cameraUI.allowsEditing = allowsEditing;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

@end