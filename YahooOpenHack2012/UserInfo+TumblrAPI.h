//
//  UserInfo+TumblrAPI.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "UserInfo.h"

@interface UserInfo (TumblrAPI)
+ (UserInfo *)createWithName:(NSString *)name withInfo:(NSDictionary *)info;
+ (UserInfo *)userInfoWithName:(NSString *)name;
+ (void)deleteUserInfoWithName:(NSString *)name;
@end