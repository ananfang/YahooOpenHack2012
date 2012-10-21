//
//  TumblrBlogInfo.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post, UserInfo;

@interface TumblrBlogInfo : NSManagedObject

@property (nonatomic, retain) NSString * blog_description;
@property (nonatomic, retain) NSNumber * followers;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * posts;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) UserInfo *belongTo;
@property (nonatomic, retain) NSOrderedSet *hasPosts;
@end

@interface TumblrBlogInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(Post *)value inHasPostsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasPostsAtIndex:(NSUInteger)idx;
- (void)insertHasPosts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasPostsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasPostsAtIndex:(NSUInteger)idx withObject:(Post *)value;
- (void)replaceHasPostsAtIndexes:(NSIndexSet *)indexes withHasPosts:(NSArray *)values;
- (void)addHasPostsObject:(Post *)value;
- (void)removeHasPostsObject:(Post *)value;
- (void)addHasPosts:(NSOrderedSet *)values;
- (void)removeHasPosts:(NSOrderedSet *)values;
@end
