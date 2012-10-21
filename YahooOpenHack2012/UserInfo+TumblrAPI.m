//
//  UserInfo+TumblrAPI.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "UserInfo+TumblrAPI.h"

#import "DatabaseHelper.h"
#import "TumblrBlogInfo+TumblrAPI.h"

@implementation UserInfo (TumblrAPI)
+ (UserInfo *)createWithName:(NSString *)name withInfo:(NSDictionary *)info
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    UserInfo *userInfo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error = nil;
    NSArray *userInfos = [context executeFetchRequest:request error:&error];
    
    if (!userInfos || [userInfos count] > 1) {
        DLog(@"[%@ %@ %d] fetch category from database error.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    } else if (![userInfos count]) {
        DLog(@"[%@ %@ %d] create user info name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, name);
        
        userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
    } else {
        DLog(@"[%@ %@ %d] get user info name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, name);
        userInfo = [userInfos lastObject];
    }
    
    if (userInfo) {
        userInfo.name = name;
        
        // Info
        userInfo.following = [info objectForKey:@"following"];
        
        // blogs
        NSArray *blogs = [info objectForKey:@"blogs"];
        for (NSDictionary *blog in blogs) {
            TumblrBlogInfo *blogInfo = [TumblrBlogInfo createWithName:[blog objectForKey:@"name"] andInfo:blog];
            blogInfo.belongTo = userInfo;
        }
        
    }
    
    return userInfo;
}

+ (UserInfo *)userInfoWithName:(NSString *)name
{
    NSManagedObjectContext *context = [[[DatabaseHelper sharedHelper] managedDocument] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error = nil;
    NSArray *userInfos = [context executeFetchRequest:request error:&error];
    
    return [userInfos lastObject];
}

+ (void)deleteUserInfoWithName:(NSString *)name
{
    UserInfo *userInfo = [self userInfoWithName:name];
    
    UIManagedDocument *document = [[DatabaseHelper sharedHelper] managedDocument];
    [document.managedObjectContext deleteObject:userInfo];
    
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
    }];
}
@end