//
//  TumblrHelper+API.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "TumblrHelper+API.h"
#import "AFNetworking.h"

@implementation TumblrHelper (API)
- (void)callTumblrUserAPIWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
    NSURL *url = [NSURL URLWithString:@"http://api.tumblr.com/"];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    
    path = [NSString stringWithFormat:@"v2/user%@", path];
    NSMutableURLRequest *request = [client requestWithMethod:method path:path parameters:parameters];
    
    [self operationWithRequest:request success:success failure:failure];
}

- (void)callTumblrBlogAPIWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters baseHostname:(NSString *)baseHostname success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
    NSURL *url = [NSURL URLWithString:@"http://api.tumblr.com/"];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    
    path = [NSString stringWithFormat:@"v2/blog/%@.tumblr.com%@", baseHostname, path];
    NSMutableURLRequest *request = [client requestWithMethod:method path:path parameters:parameters];
    
    [self operationWithRequest:request success:success failure:failure];
}

- (void)operationWithRequest:(NSMutableURLRequest *)request success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
    if ([[TumblrHelper sharedHelper] didAuth]) {
        [[[TumblrHelper sharedHelper] tumblrAuth] authorizeRequest:request];
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(request, response, JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(request, response, error, JSON);
    }];
    
    [operation start];
}
@end