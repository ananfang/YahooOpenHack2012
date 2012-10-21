//
//  CalendarViewController.m
//  TumblrReform
//
//  Created by Fang Yung-An on 12/10/19.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "CalendarViewController.h"

#import "CalendarView.h"

@interface CalendarViewController ()
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@end

@implementation CalendarViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.posts) {
        self.calendarView.posts = self.posts;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
