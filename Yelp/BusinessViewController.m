//
//  BusinessViewController.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessViewController.h"
#import "DetailsCell.h"
#import "UIImageView+AFNetworking.h"
#import "BusinessLocation.h"
#import "UIScrollView+APParallaxHeader.h"

@interface BusinessViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 426; // parallax somehow doesn't work with automatic height :(
    self.tableView.estimatedRowHeight = 426;
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsCell" bundle:nil] forCellReuseIdentifier:@"DetailsCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // parallax
    
    UIImageView *placeholderView = [[UIImageView alloc] init];
    placeholderView.contentMode = UIViewContentModeScaleAspectFill;
    NSURLRequest *placeholderRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.business.imageUrl]];
    

    [placeholderView setImageWithURLRequest:placeholderRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *placeholderImage) {

        UIImageView *posterView = [[UIImageView alloc] init];
        posterView.contentMode = UIViewContentModeScaleAspectFill;
        NSURLRequest *posterRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.business.imageUrlLarge]];
        [posterView setImageWithURLRequest:posterRequest placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [self.tableView addParallaxWithImage:image andHeight:150.];
            // HACK to fix the parallax offset (weird)
            self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    

    
    
    // navigation
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    cell.nameLabel.text = self.business.name;
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    cell.addressLabel.text = self.business.address;
    cell.categoriesLabel.text = self.business.categories;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", self.business.distance];
    cell.phoneLabel.text = self.business.phone;
    
    // map view
    // center map
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.business.latitude;
    zoomLocation.longitude = self.business.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.1*1609.34449789 /*meters per mile*/, 0.1*1609.34449789 /*meters per mile*/);
    
    [cell.mapView setRegion:viewRegion animated:NO];
    
    // clear old pins
    for (id<MKAnnotation> annotation in cell.mapView.annotations) {
        [cell.mapView removeAnnotation:annotation];
    }
    
    // add new pin
    BusinessLocation *annotation = [[BusinessLocation alloc] initWithBusiness:self.business];
    [cell.mapView addAnnotation:annotation];
    
    return cell;
}

@end
