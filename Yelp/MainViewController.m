//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) NSString *term;

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
    // Do any additional setup after loading the view from its nib.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    
    // set background color for nav bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.80 green:0.11 blue:0.09 alpha:1.0]];
    // this did not work and instead crashed app, see http://stackoverflow.com/questions/19125468/why-does-uinavigationbar-appearance-settranslucentno-crash-my-app
//    [[UINavigationBar appearance] setTranslucent:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    // set text color for nav bar
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.0 green:0.93 blue:0.87 alpha:1.0]];
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.layer.masksToBounds = NO;
    filterButton.frame = CGRectMake(0, 0, 60, 30);
    filterButton.layer.cornerRadius = 8.0;
    filterButton.layer.borderWidth = 2.0;
    filterButton.layer.borderColor = [[UIColor colorWithRed:0.76 green:0.09 blue:0.07 alpha:1.0] CGColor];
    
    // button shadow
//    filterButton.layer.shadowColor = [[UIColor blackColor] CGColor];
//    filterButton.layer.shadowOffset = CGSizeMake(2.0, 2.0);
//    filterButton.layer.shadowRadius = 1.0;
//    filterButton.layer.shadowOpacity = 0.2;
//    filterButton.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:filterButton.layer.bounds cornerRadius:8.0].CGPath;
    
    // button gradient
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = filterButton.layer.bounds;
    gradientLayer.cornerRadius = 8.0;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.89 green:0.22 blue:0.16 alpha:1.0] CGColor],
                            (id)[[UIColor colorWithRed:0.78 green:0.12 blue:0.11 alpha:1.0] CGColor],
                            nil];
    [filterButton.layer insertSublayer:gradientLayer atIndex:0];
    
    filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    
    [filterButton addTarget:self action:@selector(showFilterView) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *filterButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    self.navigationItem.leftBarButtonItem = filterButtonItem;
    
    // an invisible/empty button as space holder so the search bar is of the right size
    UIBarButtonItem *invisibleButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = invisibleButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessTableViewCell"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.term = [defaults objectForKey:@"term"];
    if (!self.term) {
        self.term = @"thai";
    }
    searchBar.text = self.term;
    [self doSearch:self.term];
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.term = [defaults objectForKey:@"term"];
    if (!self.term) {
        self.term = @"thai";
    }
    [self doSearch:self.term];
}

- (void)showFilterView{
    NSLog(@"showing filter view");
    FilterViewController *fvc = [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"section=%d, row=%d", indexPath.section, indexPath.row);
    
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTableViewCell"];
    
    if (cell == nil) {
        cell = [[BusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessTableViewCell"];
    }
    
    NSDictionary *business = self.businesses[indexPath.row];
    
    // load image
    NSURL *imageURL = [NSURL URLWithString:business[@"image_url"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    // rounded corner with border and inner shadow
//    cell.businessImage.layer.shadowColor = [[UIColor grayColor] CGColor];
//    cell.businessImage.layer.shadowRadius = 10.0;
//    cell.businessImage.layer.shadowOpacity = 1.0;
//    cell.businessImage.layer.shadowOffset = CGSizeMake(0, 0);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.businessImage.bounds cornerRadius:10.0];
//    cell.businessImage.layer.shadowPath = path.CGPath;
    cell.businessImage.layer.cornerRadius = 10.0;
    cell.businessImage.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.businessImage.layer.borderWidth = 1.0;
    cell.businessImage.layer.masksToBounds = YES;
    [cell.businessImage setImageWithURL:imageURL placeholderImage:placeholderImage];
    
    
    // load start image
    NSURL *ratingImageURL = [NSURL URLWithString:business[@"rating_img_url"]];
    UIImage *defaultStarImage = [UIImage imageNamed:@"DefaultStars"];
    [cell.ratingImage setImageWithURL:ratingImageURL placeholderImage:defaultStarImage];
    
    // load text values
    
    // name
    cell.businessName.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, business[@"name"]];
    
    // review count
    cell.review.text = [NSString stringWithFormat:@"%@ Reviews", business[@"review_count"]];

    // address
    NSArray *addressArray = business[@"location"][@"display_address"];
    cell.address.text = [NSString stringWithFormat:@"%@, %@", addressArray[0], addressArray[1]];
    
    // categories is an array of arrays
    NSMutableString *categoriesString = [[NSMutableString alloc] init];
    NSArray *categories = business[@"categories"];
    NSInteger i = 0;
    for (NSArray *category in categories) {
        if (i != 0) {
            [categoriesString appendString:@", "];
        }
        [categoriesString appendString:category[0]];
        i++;
    }
    cell.categories.text = categoriesString;
    
    // distance, 1 meter = 0.000621371 mile
    float distanceInMile = [business[@"distance"] floatValue] * 0.000621371;
    cell.distance.text = [NSString stringWithFormat:@"%.1f mi", distanceInMile];
    
    // cost
    
    return cell;
}



#pragma mark UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // hide keyboard
    [searchBar resignFirstResponder];
    
    [self doSearch:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // hide keyboard
    [searchBar resignFirstResponder];
    
    [self doSearch:searchBar.text];
}

- (void)doSearch:(NSString *)term
{
    NSLog(@"search term: %@", term);
    
    // get filters from saved settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    
    NSString *radius = [defaults objectForKey:@"radius"];
    if (radius) {
        [filters setObject:radius forKey:@"radius"];
        NSLog(@"setting radius filter in search to %@", radius);
    }
    
    NSString *sort = [defaults objectForKey:@"sort"];
    if (sort) {
        [filters setObject:sort forKey:@"sort"];
        NSLog(@"setting sort filter in search to %@", sort);
    }
    
    NSString *deals = [defaults objectForKey:@"deals"];
    if (deals) {
        [filters setObject:deals forKey:@"deals"];
        NSLog(@"setting deals filter in search to %@", deals);
    }
    
    NSMutableDictionary *category = [defaults objectForKey:@"category"];
    if (category) {
        [filters setObject:category forKey:@"category"];
        NSLog(@"setting category filter in search to %@", category);
    }
    
    NSLog(@"filters set for search: %@", filters);
    
    [self.client searchWithTerm:term withFilters:filters success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        self.businesses = response[@"businesses"];
        [self.tableView reloadData];
        
        // save the search term to NSUserDefaults
        [defaults setObject:term forKey:@"term"];
        [defaults synchronize];
        NSLog(@"search term %@ saved to NSUserDefaults", term);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

@end
