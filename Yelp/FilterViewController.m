//
//  FilterViewController.m
//  Yelp
//
//  Created by Paritosh Aggarwal on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, FilterTableViewCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (weak, nonatomic) IBOutlet UIPickerView *sortByPicker;
@property (nonatomic, strong) NSArray *_pickerData;
@property (weak, nonatomic) IBOutlet UISwitch *dealsSwitch;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;

- (void)initCategories;
@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibBundleOrNil bundle:nibBundleOrNil];
  if (self) {
    self.selectedCategories = [[NSMutableSet alloc] init];
    [self initCategories];
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
  
  self.filterTableView.dataSource = self;
  self.filterTableView.delegate = self;
  [self.filterTableView registerNib:[UINib nibWithNibName:@"FilterTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"FilterTableViewCell"];
  
  self.sortByPicker.dataSource = self;
  self.sortByPicker.delegate = self;
  self._pickerData = @[@"Best Match", @"Distance", @"Highest Rated"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FilterTableViewCell *cell = [self.filterTableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell"];
  cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
  cell.delegate = self;
  cell.filterLabel.text = self.categories[indexPath.row][@"title"];
  return cell;
}

#pragma mark - Filter cell methods
- (void)filterCell:(FilterTableViewCell *)cell didUpdateValue:(BOOL)value {
  NSIndexPath *indexPath = [self.filterTableView indexPathForCell:cell];
  if (value) {
    [self.selectedCategories addObject:self.categories[indexPath.row]];
  } else {
    [self.selectedCategories removeObject:self.categories[indexPath.row]];
  }
}

#pragma mark - Sort by picker methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self._pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return self._pickerData[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private methods

- (NSDictionary *)filters {
  NSMutableDictionary *filters = [NSMutableDictionary dictionary];
  if (self.selectedCategories.count > 0) {
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *category in self.selectedCategories) {
      if (category[@"code"]) {
        [names addObject:category[@"code"]];
      }
    }
    NSString *categoryFilter = [names componentsJoinedByString:@","];
    [filters setObject:categoryFilter forKey:@"category_filter"];
  }
  NSInteger row = [self.sortByPicker selectedRowInComponent:0];
  [filters setObject:[NSString stringWithFormat:@"%ld", (long)row] forKey:@"sort"];
  
  BOOL isDealsOn = [self.dealsSwitch isOn];
  [filters setObject:[NSString stringWithFormat:@"%s", isDealsOn ? "true": "false"] forKey:@"deals_filter"];
  NSInteger distanceFilter = [self.distanceTextField.text intValue];
  [filters setObject:[NSString stringWithFormat:@"%ld", distanceFilter] forKey:@"radius_filter"];

  return filters;
}

- (void)onCancelButton {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
  [self.delegate filterViewController:self didChangeFilters:self.filters];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategories {
    self.categories = @[
    @{
      @"alias": @"bagels",
      @"title": @"Bagels"
    },
    @{
     
     @"alias":@"bakeries",
     @"title":@"Bakeries"
    },
   @{
     
     @"alias":@"beer_and_wine",
     @"title":@"Beer, Wine & Spirits"
    },
   @{
     
     @"alias":@"breweries",
     @"title":@"Breweries"
    },
   @{
     
     @"alias":@"butcher",
     @"title":@"Butcher"
    },
   @{
     
     @"alias":@"coffee",
     @"title":@"Coffee & Tea"
    },
   @{
     
     @"alias":@"convenience",
     @"title":@"Convenience Stores"
    },
   @{
     
     @"alias":@"desserts",
     @"title":@"Desserts"
    },
   @{
     
     @"alias":@"diyfood",
     @"title":@"Do-It-Yourself Food"
    },
   @{
     
     @"alias":@"donuts",
     @"title":@"Donuts"
    },
   @{
     
     @"alias":@"farmersmarket",
     @"title":@"Farmers Market"
    },
   @{
     
     @"alias":@"fooddeliveryservices",
     @"title":@"Food Delivery Services"
    },
   @{
     
     @"alias":@"grocery",
     @"title":@"Grocery"
    },
   @{
     
     @"alias":@"icecream",
     @"title":@"Ice Cream & Frozen Yogurt"
    },
   @{
     
     @"alias":@"internetcafe",
     @"title":@"Internet Cafes"
    },
   @{
     
     @"alias":@"juicebars",
     @"title":@"Juice Bars & Smoothies"
    },

     @{
       
       @"alias":@"candy",
       @"title":@"Candy Stores"
      },
     @{
       
       @"alias":@"cheese",
       @"title":@"Cheese Shops"
      },
     @{
       
       @"alias":@"chocolate",
       @"title":@"Chocolatiers and Shops"
      },
     @{
       
       @"alias":@"ethnicmarkets",
       @"title":@"Ethnic Food"
      },
     @{
       
       @"alias":@"markets",
       @"title":@"Fruits & Veggies"
      },
     @{
       
       @"alias":@"healthmarkets",
       @"title":@"Health Markets"
      },
     @{
       
       @"alias":@"herbsandspices",
       @"title":@"Herbs and Spices"
      },
     @{
       
       @"alias":@"meats",
       @"title":@"Meat Shops"
      },
     @{
       
       @"alias":@"seafoodmarkets",
       @"title":@"Seafood Markets"
      },
   @{
     
     @"alias":@"streetvendors",
     @"title":@"Street Vendors"
    },
   @{
     
     @"alias":@"tea",
     @"title":@"Tea Rooms"
    },
   @{
     
     @"alias":@"wineries",
     @"title":@"Wineries"
    }];
  
}

@end
