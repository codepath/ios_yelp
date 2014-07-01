//
//  FilterViewController.m
//  Yelp
//
//  Created by Harsha Badami Nagaraj on 6/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDictionary *deals = @{
                                @"options":@[@"Offering Deals"],
                                @"values":@[@"false"]
                                };
        NSDictionary *sorts = @{
                                     @"options":@[@"Best Match", @"Distance",@"Rating"],
                                     @"values":@[@"0",@"1",@"2"]
                                     };
        NSDictionary *radius = @{
                                             @"options":@[@"5000 meters", @"10000 meters",@"15000 meters",@"25000 meters"],
                                             @"values":@[@"5000",@"10000",@"15000",@"25000"]
                                             };
        NSDictionary *categories = @{
                                         @"options":@[@"Vegan", @"Vegetarian", @"Indian", @"Thai", @"Mexican", @"Mediterranean", @"All Restaurants"],
                                         @"values":@[@"vegan", @"vegetarian", @"indpak", @"thai", @"mexican", @"mediterranean", @"restaurants"]
                                         };
        
        self.filters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                       @"deals_filter" : deals,
                                                                       @"sort" : sorts,
                                                                       @"radius_filter" : radius,
                                                                       @"category_filter" : categories
                                                         }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.text = @"Filters";
    label.font = [UIFont boldSystemFontOfSize:20.0];
    self.navigationItem.titleView = label;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(popView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Search Button
-(void) switchView {
    [self.delegate propagateFilters:self];
    [self.navigationController popViewControllerAnimated:YES];
}

//Cancel Button
-(void) popView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.filters allKeys];
    //NSString *selectedOption = [self.selectedValues objectForKey:sectionArray[section]];
        
    /*if ([selectedOption length] != 0) {
        return 1;
    }*/
    
    return [[self.filters objectForKey:sectionArray[section]][@"options"] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sections = [self.filters allKeys];
    return sections[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.filters count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = [self.filters allKeys];
    NSDictionary *sectionOptions = [self.filters objectForKey:sectionArray[indexPath.section]];
    NSArray *options = sectionOptions[@"options"];
    NSArray *values = sectionOptions[@"values"];
    
    UITableViewCell *cell = [[UITableViewCell  alloc]init];
    cell.textLabel.text = options[indexPath.row];
    NSString *selectedValue = values[indexPath.row];
    
    if([cell.textLabel.text isEqual: @"Offering Deals"])
    {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        if ([self.selectedValues[@"deals_filter"] isEqualToString:@"1"]) {
            [switchView setOn:YES animated:NO];
        } else {
            [switchView setOn:NO animated:NO];
        }
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    } else {
        cell.accessoryView = NULL;
    }
    
    if ([selectedValue isEqualToString:[self.selectedValues objectForKey:sectionArray[indexPath.section]]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *sectionArray = [self.filters allKeys];
    NSDictionary *sectionOptions = [self.filters objectForKey:sectionArray[indexPath.section]];
    NSArray *values = sectionOptions[@"values"];
    
    if ([sectionArray[indexPath.section] isEqualToString: @"deals_filter"]) {
        return;
    } else {
        [self.selectedValues setObject:values[indexPath.row] forKey:sectionArray[indexPath.section]];
    }
    
    [tableView reloadData];
}


-(void)switchChanged: (id) sender {
    if ([self.selectedValues[@"deals_filter"] isEqualToString:@"0"]) {
        [self.selectedValues setObject:@"1" forKey:@"deals_filter"];
    } else {
        [self.selectedValues setObject:@"0" forKey:@"deals_filter"];
    }
}

@end
