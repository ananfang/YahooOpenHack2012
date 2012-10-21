//
//  ShareViewController.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TumblrBlogInfo+TumblrAPI.h"

@interface ShareViewController : UIViewController
@property (nonatomic, strong) TumblrBlogInfo *blogInfo;
@end
