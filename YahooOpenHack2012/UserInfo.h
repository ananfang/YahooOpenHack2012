//
//  UserInfo.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TumblrBlogInfo;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSOrderedSet *blogs;
@end

@interface UserInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(TumblrBlogInfo *)value inBlogsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBlogsAtIndex:(NSUInteger)idx;
- (void)insertBlogs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBlogsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBlogsAtIndex:(NSUInteger)idx withObject:(TumblrBlogInfo *)value;
- (void)replaceBlogsAtIndexes:(NSIndexSet *)indexes withBlogs:(NSArray *)values;
- (void)addBlogsObject:(TumblrBlogInfo *)value;
- (void)removeBlogsObject:(TumblrBlogInfo *)value;
- (void)addBlogs:(NSOrderedSet *)values;
- (void)removeBlogs:(NSOrderedSet *)values;
@end
