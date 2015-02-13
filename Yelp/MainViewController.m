//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"
#import "SVProgressHUD.h"

NSString * const kYelpConsumerKey = @"UgcPymh8Mrzi96l3sxyr-w";
NSString * const kYelpConsumerSecret = @"vuYqZdxZiiYXqkOc7hYChJJ1s-8";
NSString * const kYelpToken = @"P3AepoF3ap3ceU_p5L7ia04gJ0pNzYYL";
NSString * const kYelpTokenSecret = @"rdIU15RaiP5N7zz-m-2YV4P1DHA";
NSString * const defaultSearchTerm = @"Restaurants";
UIColor *yelpColor;

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString* searchTerm;

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // yelp color
    yelpColor = [UIColor colorWithRed:196/255.0f green:18/255.0f blue:0/255.0f alpha:1.0f];
    
    // configure table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 86;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];

    // navigation bar
    //self.navigationController.navigationBar.barTintColor = yelpColor;
    
    // filter button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    // search bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.searchTerm = searchBar.text = defaultSearchTerm;
    
    // progress hud
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]];
    
    // fetch some data
    [self fetchBusinesses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    
    cell.business = self.businesses[indexPath.row];
    
    return cell;
}

#pragma mark - Filter delegate methods

-(void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    self.filters = filters;
    [self fetchBusinesses];
}

#pragma mark - Search bar delegate methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        self.searchTerm = defaultSearchTerm;
    } else {
        self.searchTerm = searchText;
    }

    [self fetchBusinesses];
}


#pragma mark - Private methods

-(void)fetchBusinesses {
    [self fetchBusinessesWithQuery:self.searchTerm params:self.filters];
}

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [SVProgressHUD show];
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        
        NSArray *businessesDictionaries = response[@"businesses"];
        
        self.businesses = [Business businessesWithDictionaries:businessesDictionaries];
        
        [self.tableView reloadData];

        [SVProgressHUD dismiss];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"error: %@", [error description]);
        [SVProgressHUD dismiss];
    }];
}

-(void)onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    vc.delegate = self;
    
    [self presentViewController:nvc animated:YES completion:nil];
}


@end
