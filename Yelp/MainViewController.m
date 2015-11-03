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

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *BusinessTableView;
@property (nonatomic, strong) NSArray *businesses;
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
	
	[YelpBusiness searchWithTerm:@"Restaurants"
						sortMode:YelpSortModeBestMatched
					  categories:@[@"burgers"]
						   deals:NO
					  completion:^(NSArray *businesses, NSError *error) {
						  self.businesses = businesses;
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
	
	cell.BusinessLabel.text = @"business";
	cell.AddressLabel.text = @"address";
	//NSLog([NSString stringWithFormat: @"%ld", (long)self.businesses.count]);
	//NSLog(cell.BusinessLabel.text);
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
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
