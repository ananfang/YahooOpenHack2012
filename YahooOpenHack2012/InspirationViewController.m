//
//  InspirationViewController.m
//  YahooOpenHack2012
//
//  Created by Fang Yung-An on 12/10/21.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "InspirationViewController.h"

#import "AFNetworking.h"

@interface InspirationViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *inspirationCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (nonatomic, strong) NSArray *photos;
@end

@implementation InspirationViewController

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
    
    self.tagLabel.text = [NSString stringWithFormat:@"#%@", self.tag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters and Getters
- (void)setTag:(NSString *)tag
{
    _tag = tag;
    
    NSURL *url = [NSURL URLWithString:@"http://api.flickr.com"];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"json", @"format",
                                @"1", @"nojsoncallback",
                                @"flickr.photos.search", @"method",
                                @"0a4eb1d9c67dd222ed75e2381f7a3d0a", @"api_key",
                                tag, @"tags",
                                @"16", @"per_page",
                                @"interestingness-desc", @"sort", nil];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"/services/rest/" parameters:parameters];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        DLog(@"[%@ %@ %d] success: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
        
        NSArray *photoDicts = [JSON valueForKeyPath:@"photos.photo"];
        NSMutableArray *mutablePhotos = [NSMutableArray array];
        for (NSDictionary *photo in photoDicts) {
            NSString *farm = [photo objectForKey:@"farm"];
            NSString *server = [photo objectForKey:@"server"];
            NSString *id = [photo objectForKey:@"id"];
            NSString *secret = [photo objectForKey:@"secret"];
            NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg", farm, server, id, secret];
            
            [mutablePhotos addObject:photoURLString];
        }
        
        self.photos = [mutablePhotos copy];
        [self.inspirationCollectionView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"[%@ %@ %d] fail: %@ ", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, JSON);
    }];
    
    
    [operation start];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    NSString *photoImageURL = [self.photos objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [imageView setImageWithURL:[NSURL URLWithString:photoImageURL]];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

@end