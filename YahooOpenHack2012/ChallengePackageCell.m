//
//  ChallengePackageCell.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/21.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "ChallengePackageCell.h"

@interface ChallengePackageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@end

@implementation ChallengePackageCell

- (void)setName:(NSString *)name withDict:(NSDictionary *)dict
{
    self.packageNameLabel.text = name;
    self.coverImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]];
    self.dayLabel.text = [NSString stringWithFormat:@"%@ Days", [dict objectForKey:@"days"]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
