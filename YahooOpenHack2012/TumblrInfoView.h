//
//  TumblrInfoView.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TumblrBlogInfo.h"

@interface TumblrInfoView : UIView
- (void)parsePostType;
@property (nonatomic, strong) NSString *baseHostname;
@property (nonatomic, strong) TumblrBlogInfo *blogInfo;
@property (nonatomic) NSInteger postLoadingCount;
@end