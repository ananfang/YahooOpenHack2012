//
//  TumblrBlogInfo+TumblrAPI.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "TumblrBlogInfo+TumblrAPI.h"

#import "DatabaseHelper.h"

@implementation TumblrBlogInfo (TumblrAPI)
+ (TumblrBlogInfo *)createWithName:(NSString *)name andInfo:(NSDictionary *)info
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    TumblrBlogInfo *blogInfo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TumblrBlogInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error = nil;
    NSArray *blogInfos = [context executeFetchRequest:request error:&error];
    
    if (!blogInfos || [blogInfos count] > 1) {
        DLog(@"[%@ %@ %d] fetch category from database error.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    } else if (![blogInfos count]) {
        DLog(@"[%@ %@ %d] create blog info name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, name);
        
        blogInfo = [NSEntityDescription insertNewObjectForEntityForName:@"TumblrBlogInfo" inManagedObjectContext:context];
    } else {
        DLog(@"[%@ %@ %d] get blog info name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, name);
        blogInfo = [blogInfos lastObject];
    }
    
    if (blogInfo) {
        blogInfo.name = name;
        
        // Info
        blogInfo.blog_description = [info objectForKey:@"description"];
        blogInfo.followers = [info objectForKey:@"followers"];
        blogInfo.posts = [info objectForKey:@"posts"];
        blogInfo.title = [info objectForKey:@"title"];
        blogInfo.url = [info objectForKey:@"url"];
    }
    
    return blogInfo;
}

+ (TumblrBlogInfo *)blogInfoWithName:(NSString *)name
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TumblrBlogInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error = nil;
    NSArray *blogInfos = [context executeFetchRequest:request error:&error];
    
    return [blogInfos lastObject];
}
@end