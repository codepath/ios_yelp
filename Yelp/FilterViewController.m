//
//  FilterViewController.m
//  Yelp
//
//  Created by Guozheng Ge on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "FilterTableViewCellWithPicker.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *filterNames;
@property (strong, nonatomic) NSArray *categoryDefs;

@property (strong, nonatomic) NSString *radius;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *deals;
@property (strong, nonatomic) NSMutableDictionary *catetory;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FilterTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FilterTableViewCellWithPicker" bundle:nil] forCellReuseIdentifier:@"FilterTableViewCellWithPicker"];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.80 green:0.11 blue:0.09 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:1.0 green:0.93 blue:0.87 alpha:1.0]];
    
    // cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.masksToBounds = NO;
    cancelButton.frame = CGRectMake(0, 0, 60, 30);
    cancelButton.layer.cornerRadius = 8.0;
    cancelButton.layer.borderWidth = 2.0;
    cancelButton.layer.borderColor = [[UIColor colorWithRed:0.76 green:0.09 blue:0.07 alpha:1.0] CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = cancelButton.layer.bounds;
    gradientLayer.cornerRadius = 8.0;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.89 green:0.22 blue:0.16 alpha:1.0] CGColor],
                            (id)[[UIColor colorWithRed:0.78 green:0.12 blue:0.11 alpha:1.0] CGColor],
                            nil];
    [cancelButton.layer insertSublayer:gradientLayer atIndex:0];
    
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelFilters:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    // search button
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.layer.masksToBounds = NO;
    searchButton.frame = CGRectMake(0, 0, 60, 30);
    searchButton.layer.cornerRadius = 8.0;
    searchButton.layer.borderWidth = 2.0;
    searchButton.layer.borderColor = [[UIColor colorWithRed:0.76 green:0.09 blue:0.07 alpha:1.0] CGColor];
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = searchButton.layer.bounds;
    gradientLayer2.cornerRadius = 8.0;
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.89 green:0.22 blue:0.16 alpha:1.0] CGColor],
                            (id)[[UIColor colorWithRed:0.78 green:0.12 blue:0.11 alpha:1.0] CGColor],
                            nil];
    [searchButton.layer insertSublayer:gradientLayer2 atIndex:0];
    
    searchButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(setFilters:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    // restore values from NSUserDefaults to initialize filters
    [self restoreFilters];
    
    self.filterNames = @[@"Radius", @"Sort", @"Deals", @"Category"];
    
    self.categoryDefs = @[
      @{@"name": @"American (New)", @"value": @"newamerican"},
      @{@"name": @"American (Traditional)", @"value": @"tradamerican"},
      @{@"name": @"Argentine", @"value": @"argentine"},
      @{@"name": @"Asian Fusion", @"value": @"asianfusion"},
      @{@"name": @"Australian", @"value": @"australian"},
      @{@"name": @"Austrian", @"value": @"austrian"},
      @{@"name": @"Beer Garden", @"value": @"beergarden"},
      @{@"name": @"Belgian", @"value": @"belgian"},
      @{@"name": @"Brazilian", @"value": @"brazilian"},
      @{@"name": @"Breakfast & Brunch", @"value": @"breakfast_brunch"},
      @{@"name": @"Buffets", @"value": @"buffets"},
      @{@"name": @"Burgers", @"value": @"burgers"},
      @{@"name": @"Burmese", @"value": @"burmese"},
      @{@"name": @"Cafes", @"value": @"cafes"},
      @{@"name": @"Cajun/Creole", @"value": @"cajun"},
      @{@"name": @"Canadian", @"value": @"newcanadian"},
      @{@"name": @"Chinese", @"value": @"chinese"},
      @{@"name": @"Cantonese", @"value": @"cantonese"},
      @{@"name": @"Dim Sum", @"value": @"dimsum"},
      @{@"name": @"Cuban", @"value": @"cuban"},
      @{@"name": @"Diners", @"value": @"diners"},
      @{@"name": @"Dumplings", @"value": @"dumplings"},
      @{@"name": @"Ethiopian", @"value": @"ethiopian"},
      @{@"name": @"Fast Food", @"value": @"hotdogs"},
      @{@"name": @"French", @"value": @"french"},
      @{@"name": @"German", @"value": @"german"},
      @{@"name": @"Greek", @"value": @"greek"},
      @{@"name": @"Indian", @"value": @"indpak"},
      @{@"name": @"Indonesian", @"value": @"indonesian"},
      @{@"name": @"Irish", @"value": @"irish"},
      @{@"name": @"Italian", @"value": @"italian"},
      @{@"name": @"Japanese", @"value": @"japanese"},
      @{@"name": @"Jewish", @"value": @"jewish"},
      @{@"name": @"Korean", @"value": @"korean"},
      @{@"name": @"Venezuelan", @"value": @"venezuelan"},
      @{@"name": @"Malaysian", @"value": @"malaysian"},
      @{@"name": @"Pizza", @"value": @"pizza"},
      @{@"name": @"Russian", @"value": @"russian"},
      @{@"name": @"Salad", @"value": @"salad"},
      @{@"name": @"Scandinavian", @"value": @"scandinavian"},
      @{@"name": @"Seafood", @"value": @"seafood"},
      @{@"name": @"Turkish", @"value": @"turkish"},
      @{@"name": @"Vegan", @"value": @"vegan"},
      @{@"name": @"Vegetarian", @"value": @"vegetarian"},
      @{@"name": @"Vietnamese", @"value": @"vietnamese"}
      ];
    
    NSLog(@"view did load done");
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"num of sections: %d", [self.filterNames count]);
    return [self.filterNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"section: %d", section);
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return [self.categoryDefs count];
            break;
            
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.filterNames[section];
}

