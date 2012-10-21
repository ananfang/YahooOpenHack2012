//
//  ShareViewController.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "ShareViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "CameraHelper.h"
#import "SystemPreference.h"
#import "TumblrHelper+API.h"

@interface ShareViewController () <CameraHelperDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextView *shareTextView;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

- (void)initUI;
- (void)keyboardWillChangeFrame:(NSNotification *)notification;
- (void)notAllowedAlert;
- (void)initMessageTextView:(UITextView *)textView;
@end

@implementation ShareViewController

#pragma mark - Default override methods
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [self.shareTextView becomeFirstResponder];
    self.shareTextView.delegate = self;
    [self initUI];
    
    self.blogInfo = [TumblrBlogInfo blogInfoWithName:[SystemPreference objectForType:PreferenceType_BlogName]];
    DLog(@"[%@ %@ %d] %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, self.blogInfo.name);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tagLabel.text = [NSString stringWithFormat:@"#%@", [SystemPreference objectForType:PreferenceType_Tag]];
    self.tagLabel.hidden = ([SystemPreference objectForType:PreferenceType_Tag] == nil);
    [SystemPreference setValue:nil forType:PreferenceType_Tag];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target-Action
- (IBAction)pressedImage:(id)sender {
    [[CameraHelper sharedHelper] showCameraHelperFromViewController:self withDelegate:self];
}

- (IBAction)pressedVideo:(id)sender {
    [self notAllowedAlert];
}

- (IBAction)pressedAudio:(id)sender {
    [self notAllowedAlert];
}

- (IBAction)pressedCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedPost:(id)sender {
    if (self.attachmentImageView.image) {
#warning to-do
        DLog(@"[%@ %@ %d] image ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    } else {
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"text", @"type", self.shareTextView.text, @"body", nil];
        [[TumblrHelper sharedHelper] callTumblrBlogAPIWithMethod:@"POST" path:@"/post" parameters:parameters baseHostname:self.blogInfo.name success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            DLog(@"[%@ %@ %d] success: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            DLog(@"[%@ %@ %d] fail: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
        }];
    }
}

#pragma mark - Private methods
- (void)initUI
{
    self.shareTextView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.shareTextView.layer.borderWidth = 1.0;
    self.shareTextView.layer.cornerRadius = 5.0;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGSize kbSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    DLog(@"[%@ %@ %d] %f, %f", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, kbSize.width, kbSize.height);
    CGFloat toolbarYCenter = self.view.frame.size.height - kbSize.height - self.toolbar.frame.size.height/2;
    self.toolbar.center = CGPointMake(self.toolbar.center.x, toolbarYCenter);
    self.shareTextView.frame = CGRectMake(self.shareTextView.frame.origin.x, self.shareTextView.frame.origin.y, self.shareTextView.frame.size.width, self.toolbar.frame.origin.y - self.shareTextView.frame.origin.y - 10);
}

- (void)notAllowedAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Not available on Demo version."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - CameraHelperDelegate
- (void)cameraHelper:(CameraHelper *)helper didReceiveImage:(UIImage *)image
{
    self.attachmentImageView.image = image;
}

- (void)initMessageTextView:(UITextView *)textView
{
    textView.tag = 0;
    textView.text = [NSString string];
    self.placeholderLabel.hidden = NO;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [self initMessageTextView:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        DLog(@"[%@ %@] send", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return NO;
    } else {
        if (textView.tag == 0) {
            textView.tag = 1;
            self.placeholderLabel.hidden = YES;
        }
    }
    
    return YES;
}

@end