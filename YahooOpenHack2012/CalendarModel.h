//
//  CalendarModel.h
//  InstaChallenge
//
//  Created by Fang Andy on 12/3/28.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    SymbolTypeRegular,
    SymbolTypeRegularShort,
    SymbolTypeRegularVeryShort,
    SymbolTypeStandalone,
    SymbolTypeStandaloneShort,
    SymbolTypeStandaloneVeryShort
}SymbolType;


typedef struct{
    NSTimeInterval startTimestamp;
    NSTimeInterval endTimestamp;
}ICTimestampInterval;

@interface CalendarModel : NSObject
+ (NSArray *)daysInMonth:(NSInteger)month ofYear:(NSInteger)year;
+ (ICTimestampInterval)monthTimestampInterval:(NSInteger)month ofYear:(NSInteger)year;
+ (NSDateComponents *)dateComponentsFromTimestamp:(NSTimeInterval)timestamp;

//+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
//+ (ICTimestampInterval)dayTimestampInterval:(NSDateComponents *)dateComponents;
//+ (NSDateComponents *)todayDateComponents;
//+ (NSInteger)daysWithinEraFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
//+ (NSInteger)daysFromNowToYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end