//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessCellTableViewCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* businesses;
@property (nonatomic, strong) NSDictionary *searchParams;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *sdController2;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
      [self.client searchWithTerm:@"Thai" params:self.searchParams success:^(AFHTTPRequestOperation *operation, id response) {
            //NSLog(@"response: %@", response);
          NSArray* businessDictionaries = response[@"businesses"];
          self.businesses = [Business businessWithDictionaries:businessDictionaries];
          [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.businesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BusinessCellTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCellTableViewCell"];
  if (self.businesses.count > indexPath.row) {
    cell.business = self.businesses[indexPath.row];
  }
  return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
  self.title = @"Yelp";
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  UINib *nib = [UINib nibWithNibName:@"BusinessCellTableViewCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"BusinessCellTableViewCell"];
  self.navigationItem.titleView = self.searchBar;
  //[self.sdController2 displaysSearchBarInNavigationBar];
  
  self.sdController2.delegate = self;
  self.sdController2.searchResultsDataSource = self;

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    // Do any additional setup after loading the view from its nib.
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  [self.client searchWithTerm:searchString params:nil success:^(AFHTTPRequestOperation *operation, id response) {
    //NSLog(@"response: %@", response);
    NSArray* businessDictionaries = response[@"businesses"];
    self.businesses = [Business businessWithDictionaries:businessDictionaries];
    [self.tableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error: %@", [error description]);
  }];
  return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Filter delegate methods
- (void)filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters {
    // fire a network event
  NSLog(@"fire network event");
  self.searchParams = filters;
  [self.client searchWithTerm:@"Beer" params:self.searchParams success:^(AFHTTPRequestOperation *operation, id response) {
    NSArray* businessDictionaries = response[@"businesses"];
    self.businesses = [Business businessWithDictionaries:businessDictionaries];
    [self.tableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error: %@", [error description]);
  }];
}

#pragma mark - Private methods
- (void)onFilterButton {
  FilterViewController *vc = [[FilterViewController alloc] init];
  UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nvc animated:YES completion:nil];
  vc.delegate = self;
}

@end
