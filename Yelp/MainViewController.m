//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "RestaurantTableViewCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic,strong) NSArray *restaurantarray;

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;

@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         //You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        /*
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", response);
            self.restaurantarray = response[@"businesses"];
            [self.restaurantTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];*/
    }
    return self;
}


- (void)getData:(NSString *) term {
    
    NSLog(@"Term is %@",term);
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"37.788022,-122.399797",@"ll",@"0",@"sort",nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //deals filter
    NSString *deals_filter = [defaults objectForKey:@"deals_filter"];
    
    [parameters setObject:deals_filter forKey:@"deals_filter"];
    
    //sort
    
    NSString *sort = [defaults objectForKey:@"sort"];
    
    if (sort != nil) {
        [parameters setObject:sort forKey:@"sort"];
    }
    
    //radius
    
    NSString *radius = [defaults objectForKey:@"radius_filter"];
    
    if (radius != nil) {
        
        [parameters setObject:radius forKey:@"radius_filter"];
    }
    
    //category
    NSString *category = [defaults objectForKey:@"category_filter"];
    
    if (category != nil) {
        
        [parameters setObject:category forKey:@"category_filter"];
    }
    
    
    
    if(([term isEqualToString:@""] || term==nil) &&  category == nil) {
        
        term = @"Thai";
        
    }
    

     [parameters setObject:term forKey:@"term"];
    

    
    [self.client searchWithTerm:term Parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        self.restaurantarray = response[@"businesses"];
        [self.restaurantTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [self getData:self.searchBar.text];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.restaurantTableView.delegate = self;
    self.restaurantTableView.dataSource = self;
    self.restaurantTableView.rowHeight = 140;
    [self.restaurantTableView registerNib:[UINib nibWithNibName:@"RestaurantTableViewCell" bundle:nil] forCellReuseIdentifier:@"RestaurantTableViewCell"];
    
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Filter", nil]];
    [segmentedControl addTarget:self action:@selector(onFilterButton) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 60, 25);
    segmentedControl.momentary = YES;
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    //Search Bar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(80, 0, 100, 25)];
    //searchBar.showsCancelButton=YES;
    self.searchBar.placeholder = @"Thai";
    self.searchBar.delegate = self;
    //UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    //searchController.delegate= self;
    //searchController.searchResultsDataSource = self;
    //searchController.searchResultsDelegate = self;
    //searchController.displaysSearchBarInNavigationBar = YES;
    
    //Navigation Bar
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem =segmentBarItem;
     
    
    [self getData:@"Thai"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearDisplayController delegate methods
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
    tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    tableView.frame=CGRectZero;//This must be set to prevent the result tables being shown
    
}

#pragma mark - UITableView data source methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    NSLog(@"Yes %d",self.restaurantarray.count);
    return self.restaurantarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantTableViewCell"];
    [cell setRestaurant:self.restaurantarray[indexPath.row] index:indexPath.row];
    return cell;
}


#pragma mark - Search methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    return NO;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    NSLog(@"%@",searchBar.text);
    [self getData:searchBar.text];
    [self.restaurantTableView reloadData];
    
    
}




- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""] || searchText==nil) {
        NSLog(@"user tapped the 'clear' button");
        // user tapped the 'clear' button
        [bar resignFirstResponder];
        [self.view endEditing:YES];
        
    }
}

#pragma mark - Fiter 

- (void)onFilterButton {
    [self.navigationController pushViewController:[[FilterViewController alloc] init] animated:YES];
}



@end
