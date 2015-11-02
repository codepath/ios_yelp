//
//  MainViewController.m
//  Yelp
//
//  Created by Alex Lester on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "YelpBusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Main view controller");
	//self.businesses.delegate = self;
	//self.businesses.dataSource = self;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YelpBusinessTableViewCell *cell = [self.TableView dequeueReusableCellWithIdentifier:@"repoInfo"];
	
	YelpBusiness *business = self.businesses[indexPath.row];
	cell.NameLabel.text = business.name;
	cell.StarLabel.text = @"Stars";
	cell.NumberOfStarsLabel.text = @"undef.";
	cell.ReviewLabel.text = business.description;
	cell.NumberOfReviewsLabel.text = business.reviewCount;
	cell.AddressLabel.text = business.address;
	cell.GenreLabel.text = business.categories;
	[cell.businessImage setImageWithURL:[NSURL URLWithString:business.imageUrl]];
	return cell;
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
