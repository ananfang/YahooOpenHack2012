//
//  TumblrHelper.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "TumblrHelper.h"

#import "GTMOAuthViewControllerTouch.h"
#import "SystemPreference.h"
#import "UserInfo+TumblrAPI.h"

#define TumblrHelper_AUTH_SERVICE_PROVIDER @"Tumblr Service"
#define TumblrHelper_APP_SERVICE_NAME @"Yahoo Open Hack: Tumblr Service"

static TumblrHelper *_sharedHelper = nil;

@interface TumblrHelper ()
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController finishedWithAuth:(GTMOAuthAuthentication *)auth error:(NSError *)error;
@end

@implementation TumblrHelper
#pragma mark - Singleton pattern
+ (TumblrHelper *)sharedHelper
{
    if (_sharedHelper == nil) {
        _sharedHelper = [[TumblrHelper alloc] init];
        [_sharedHelper.tumblrAuth class];
    }
    return _sharedHelper;
}

#pragma mark - Setters and Getters
- (GTMOAuthAuthentication *)tumblrAuth
{
    if (_tumblrAuth == nil) {
        DLog(@"[%@ %@ %d] init tumblr auth ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        
        NSString *myConsumerKey = @"L4CBQSxF30MU2P9DPbeMlmK1PIe7Q95eH92Mx8ovFSeod0wT6H";
        NSString *myConsumerSecret = @"edZt0X7BklDyVEOSFXdMZT0Nwkwx9DpadYJpwa7XdgesJyGxtf";
        
        _tumblrAuth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                                  consumerKey:myConsumerKey
                                                                   privateKey:myConsumerSecret];
        
        // setting the service name lets us inspect the auth object later to know
        // what service it is for
        _tumblrAuth.serviceProvider = TumblrHelper_AUTH_SERVICE_PROVIDER;
        
        // Get the saved authentication, if any, from the keychain.
        if (_tumblrAuth) {
            self.didAuth = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:TumblrHelper_APP_SERVICE_NAME
                                                                      authentication:_tumblrAuth];
            // if the auth object contains an access token, didAuth is now true
        }
    }
    
    return _tumblrAuth;
}

- (void)setDidAuth:(BOOL)didAuth
{
    _didAuth = didAuth;
    [self.delegate tumblrHelper:self didAuth:didAuth];
}

#pragma mark - Public Methods
- (void)loginTumblrServiceFromViewController:(UIViewController *)viewController withDelegate:(id<TumblrHelperDelegate>)delegate
{
    self.delegate = delegate;
    
    NSURL *requestURL = [NSURL URLWithString:@"http://www.tumblr.com/oauth/request_token"];
    NSURL *accessURL = [NSURL URLWithString:@"http://www.tumblr.com/oauth/access_token"];
    NSURL *authorizeURL = [NSURL URLWithString:@"http://www.tumblr.com/oauth/authorize"];
    NSString *scope = @"yahoo-open-hack://callback";
    
    // set the callback URL to which the site should redirect, and for which
    // the OAuth controller should look to determine when sign-in has
    // finished or been canceled
    //
    // This URL does not need to be for an actual web page
    [self.tumblrAuth setCallback:@"yahoo-open-hack://callback"];
    
    // Display the autentication view
    GTMOAuthViewControllerTouch *oauthViewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                                                                 language:nil
                                                                                          requestTokenURL:requestURL
                                                                                        authorizeTokenURL:authorizeURL
                                                                                           accessTokenURL:accessURL
                                                                                           authentication:self.tumblrAuth
                                                                                           appServiceName:TumblrHelper_APP_SERVICE_NAME
                                                                                                 delegate:self
                                                                                         finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [viewController.navigationController pushViewController:oauthViewController animated:YES];
}

- (void)logoutTumblrService
{
    [GTMOAuthViewControllerTouch removeParamsFromKeychainForName:TumblrHelper_APP_SERVICE_NAME];
    
    [UserInfo deleteUserInfoWithName:[SystemPreference objectForType:PreferenceType_UserName]];
    
    [SystemPreference setValue:nil forType:PreferenceType_UserName];
    [SystemPreference setValue:nil forType:PreferenceType_BlogName];
    
    self.tumblrAuth = nil;
    self.didAuth = NO;
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate tumblrHelper:self didAuth:self.didAuth];
}

#pragma mark - Private Methods
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController finishedWithAuth:(GTMOAuthAuthentication *)auth error:(NSError *)error
{
    if (error != nil) {
        // Authentication failed
        DLog(@"[%@ %@ %d] authentication failed: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, error);
        self.tumblrAuth = nil;
        self.didAuth = NO;
    } else {
        // Authentication succeeded
        DLog(@"[%@ %@ %d] authentication successed: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, auth);
        self.tumblrAuth = auth;
        self.didAuth = YES;
        
    }
}

@end