//
//  SystemPreference.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "SystemPreference.h"

#define SystemPreference_USER_NAME @"SystemPreference_USER_NAME"
#define SystemPreference_BLOG_NAME @"SystemPreference_BLOG_NAME"
#define SystemPreference_TAG @"SystemPreference_TAG"

@interface SystemPreference()
+ (NSString *)keyOfType:(PreferenceType)type;
@end

@implementation SystemPreference
#pragma mark - Public Class Methods
+ (void)setValue:(id)value forType:(PreferenceType)type
{
    NSString *key = [self keyOfType:type];
    
    if (key) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:value forKey:key];
        [defaults synchronize];
    }
}

+ (id)objectForType:(PreferenceType)type
{
    NSString *key = [self keyOfType:type];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Private Class Methods
+ (NSString *)keyOfType:(PreferenceType)type
{
    NSString *key = nil;
    switch (type) {
        case PreferenceType_UserName:
            key = SystemPreference_USER_NAME;
            break;
            
        case PreferenceType_BlogName:
            key = SystemPreference_BLOG_NAME;
            break;
            
        case PreferenceType_Tag:
            key = SystemPreference_TAG;
            break;
    }
    
    return key;
}
@end