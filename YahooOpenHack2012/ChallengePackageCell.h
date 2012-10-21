//
//  ChallengePackageCell.h
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/21.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChallengePackageCell_CLASS_NAME @"ChallengePackageCell"

@interface ChallengePackageCell : UITableViewCell
- (void)setName:(NSString *)name withDict:(NSDictionary *)dict;
@end