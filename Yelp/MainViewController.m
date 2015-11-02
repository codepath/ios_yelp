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
@property (weak, nonatomic) IBOutlet UITableView *BusinessTableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Main view controller");
	self.BusinessTableView.delegate = self;
	self.BusinessTableView.dataSource = self;
	self.BusinessTableView.estimatedRowHeight = 100;
	self.BusinessTableView.rowHeight = UITableViewAutomaticDimension;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YelpBusinessTableViewCell *cell = [[YelpBusinessTableViewCell alloc] init];
	cell.NameLabel.text = @"business";
	cell.ReviewLabel.text = @"description";
	NSLog(@"cellforrowatindexpath");
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
