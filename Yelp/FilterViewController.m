//
//  FilterViewController.m
//  Yelp
//
//  Created by Bharti Agrawal on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger collapseSectionIndex;
@property (strong, nonatomic) NSArray *categoryKeys;
@property (strong, nonatomic) NSArray *sortKeys;
@property (strong, nonatomic) NSArray *radiusKeys;
@property (strong, nonatomic) NSArray *dealKeys;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Filters";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //load keys
    NSArray *categoryKeys = @[
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
    
    self.sortKeys = @{@"name": @"best match",@"value": @"bestmatch"},
            @{@"name": @"distance", @"value": @"distance"},
            @{@"name": @"highest rated", @"value": @"highestrated"};
    self.radiusKeys = @{@"name":@"meters", @"value":@"meters"};
    self.dealKeys = @{@"name":@"on", @"value":@"on"},
                    @{@"name":@"off", @"value":@"off"};
    
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.collapseSectionIndex == section)
        return 1;
    else if (section == 0)
        return self.categoryKeys.count;
    else if (section ==1)
        return self.sortKeys.count;
    else if (section == 2)
        return self.radiusKeys.count;
    else if (section == 3)
        return self.dealKeys.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSLog(@"section: %d, row: %d", indexPath.section, indexPath.row);
    
    if (indexPath.section == 0)
        cell.textLabel.text = self.categoryKeys[indexPath.row];
    else if (indexPath.section == 1)
        cell.textLabel.text = self.sortKeys[indexPath.row];
    else if (indexPath.section == 2)
        cell.textLabel.text = self.radiusKeys[indexPath.row];
    else if (indexPath.section == 3)
        cell.textLabel.text = self.dealKeys[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    headerView.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    
    NSLog(@"in title for header in section %d",section);
    if (section == 1)
        return @"Categories";
    else if (section == 2)
        return @"Sort By";
    else if (section == 3)
        return @"Radius";
    else if (section == 4)
        return @"Deals";
    return @"Section";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.categoryKeys.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int previousCollapseSectionIndex = self.collapseSectionIndex;
    self.collapseSectionIndex = indexPath.section;
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:previousCollapseSectionIndex];
    
    [indexSet addIndex:self.collapseSectionIndex];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
   // [tableView reloadData];
}

@end
