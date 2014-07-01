//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpTableViewCell.h"
#import "FilterViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSMutableDictionary *filterParams;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filterParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                @"term": @"",
                                                                @"ll" : @"37.4262609,-122.017313",
                                                                @"category_filter" : @"restaurants",
                                                                @"deals_filter" : @"0",
                                                                @"sort" : @"1",
                                                                @"radius_filter": @"10000"
                                                            }];
        self.searchTerm = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadNavigationBarItems];
    [self.tableView registerNib:[UINib nibWithNibName:@"YelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"YelpTableViewCell"];
    
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self fetchResults:@""];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBarItems {
    //SearchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = searchBar;
    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
    
    //Filter
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filterView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (void) fetchResults:(NSString *)searchTerm {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"Loading Restaurants...";
    [hud show:YES];
    
    [self.filterParams setObject:searchTerm forKey:@"term"];

    [self.client searchWithTerm:self.filterParams success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"%@", response);
        self.searchResults = response[@"businesses"];
        [self.tableView reloadData];
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Results" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [hud hide:YES];
    }];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YelpTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YelpTableViewCell"];
    
    [cell setData:self.searchResults[indexPath.row]];
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchTerm = searchBar.text;
    [self fetchResults:searchBar.text];
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self.searchDisplayController setActive:NO];
    [searchBar resignFirstResponder];
}

-(void)filterView {
    FilterViewController *fvc = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    fvc.selectedValues = self.filterParams;
    fvc.delegate = self;
    [self.navigationController pushViewController:fvc animated:YES];
}

-(void) propagateFilters:(FilterViewController *)controller {
    [self fetchResults:self.searchTerm];
}


@end
