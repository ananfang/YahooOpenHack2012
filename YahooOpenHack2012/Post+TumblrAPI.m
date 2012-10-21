//
//  Post+TumblrAPI.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "Post+TumblrAPI.h"

#import "DatabaseHelper.h"

@implementation Post (TumblrAPI)
+ (Post *)createWithID:(NSString *)postID withInfo:(NSDictionary *)info
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    Post *post = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", postID];
    
    NSError *error = nil;
    NSArray *posts = [context executeFetchRequest:request error:&error];
    
    if (!posts || [posts count] > 1) {
        DLog(@"[%@ %@ %d] fetch post from database error.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    } else if (![posts count]) {
        DLog(@"[%@ %@ %d] create post id:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, postID);
        
        post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
    } else {
        DLog(@"[%@ %@ %d] get post id:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, postID);
        post = [posts lastObject];
    }
    
    if (post) {
        post.id = postID;
        
        // Info
        post.post_url = [info objectForKey:@"post_url"];
        post.timestamp = [info objectForKey:@"timestamp"];
        post.type = [info objectForKey:@"type"];
        
        if ([post.type isEqualToString:@"photo"]) {
            NSArray *photos = [info objectForKey:@"photos"];
            NSDictionary *photo = photos.lastObject;
            NSArray *altSizePhotos = [photo objectForKey:@"alt_sizes"];
            for (NSDictionary *altSizePhoto in altSizePhotos) {
                if ([[altSizePhoto objectForKey:@"height"] integerValue] == 75) {
                    post.photo_url = [altSizePhoto objectForKey:@"url"];
                }
            }
        }
    }
    
    return post;
}

+ (Post *)postWithID:(NSString *)postID
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", postID];
    
    NSError *error = nil;
    NSArray *posts = [context executeFetchRequest:request error:&error];
    
    return [posts lastObject];
}

+ (NSArray *)fetchPostsWithtTimestampInterval:(ICTimestampInterval)timestampInterval
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
    
    request.predicate = [NSPredicate predicateWithFormat: @"timestamp > %i AND timestamp < %i", (int)timestampInterval.startTimestamp, (int)timestampInterval.endTimestamp];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *posts = [context executeFetchRequest:request error:&error];
    
    return posts;
}

+ (NSArray *)fetchAllPosts
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}
@end