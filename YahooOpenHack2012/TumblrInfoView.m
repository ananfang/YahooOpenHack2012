//
//  TumblrInfoView.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "TumblrInfoView.h"

#import "Post+TumblrAPI.h"
#import "UIImageView+AFNetworking.h"

@interface TumblrInfoView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (nonatomic) NSInteger totalPost;
@end

@implementation TumblrInfoView

#pragma mark - Init
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.infos = [NSArray arrayWithObjects:@"title", @"posts", @"name", @"url", @"text", @"photo", nil];
    
    self.infoDict = [NSMutableDictionary dictionary];
    for (NSString *info in self.infos) {
        [self.infoDict setObject:@"fetching..." forKey:info];
    }
}

#pragma mark - Setters and Getters
- (void)setBaseHostname:(NSString *)baseHostname
{
    _baseHostname = baseHostname;
    if (baseHostname) {
        NSURL *avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@/avatar/128", baseHostname]];
        [self.avatarImageView setImageWithURL:avatarURL];
    }
}

- (void)setBlogInfo:(TumblrBlogInfo *)blogInfo
{
    _blogInfo = blogInfo;
    [self.infoDict setObject:blogInfo.title forKey:@"title"];
    [self.infoDict setObject:blogInfo.name forKey:@"name"];
    [self.infoDict setObject:blogInfo.url forKey:@"url"];
    
    self.baseHostname = [NSString stringWithFormat:@"%@.tumblr.com", blogInfo.name];
    
    self.totalPost = [blogInfo.posts integerValue];
    self.postLoadingCount = 0;
}

- (void)setPostLoadingCount:(NSInteger)postLoadingCount
{
    _postLoadingCount = postLoadingCount;
    
    NSString *postCount = [NSString stringWithFormat:@"%i/%i", self.postLoadingCount, self.totalPost];
    [self.infoDict setObject:postCount forKey:@"posts"];
    
    [self.infoTableView reloadData];
}

#pragma mark - Public methods
- (void)parsePostType
{
    NSArray *posts = [Post fetchAllPosts];
    NSInteger photoCount = 0;
    NSInteger textCount = 0;
    
    for (Post *post in posts) {
        if ([post.type isEqualToString:@"photo"]) {
            photoCount++;
        } else if ([post.type isEqualToString:@"text"]) {
            textCount++;
        }
    }
    
    [self.infoDict setObject:[NSNumber numberWithInteger:photoCount] forKey:@"photo"];
    [self.infoDict setObject:[NSNumber numberWithInteger:textCount] forKey:@"text"];
    [self.infoTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.infos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text       = [self.infos objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[self.infoDict objectForKey:cell.textLabel.text] description];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end