//
//  TumblrBlogInfo+TumblrAPI.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "TumblrBlogInfo.h"

@interface TumblrBlogInfo (TumblrAPI)
+ (TumblrBlogInfo *)createWithName:(NSString *)name andInfo:(NSDictionary *)info;
+ (TumblrBlogInfo *)blogInfoWithName:(NSString *)name;
@end