// By default, the section titles are in UPPER caes,
// to show the section titles in the case you need, but the height is not
// automatically adjusted
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    static NSString *identifier = @"defaultHeader";
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
//    if (!headerView) {
//        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
//    }
//    headerView.textLabel.text = self.filtersNames[section];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"section=%d, row=%d", indexPath.section, indexPath.row);
    
    if (indexPath.section == 0) {
        // radius
        
        FilterTableViewCellWithPicker *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCellWithPicker"];
        
        if (cell == nil) {
            cell = [[FilterTableViewCellWithPicker alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterTableViewCellWithPicker"];
        }
        
        cell.label.text = @"Radius (meters)";
        cell.value.text = self.radius;
        cell.value.tag = 0;
        cell.value.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        // sort
        
        FilterTableViewCellWithPicker *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCellWithPicker"];
        
        if (cell == nil) {
            cell = [[FilterTableViewCellWithPicker alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterTableViewCellWithPicker"];
        }
        
        cell.label.text = @"Sort";
        cell.value.text = self.sort;
        cell.value.tag = 1;
        cell.value.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == 2) {
        // deals
        
        FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell"];
        
        if (cell == nil) {
            cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterTableViewCell"];
        }
        cell.label.text = @"Deals";
        cell.filterSwitch.tag = [self.categoryDefs count];
        [cell.filterSwitch addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.filterSwitch setOn:[self.deals isEqualToString:@"YES"] animated:YES];
        
        return cell;
        
    } else if (indexPath.section == 3) {
        // category
        
        FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell"];
        
        if (cell == nil) {
            cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterTableViewCell"];
        }
        
        cell.label.text = [self.categoryDefs objectAtIndex:indexPath.row][@"name"];
        cell.filterSwitch.tag = indexPath.row;
        [cell.filterSwitch addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        NSString *key = [self.categoryDefs objectAtIndex:indexPath.row][@"value"];
        BOOL isOn = [self.catetory[key] isEqualToString:@"YES"];
        [cell.filterSwitch setOn:isOn animated:YES];
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

// restore values from NSUserDefaults
- (void)restoreFilters
{
    NSLog(@"restoring filters from saved values");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *radius = [defaults objectForKey:@"radius"];
    self.radius = (radius) ? radius : @"";
    NSLog(@"radius restored to %@", self.radius);
    
    NSString *sort = [defaults objectForKey:@"sort"];
    self.sort = (sort) ? sort : @"";
    NSLog(@"sort restored to %@", self.sort);
    
    NSString *deals = [defaults objectForKey:@"deals"];
    self.deals = (deals) ? deals : @"NO";
    NSLog(@"deals restored to %@", self.deals);
    
    NSMutableDictionary *category = [defaults objectForKey:@"category"];
    self.catetory = (category) ? category : [@{} mutableCopy];
    NSLog(@"category restored to %@", self.catetory);
    
    NSLog(@"filters restored from user defaults");
}

// handle UISwitch events
- (void)setSwitch:(UISwitch *)sender
{
    if (sender){
        BOOL isOn = [sender isOn];
        if (sender.tag == [self.categoryDefs count]) {
            // handle set deals
            NSLog(@"change deals state: %d", isOn);
            self.deals = (isOn) ? @"YES" : @"NO";
            
        } else {
            // handle set categories
            NSString *key = self.categoryDefs[sender.tag][@"value"];
            NSLog(@"change category state: %d, tag: %d, category: %@", isOn, sender.tag, key);
            [self.catetory setObject:(isOn) ? @"YES" : @"NO" forKey:key];
        }
    }
}

// handle cancel filter changes
- (void)cancelFilters:(UIButton *)sender
{
    NSLog(@"cancel filter button pressed");
    [self restoreFilters];
    [self.tableView reloadData];
}


// handle update filters and search
- (void)setFilters:(UIButton *)sender
{
    NSLog(@"update filter button pressed");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.radius forKey:@"radius"];
    [defaults setObject:self.sort forKey:@"sort"];
    [defaults setObject:self.deals forKey:@"deals"];
    [defaults setObject:self.catetory forKey:@"category"];
    [defaults synchronize];
    NSLog(@"user defaults saved");
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        // radius
        NSLog(@"text field for radius set to value: %@", textField.text);
        self.radius = textField.text;
        
    } else if (textField.tag == 1) {
        // sort
        NSLog(@"text field for sort set to value: %@", textField.text);
        self.sort = textField.text;
        
    } else {
        NSLog(@"unknown text field, value: %@", textField.text);
    }
}

@end
