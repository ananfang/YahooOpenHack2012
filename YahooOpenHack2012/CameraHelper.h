//
//  CameraHelper.h
//  InstaCC
//
//  Created by Fang Yung-An on 12/9/19.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CameraHelper;

@protocol CameraHelperDelegate <NSObject>
- (void)cameraHelper:(CameraHelper *)helper didReceiveImage:(UIImage *)image;
@end

@interface CameraHelper : NSObject
+ (CameraHelper *)sharedHelper;


@property (nonatomic, weak) id<CameraHelperDelegate> delegate;
- (void)showCameraHelperFromViewController:(UIViewController *)viewController withDelegate:(id<CameraHelperDelegate>)delegate;
@end