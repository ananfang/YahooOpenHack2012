//
//  Post.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TumblrBlogInfo;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * post_url;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) TumblrBlogInfo *belongTo;

@end
