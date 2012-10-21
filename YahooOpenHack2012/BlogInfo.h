//
//  BlogInfo.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface BlogInfo : NSManagedObject

@property (nonatomic, retain) NSString * blog_description;
@property (nonatomic, retain) NSNumber * followers;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * posts;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) UserInfo *belongTo;

@end
