//
//  TumblrLoginViewController.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "TumblrLoginViewController.h"

#import "DatabaseHelper.h"
#import "Post+TumblrAPI.h"
#import "SystemPreference.h"
#import "TumblrBlogInfo.h"
#import "TumblrHelper+API.h"
#import "TumblrInfoView.h"
#import "UserInfo+TumblrAPI.h"

@interface TumblrLoginViewController () <TumblrHelperDelegate>
@property (weak, nonatomic) IBOutlet TumblrInfoView *tumblrInfoView;

- (void)getUserInfo;
- (void)getPostWithOffset:(NSInteger)offset inBlogInfo:(TumblrBlogInfo *)blogInfo;
@end

@implementation TumblrLoginViewController

#pragma mark - Default overrides
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem.title = [[TumblrHelper sharedHelper] didAuth] ? @"Logout" : @"Login";
    if ([[TumblrHelper sharedHelper] didAuth]) {
        [self getUserInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target-Action
- (IBAction)pressedLogButton:(id)sender {
    if ([[TumblrHelper sharedHelper] didAuth]) {
        [[TumblrHelper sharedHelper] logoutTumblrService];
    } else {
        [[TumblrHelper sharedHelper] loginTumblrServiceFromViewController:self withDelegate:self];
    }
}

#pragma mark - TumblrHelperDelegate
- (void)tumblrHelper:(TumblrHelper *)helper didAuth:(BOOL)didAuth
{
    self.navigationItem.rightBarButtonItem.title = didAuth ? @"Logout" : @"Login";
    
    if (didAuth) {
        [self getUserInfo];
    }
}

#pragma mark- Private methods
- (void)getUserInfo
{
    [[TumblrHelper sharedHelper] callTumblrUserAPIWithMethod:@"GET" path:@"/info" parameters:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        DLog(@"[%@ %@ %d] success: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
        NSDictionary *userInfo = [JSON valueForKeyPath:@"response.user"];
        NSString *name = [userInfo objectForKey:@"name"];
        UserInfo *userInfoManagedObject = [UserInfo createWithName:name withInfo:userInfo];
        [[DatabaseHelper sharedHelper] saveDocument];
        [SystemPreference setValue:name forType:PreferenceType_UserName];
        
        // Get first blog for demo
        TumblrBlogInfo *blogInfo = [userInfoManagedObject.blogs objectAtIndex:0];
        [SystemPreference setValue:blogInfo.name forType:PreferenceType_BlogName];
        DLog(@"[%@ %@ %d] %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, blogInfo.name);
        self.tumblrInfoView.blogInfo = blogInfo;
        
        
        [self getPostWithOffset:0 inBlogInfo:blogInfo];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"[%@ %@ %d] fail: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, error
             );
    }];
}

- (void)getPostWithOffset:(NSInteger)offset inBlogInfo:(TumblrBlogInfo *)blogInfo
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[TumblrHelper sharedHelper] tumblrAuth].consumerKey, @"api_key",
                                [NSNumber numberWithInteger:offset], @"offset", nil];
    [[TumblrHelper sharedHelper] callTumblrBlogAPIWithMethod:@"GET" path:@"/posts" parameters:parameters baseHostname:blogInfo.name success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // DLog(@"[%@ %@ %d] success: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
        NSArray *posts = [JSON valueForKeyPath:@"response.posts"];
        for (NSDictionary *post in posts) {
            Post *postManagedObject = [Post createWithID:[[post objectForKey:@"id"] description] withInfo:post];
            postManagedObject.belongTo = blogInfo;
        }
        [[DatabaseHelper sharedHelper] saveDocument];
        self.tumblrInfoView.postLoadingCount = offset + posts.count;
        
        if (offset + 20 < [blogInfo.posts integerValue]) {
            [self getPostWithOffset:offset + 20 inBlogInfo:blogInfo];
        } else {
            [self.tumblrInfoView parsePostType];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"[%@ %@ %d] fail: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
    }];
}

@end