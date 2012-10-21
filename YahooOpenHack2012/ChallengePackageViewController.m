//
//  ChallengePackageViewController.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/21.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "ChallengePackageViewController.h"

#import "ChallengePackageCell.h"
#import "ChallengeViewController.h"

@interface ChallengePackageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSDictionary *challengePackages;
@property (weak, nonatomic) IBOutlet UITableView *packageTableView;

- (void)loadPlistToDatabase;
- (NSDictionary *)plistDictFromResourceName:(NSString *)name;
@end

@implementation ChallengePackageViewController

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
    
    UINib *nib = [UINib nibWithNibName:ChallengePackageCell_CLASS_NAME bundle:nil];
    [self.packageTableView registerNib:nib forCellReuseIdentifier:ChallengePackageCell_CLASS_NAME];
    
    self.names = [NSArray arrayWithObjects:@"Fun Experiment", @"Nature Beauty", @"People", nil];
    [self loadPlistToDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.challengePackages count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = ChallengePackageCell_CLASS_NAME;
    ChallengePackageCell *cell = (ChallengePackageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ChallengePackageCell alloc] init];
    }
    
    NSString *key = [self.names objectAtIndex:indexPath.row];
    [cell setName:key withDict:[self.challengePackages objectForKey:key]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *key = [self.names objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"packageView shows challengeView" sender:key];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Not available on Demo version."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Target-Action
- (IBAction)pressedCancel:(id)sender {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Methods
- (void)loadPlistToDatabase
{
    // Load challenges from plist
    NSDictionary *plistDict = [self plistDictFromResourceName:@"Challenges"];
    
    self.challengePackages = plistDict;
    
    DLog(@"[%@ %@ %d] %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, self.challengePackages);
    [self.packageTableView reloadData];
}

- (NSDictionary *)plistDictFromResourceName:(NSString *)name
{
    NSDictionary *plistDict;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    
    if (plistPath) {
        NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSPropertyListFormat format;
        NSString *errorDescription = nil;
        
        plistDict = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDescription];
    }
    
    return plistDict;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"packageView shows challengeView"]) {
        ChallengeViewController *challengeViewController = segue.destinationViewController;
        challengeViewController.name = sender;
        NSDictionary *package = [self.challengePackages objectForKey:sender];
        DLog(@"[%@ %@ %d] %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, package);
        challengeViewController.challenges = [package objectForKey:@"challenges"];
    }
}

@end
