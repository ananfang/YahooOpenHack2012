//
//  CalendarView.m
//  TumblrReform
//
//  Created by Fang Yung-An on 12/10/18.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "CalendarView.h"

#import <QuartzCore/QuartzCore.h>

#import "CalendarCollectionViewCell.h"
#import "CalendarModel.h"
#import "Post+TumblrAPI.h"

#define CalendarMonthView_DAYCELLS_INIT_Y 45.0
#define CalendarMonthView_DAYCELLS_INIT_X 2.0

@interface CalendarView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *monthDateComponents;
@property (nonatomic, strong) NSMutableDictionary *postDict;

@property (nonatomic, weak) IBOutlet UICollectionView *calendarCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;

@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger weekdayOffset;

- (void)monthOffset:(NSInteger)offset;
@end

@implementation CalendarView

#pragma mark - Init
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nib = [UINib nibWithNibName:CalendarCollectionViewCell_CLASS_NAME bundle:nil];
    [self.calendarCollectionView registerNib:nib forCellWithReuseIdentifier:CalendarCollectionViewCell_CLASS_NAME];
    
    [self setMonth:10 ofYear:2012];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //grid
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);
    
    //vertical gray line
    for (int i = 0; i <= 7; i++) {
        CGContextMoveToPoint(context, (CalendarMonthView_DAYCELLS_INIT_X + 45 * i) - .5, CalendarMonthView_DAYCELLS_INIT_Y);
        CGContextAddLineToPoint(context, (CalendarMonthView_DAYCELLS_INIT_X + 45 * i) - .5, 367);
    }
    
    [[UIColor colorWithWhite:198.0/256.0 alpha:1.0] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    //vertical white line
    for (int i = 0; i <= 7; i++) {
        CGContextMoveToPoint(context, (CalendarMonthView_DAYCELLS_INIT_X + 45 * i) + .5, CalendarMonthView_DAYCELLS_INIT_Y);
        CGContextAddLineToPoint(context, (CalendarMonthView_DAYCELLS_INIT_X + 45 * i) + .5, 367);
    }
    
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    
    //horizontal gray line
    for (int i = 0; i <= 6; i++) {
        CGContextMoveToPoint(context, CalendarMonthView_DAYCELLS_INIT_X, (CalendarMonthView_DAYCELLS_INIT_Y + 45 * i) - .5);
        CGContextAddLineToPoint(context, CalendarMonthView_DAYCELLS_INIT_X + 315, (CalendarMonthView_DAYCELLS_INIT_Y + 45 * i) - .5);
    }
    
    [[UIColor colorWithWhite:198.0/256.0 alpha:1.0] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    //horizontal white line
    for (int i = 0; i <= 6; i++) {
        CGContextMoveToPoint(context, CalendarMonthView_DAYCELLS_INIT_X, (CalendarMonthView_DAYCELLS_INIT_Y + 45 * i) + .5);
        CGContextAddLineToPoint(context, CalendarMonthView_DAYCELLS_INIT_X + 315, (CalendarMonthView_DAYCELLS_INIT_Y + 45 * i) + .5);
    }
    
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    //    CGContextClosePath(context);
}

#pragma mark - Public methods
- (void)setMonth:(NSInteger)month ofYear:(NSInteger)year
{
    self.month = month;
    self.year = year;
    self.monthYearLabel.text = [NSString stringWithFormat:@"%i/%i", month, year];
    self.monthDateComponents = [CalendarModel daysInMonth:month ofYear:year];
    
    
    ICTimestampInterval monthTimestampInterval = [CalendarModel monthTimestampInterval:self.month ofYear:self.year];
    NSArray *posts = [Post fetchPostsWithtTimestampInterval:monthTimestampInterval];
    self.postDict = [NSMutableDictionary dictionary];
    DLog(@"[%@ %@ %d] post count: %i", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, posts.count);
    for (Post *post in posts) {
        NSTimeInterval postTimestamp = [post.timestamp integerValue];
        NSDateComponents *postDateComponents = [CalendarModel dateComponentsFromTimestamp:postTimestamp];
        
        NSString *postIndex = [NSString stringWithFormat:@"%i", postDateComponents.day];
        [self.postDict setObject:post forKey:postIndex];
    }
    
    [self.calendarCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDateComponents *firstDayDateComponents = [self.monthDateComponents objectAtIndex:0];
    self.weekdayOffset = firstDayDateComponents.weekday - 1;
    return (self.monthDateComponents.count + self.weekdayOffset);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = CalendarCollectionViewCell_CLASS_NAME;
    CalendarCollectionViewCell *cell = [self.calendarCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.weekdayOffset) {
        cell.day = 0;
    } else {
        cell.day = indexPath.row - self.weekdayOffset + 1;
        NSString *postIndex = [NSString stringWithFormat:@"%i", cell.day];
        cell.post = [self.postDict objectForKey:postIndex];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Target-Action
- (IBAction)pressedChangeMonth:(UIButton *)sender {
    if (sender.frame.origin.x < 160) {
        [self monthOffset:-1];
    } else {
        [self monthOffset:1];
    }
}

#pragma mark - Private methods
- (void)monthOffset:(NSInteger)offset
{
    self.month = self.month + offset;
    if (self.month > 12) {
        self.month = 1;
        self.year++;
    } else if (self.month < 1) {
        self.month = 12;
        self.year--;
    }
    [self setMonth:self.month ofYear:self.year];
}

@end