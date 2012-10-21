//
//  TumblrHelper.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuthAuthentication.h"

@class TumblrHelper;

@protocol TumblrHelperDelegate <NSObject>
- (void)tumblrHelper:(TumblrHelper *)helper didAuth:(BOOL)didAuth;
@end

@interface TumblrHelper : NSObject
+ (TumblrHelper *)sharedHelper;

@property (nonatomic) BOOL didAuth;
@property (nonatomic, strong) GTMOAuthAuthentication *tumblrAuth;
@property (nonatomic, weak) id<TumblrHelperDelegate> delegate;

- (void)loginTumblrServiceFromViewController:(UIViewController *)viewController withDelegate:(id<TumblrHelperDelegate>)delegate;
- (void)logoutTumblrService;
@end