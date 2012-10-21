//
//  CalendarCollectionViewCell.m
//  TumblrReform
//
//  Created by Fang Yung-An on 12/10/18.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "CalendarCollectionViewCell.h"

#import "UIImageView+AFNetworking.h"

@interface CalendarCollectionViewCell ()
@property (nonatomic, strong) NSArray *dummyTexts;
@property (weak, nonatomic) IBOutlet UILabel *defaultDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageDayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImagView;
@end

@implementation CalendarCollectionViewCell

#pragma mark - Setters and Getters
- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        self.imageDayLabel.hidden = NO;
        if ([post.type isEqualToString:@"photo"]) {
            self.imageDayLabel.textColor = [UIColor whiteColor];
            NSURL *photoURL = [NSURL URLWithString:post.photo_url];
            [self.photoImagView setImageWithURL:photoURL];
        } else if ([post.type isEqualToString:@"text"]) {
            self.imageDayLabel.textColor = [UIColor lightGrayColor];
            self.defaultDayLabel.text = [self.dummyTexts objectAtIndex:(arc4random() % self.dummyTexts.count)];
            self.defaultDayLabel.textColor = [UIColor colorWithWhite:78.0/255.0 alpha:1.0];
        }
    }
}

- (void)setDay:(NSInteger)day
{
    _day = day;
    self.photoImagView.image = nil;
    self.imageDayLabel.hidden = YES;
    if (day) {
        self.defaultDayLabel.hidden = NO;
        self.defaultDayLabel.textColor = [UIColor lightGrayColor];
        self.defaultDayLabel.text = self.imageDayLabel.text = [NSString stringWithFormat:@"%i", day];
    } else {
        self.defaultDayLabel.hidden = YES;
    }
}

- (NSArray *)dummyTexts
{
    if (_dummyTexts == nil) {
        _dummyTexts = [NSArray arrayWithObjects:@"我想",@"喜歡",@"奇怪",@"不要",@"其實",@"就算",@"只是",@"所以",@"個人",@"難道",@"不過",@"常常",@"然後",@"請問",@"最後",@"否則",@"至少",@"結果",@"大家",@"可是",@"但是",@"今年",@"漸漸",@"無論",@"開始",@"想念",@"或許",@"聽到",@"正好",@"直到",@"後來",@"發現",@"卻又",@"事後",@"抱著",@"昨天",@"根據", nil];
    }
    return _dummyTexts;
}

#pragma mark - Default override methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
