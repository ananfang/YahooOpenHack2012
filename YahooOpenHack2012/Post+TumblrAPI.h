//
//  Post+TumblrAPI.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "Post.h"

#import "CalendarModel.h"

@interface Post (TumblrAPI)
+ (Post *)createWithID:(NSString *)postID withInfo:(NSDictionary *)info;
+ (Post *)postWithID:(NSString *)postID;
+ (NSArray *)fetchPostsWithtTimestampInterval:(ICTimestampInterval)timestampInterval;
+ (NSArray *)fetchAllPosts;
@end