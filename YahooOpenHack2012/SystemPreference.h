//
//  SystemPreference.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    PreferenceType_UserName,
    PreferenceType_BlogName,
    PreferenceType_Tag
}PreferenceType;

@interface SystemPreference : NSObject
+ (void)setValue:(id)value forType:(PreferenceType)type;
+ (id)objectForType:(PreferenceType)type;
@end