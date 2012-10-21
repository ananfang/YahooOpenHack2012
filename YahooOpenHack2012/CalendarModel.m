//
//  CalendarModel.m
//  InstaChallenge
//
//  Created by Fang Andy on 12/3/28.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "CalendarModel.h"

// static NSDateFormatter *_dateFormatter = nil;

@implementation CalendarModel
+ (NSArray *)daysInMonth:(NSInteger)month ofYear:(NSInteger)year
{
    NSDateComponents *firstDayComponents = [[NSDateComponents alloc] init];
    [firstDayComponents setDay:1];
    [firstDayComponents setMonth:month];
    [firstDayComponents setYear:year];
    
    NSDate *firstDayDate = [[NSCalendar currentCalendar] dateFromComponents:firstDayComponents];

    NSRange daysInMonthRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit 
                                                                  inUnit:NSMonthCalendarUnit 
                                                                 forDate:firstDayDate];
    
    NSMutableArray *daysInMonth = [NSMutableArray array];
    for (int i = 0; i < daysInMonthRange.length; i++) {
        // Without weekday
        NSDateComponents *eachDayComponents = [[NSDateComponents alloc] init];
        [eachDayComponents setDay:(i + 1)];
        [eachDayComponents setMonth:month];
        [eachDayComponents setYear:year];
        
        // Get weekday
        NSDate *eachDayDate = [[NSCalendar currentCalendar] dateFromComponents:eachDayComponents];
        
        eachDayComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:eachDayDate];
        
        [daysInMonth addObject:eachDayComponents];
    }
    
    return daysInMonth;
}

+ (ICTimestampInterval)monthTimestampInterval:(NSInteger)month ofYear:(NSInteger)year
{
    ICTimestampInterval monthTimeInterval;
    
    // Start timestamp
    NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
    [startDateComponents setMonth:month];
    [startDateComponents setYear:year];
    
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComponents];
    monthTimeInterval.startTimestamp = [startDate timeIntervalSince1970];
    monthTimeInterval.startTimestamp--;
    
    // End timestamp
    month = (month + 1) > 12 ? 1 : (month + 1);
    if (month == 1) year++;
    
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    [endDateComponents setMonth:month];
    [endDateComponents setYear:year];
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComponents];
    monthTimeInterval.endTimestamp = [endDate timeIntervalSince1970];
    
    DLog(@"[%@ %@ %d] %i/%i: %.f - %i/%i: %.f", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, startDateComponents.year, startDateComponents.month, monthTimeInterval.startTimestamp, endDateComponents.year, endDateComponents.month, monthTimeInterval.endTimestamp);
    
    return monthTimeInterval;
}

+ (NSDateComponents *)dateComponentsFromTimestamp:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    return dateComponents;
}

//+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
//{
//    if (_dateFormatter == nil) {
//        _dateFormatter = [[NSDateFormatter alloc] init];
//    }
//    
//    [_dateFormatter setLocale:[NSLocale currentLocale]];
//    [_dateFormatter setDateStyle:dateStyle];
//    [_dateFormatter setTimeStyle:timeStyle];
//    
//    return _dateFormatter;
//}

//+ (ICTimestampInterval)dayTimestampInterval:(NSDateComponents *)dateComponents
//{
//    ICTimestampInterval dayTimestampInterval;
//    
//    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
//    dayTimestampInterval.startTimestamp = [startDate timeIntervalSince1970];
//    dayTimestampInterval.endTimestamp = dayTimestampInterval.startTimestamp + (60 * 60 * 24);
//    dayTimestampInterval.startTimestamp--;
//    
//    //DLog(@"[%@ %@ %d] %i/%i/%i: %.f %.f", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, dateComponents.year, dateComponents.month, dateComponents.day, dayTimestampInterval.startTimestamp, dayTimestampInterval.endTimestamp);
//    
//    return dayTimestampInterval;
//}

//+ (NSDateComponents *)todayDateComponents
//{
//    return [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
//}
//
//+ (NSInteger)daysWithinEraFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
//{
//    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
//    
//    NSCalendarUnit units= NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *comp1=[currentCalendar components:units fromDate:startDate];
//    NSDateComponents *comp2=[currentCalendar components:units fromDate:endDate];
//    [comp1 setHour:12];
//    [comp2 setHour:12];
//    NSDate *date1=[currentCalendar dateFromComponents:comp1];
//    NSDate *date2=[currentCalendar dateFromComponents:comp2];
//    
//    return [[currentCalendar components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0] day];
//}
//
//+ (NSInteger)daysFromNowToYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
//{
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    [dateComponents setYear:year];
//    [dateComponents setMonth:month];
//    [dateComponents setDay:day];
//    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
//    
//    return [self daysWithinEraFromDate:[NSDate date] toDate:date];
//}
@end