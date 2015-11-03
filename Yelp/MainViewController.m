//
//  MainViewController.m
//  Yelp
//
//  Created by Alex Lester on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "YelpClient.h"
#import "YelpBusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *BusinessTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSArray *filteredData;
@property (nonatomic, strong) YelpClient *client;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	
	NSLog(@"Main view controller");
	self.BusinessTableView.delegate = self;
	self.BusinessTableView.dataSource = self;
	self.BusinessTableView.estimatedRowHeight = 100;
	self.BusinessTableView.rowHeight = UITableViewAutomaticDimension;
	//search bar stuffs
	self.searchBar = [[UISearchBar alloc] init];
	self.searchBar.delegate = self;
	[self.searchBar sizeToFit];
	self.navigationItem.titleView = self.searchBar;
	[self doSearch];
	
	
}

- (void)doSearch {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[YelpBusiness searchWithTerm:self.searchBar.text
						sortMode:YelpSortModeBestMatched
					  categories:@[@"burgers"]
						   deals:NO
					  completion:^(NSArray *businesses, NSError *error) {
						  self.businesses = businesses;
						  [MBProgressHUD hideHUDForView:self.view animated:YES];
						  [self.BusinessTableView reloadData];
					  }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YelpBusinessTableViewCell *cell = [self.BusinessTableView dequeueReusableCellWithIdentifier:@"businessInfo"];
	if (!cell) {
		cell = [[YelpBusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"businessInfo"];
	}
	
	YelpBusiness *biz = self.businesses[indexPath.row];
	[cell.thumbImageView setImageWithURL:biz.imageUrl];
	cell.BusinessLabel.text = biz.name;
	[cell.ratingIMageView setImageWithURL:biz.ratingImageUrl];
	cell.numberReviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews", biz.reviewCount];
	cell.AddressLabel.text = biz.address;
	cell.distanceLabel.text = [NSString stringWithFormat:@"%@", biz.distance];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.businesses.count;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[self.searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	[self.searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	//self.searchSettings.searchString = searchBar.text;
	[searchBar resignFirstResponder];
	[self doSearch];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
