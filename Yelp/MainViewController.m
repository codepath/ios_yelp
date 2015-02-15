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
#import <MapKit/MapKit.h>
#import "BusinessLocation.h"

NSString * const kYelpConsumerKey = @"UgcPymh8Mrzi96l3sxyr-w";
NSString * const kYelpConsumerSecret = @"vuYqZdxZiiYXqkOc7hYChJJ1s-8";
NSString * const kYelpToken = @"P3AepoF3ap3ceU_p5L7ia04gJ0pNzYYL";
NSString * const kYelpTokenSecret = @"rdIU15RaiP5N7zz-m-2YV4P1DHA";
NSString * const defaultSearchTerm = @"Restaurants";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSDictionary *region;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString* searchTerm;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL requestInFlight;
@property (nonatomic, assign) NSInteger activeView; // 0 = list, 1 = map

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

int offset = 0;

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
    
    // configure table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 86;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];

    // navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:196/255.0f green:18/255.0f blue:0/255.0f alpha:1.0f];
    
    // filter button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map"] style:UIBarButtonItemStylePlain target:self action:@selector(onToggleView)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.activeView = 0;
    
    // search bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.searchTerm = searchBar.text = defaultSearchTerm;
    
    // progress hud
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]];
    
    // infinite loading
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;
    tableFooterView.hidden = YES;

    
    // map view
    self.mapView.delegate = self;
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.businesses.count - 1 && self.businesses.count < self.totalCount) {
        [self fetchMoreBusinesses];
    }
    
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

#pragma mark - Map view delegate methods
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    if ([annotation isKindOfClass:[BusinessLocation class]]) {
//        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"BusinessLocation"];
//        
//        if (annotationView == nil) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BusinessLocation"];
//            annotationView.enabled = YES;
//            annotationView.canShowCallout = YES;
//            annotationView.image = [UIImage imageNamed:@"filter"];
//        } else {
//            annotationView.annotation = annotation;
//        }
//        
//        return annotationView;
//    }
//    return nil;
//}


#pragma mark - Private methods

-(void)fetchBusinesses {
    [self fetchBusinessesWithQuery:self.searchTerm params:self.filters];
}

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [SVProgressHUD show];
    self.requestInFlight = YES;
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        NSArray *businessesDictionaries = response[@"businesses"];
        self.totalCount = [response[@"total"] integerValue];
        
        self.businesses = [Business businessesWithDictionaries:businessesDictionaries startingAtOffset:0];
        self.region = response[@"region"];
        [self plotPointsOnMap];

        [self showOrHideTableFooter];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        self.requestInFlight = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        self.requestInFlight = NO;
    }];
}

-(void)fetchMoreBusinesses {
    if (self.requestInFlight) {
        return;
    }
    
    NSMutableDictionary *filtersWithOffset = [NSMutableDictionary dictionaryWithDictionary:self.filters];
    filtersWithOffset[@"offset"] = @(self.businesses.count);
    
    self.requestInFlight = YES;
    [self.client searchWithTerm:self.searchTerm params:filtersWithOffset success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *businessesDictionaries = response[@"businesses"];
        self.totalCount = [response[@"total"] integerValue];
        
        NSArray *businesses = [Business businessesWithDictionaries:businessesDictionaries startingAtOffset:(int)self.businesses.count];
        NSMutableArray *merged = [NSMutableArray arrayWithArray:self.businesses];
        [merged addObjectsFromArray:businesses];
        
        self.businesses = merged;
        self.region = response[@"region"];
        [self plotPointsOnMap];

        [self showOrHideTableFooter];
        [self.tableView reloadData];
        
        self.requestInFlight = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.requestInFlight = NO;
    }];
    
}

-(void)showOrHideTableFooter {
    if (self.businesses.count < self.totalCount) {
        self.tableView.tableFooterView.hidden = NO;
    } else {
        self.tableView.tableFooterView.hidden = YES;
    }
}

-(void)onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    vc.delegate = self;
    
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)onToggleView {
    if (self.activeView == 0) { // list
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"list"]];
        self.activeView = 1;
        self.mapView.hidden = false;
        self.tableView.hidden = true;
        
    } else if(self.activeView == 1) { // map

        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"map"]];
        self.activeView = 0;
        self.mapView.hidden = true;
        self.tableView.hidden = false;
    }
}

-(void)plotPointsOnMap {
    // center map
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[self.region valueForKeyPath:@"center.latitude"] floatValue];
    zoomLocation.longitude = [[self.region valueForKeyPath:@"center.longitude"] floatValue];
    CLLocationDegrees latitudeDelta = [[self.region valueForKeyPath:@"span.latitude_delta"] floatValue];
    CLLocationDegrees longitudeDelta = [[self.region valueForKeyPath:@"span.longitude_delta"] floatValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, MKCoordinateSpanMake(latitudeDelta, longitudeDelta));
    
    [self.mapView setRegion:viewRegion animated:YES];
    
    // clear old pins
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    // add new pins
    for (Business* business in self.businesses) {
        BusinessLocation *annotation = [[BusinessLocation alloc] initWithBusiness:business];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:annotation];
        });
    }
    
}


@end
