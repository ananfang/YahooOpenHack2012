//
//  ChallengeViewController.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/21.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "ChallengeViewController.h"

#import "InspirationViewController.h"
#import "SystemPreference.h"

@interface ChallengeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UITableView *challengeTableView;
@end

@implementation ChallengeViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"[%@ %@ %d] %@, %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, self.name, self.challenges);
    self.coverImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.name]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.challenges.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Challenge Cell";
    UITableViewCell *cell = [self.challengeTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSDictionary *challenge = [self.challenges objectAtIndex:indexPath.row];
    cell.textLabel.text = [challenge objectForKey:@"challenge"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *challenge = [self.challenges objectAtIndex:indexPath.row];
    NSString *tag = [challenge objectForKey:@"flickr"];
    [self performSegueWithIdentifier:@"ChallengeView shows InspirationView" sender:tag];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *challenge = [self.challenges objectAtIndex:indexPath.row];
    NSString *tag = [challenge objectForKey:@"flickr"];
    [SystemPreference setValue:tag forType:PreferenceType_Tag];
    
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChallengeView shows InspirationView"]) {
        InspirationViewController *inspirationViewController = segue.destinationViewController;
        inspirationViewController.tag = sender;
    }
}


@end