//
//  CalendarCollectionViewCell.h
//  TumblrReform
//
//  Created by Fang Yung-An on 12/10/18.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"

#define CalendarCollectionViewCell_CLASS_NAME @"CalendarCollectionViewCell"

@interface CalendarCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Post *post;
@property (nonatomic) NSInteger day;
@end