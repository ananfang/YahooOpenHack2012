//
//  ViewController.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/20.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "ViewController.h"

#import "CalendarView.h"
#import "DatabaseHelper.h"
#import "SystemPreference.h"
#import "UserInfo+TumblrAPI.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImagView;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.userInteractionEnabled = NO;
    [[DatabaseHelper sharedHelper] openSharedManagedDocumentUsingBlock:^(UIManagedDocument *managedDocument) {
        self.view.userInteractionEnabled = YES;
        UserInfo *userInfo = [UserInfo userInfoWithName:[SystemPreference objectForType:PreferenceType_UserName]];
        DLog(@"[%@ %@ %d] %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, userInfo.name);
        [self.calendarView setMonth:10 ofYear:2012];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
