//
//  FilterViewController.m
//  Yelp
//
//  Created by Guozheng Ge on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *filters;
@property (strong, nonatomic) NSArray *categories;

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
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    // init filters
    self.filters = @{
                     @"categories": @[],
                     @"sort": @"",
                     @"radius": @"",
                     @"deals":@""
                     };
    
    self.categories = @[
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
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"num of sections: %d", [self.filters count]);
    return [self.filters count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section: %d", section);
    
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"foo";
    return cell;
}

@end
