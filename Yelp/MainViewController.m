//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "ReviewCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"SxgSKMU2aA4RTt8wv6b8JQ";
NSString * const kYelpConsumerSecret = @"kMCWuKvORR0J4B-_Fpqf0dnxRmY";
NSString * const kYelpToken = @"7RYy976gUZ2QjZxJ7S9PtFlGzOeyNAyw";
NSString * const kYelpTokenSecret = @"LQs24GHFrXeVlqoGG2Ba1vhOPdE";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) YelpClient *client;

- (void)loadReviews:(NSString *)searchTerm;
- (void)onFilterButton;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadReviews:@"Thai"];
    }
    return self;
}

-(void)loadReviews:(NSString *)searchTerm
{
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:searchTerm success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        self.reviews = response[@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewCell" bundle:nil] forCellReuseIdentifier:@"ReviewCell"];

    self.tableView.rowHeight = 90;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    // Configure the left button in nav bar
    /*UIImage *leftButtonImage = [[UIImage imageNamed:@"filterButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:leftButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;*/
    
    //search bar in navbar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.titleView = searchBar;
    
    //[self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reviews.count;
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath: %d", indexPath.row);
    
    /*UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSDictionary *review = self.reviews[indexPath.row];
    cell.textLabel.text= review[@"name"];
    return cell;*/
    
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    NSDictionary *review = self.reviews[indexPath.row];
    
    cell.nameLabel.text = review[@"name"];
    cell.distanceLabel.text = review[@"distance"];
    
    NSString *numReviews = [NSString stringWithFormat:@"%@", review[@"review_count"]];
    numReviews = [numReviews stringByAppendingFormat:@"Reviews"];
    cell.numReviewsLabel.text = numReviews;
    
    cell.addressLabel.text = review[@"location"][@"address"][0];
    //cell.tagsLabel.text = review[@"synopsis"];
    //cell.dollarsLabel.text = review[@"synopsis"];
    
    NSString *imageUrl = review[@"image_url"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    //[cell.posterView setImageWithURL:url];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    [cell.posterView setImage:image];
    
    NSString *ratingUrl = review[@"rating_img_url"];
    NSURL *rurl = [NSURL URLWithString:ratingUrl];
    
    //[cell.posterView setImageWithURL:url];
    UIImage *rimage = [UIImage imageWithData: [NSData dataWithContentsOfURL:rurl]];
    
    [cell.ratingStarView setImage:rimage];
    
    return cell;
}

- (void)onFilterButton {
    [self.navigationController pushViewController:[[FilterViewController alloc] init] animated:YES];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    NSLog(@"in textDidChagne @%@", searchText);
}



@end
