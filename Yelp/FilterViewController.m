//
//  FilterViewController.m
//  Yelp
//
//  Created by Sharad Ganapathy on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "MainViewController.h"
#import "DealTableViewCell.h"
#import "SortTableViewCell.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong,nonatomic) NSMutableDictionary *toggleSection;
@property (strong,nonatomic) NSArray *sortbyArrayLabel;
@property (strong,nonatomic) NSDictionary *radiusDict;
@property (strong,nonatomic) NSArray *radiusArray;
@property (strong,nonatomic) NSArray *categoriesArray;


@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Filters";
        
        self.toggleSection = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"false",@"1",@"false",@"2",@"false",@"3",nil];
        
        self.sortbyArrayLabel = [[NSArray alloc]initWithObjects:@"Best Match",@"Distance",@"Rating",nil];
        self.radiusDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"805",@"0.5 miles",@"1609" ,@"1 miles",@"8046",@"5 miles",@"32187",@"20 miles",nil];
        self.radiusArray = [[NSArray alloc]initWithObjects:@"0.5 miles",@"1 miles",@"5 miles",@"20 miles", nil];
        
        
        self.categoriesArray = @[
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //Search Button
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Search", nil]];
    [segmentedControl addTarget:self action:@selector(onSearchButton) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 60, 25);
    segmentedControl.momentary = YES;
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    
    
  
    
    /*
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //self.navigationController.navigationBar.translucent = NO;
     */
    self.navigationItem.rightBarButtonItem =segmentBarItem;
    
    
    
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    
    
    [self.filterTableView registerNib:[UINib nibWithNibName:@"DealTableViewCell" bundle:nil] forCellReuseIdentifier:@"DealTableViewCell"];
    [self.filterTableView registerNib:[UINib nibWithNibName:@"SortTableViewCell" bundle:nil] forCellReuseIdentifier:@"SortTableViewCell"];
    
    
    [self.filterTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark - table view source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


-(BOOL)getToggleStateForSection:(int)section {
    
    NSString * val = [self.toggleSection objectForKey:[NSString stringWithFormat:@"%d",section]];
    
    NSLog(@"Section %d Value :%@",section,val);
    
    if ([val isEqualToString:@"true"]){
        return TRUE;
    }
    else {
        return FALSE;
    }
}

-(void)setToggleStateForSection:(int)section {
    
    NSString * val = [self.toggleSection objectForKey:[NSString stringWithFormat:@"%d",section]];
    
    NSString * state ;
    
    if ([val isEqualToString:@"true"]){
        state = @"false";
    }
    else {
        state = @"true";
    }
    
    //NSLog(@"Prev State : %@ Setting %@ state for section %d for key %@", val,state,section,key);
    
    [self.toggleSection setObject:state forKey:[NSString stringWithFormat:@"%d",section]];
    
    //  NSLog(@"Prev State : %@ Setting %@ state for section %d for key %@", val,state,section,key);
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
            
        case 0 :
            return 1;
            break;
        case 1 :
            if ([self getToggleStateForSection:1]) {
                return 3;
            }else {
                return 1;
            }
            break;
        case 2 :
            if ([self getToggleStateForSection:2]) {
                return 4;
            }else {
                return 1;
            }
            break;
        case 3 :
            
            if ([self getToggleStateForSection:3]) {
                return self.categoriesArray.count;
            }else {
                return 3;
            }
            break;
        default:
            return 2;
            break;
            
            
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            DealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealTableViewCell"];
            BOOL switch_on = FALSE;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *deals_filter = [defaults objectForKey:@"deals_filter"];
            
            if ([deals_filter isEqualToString:@"true"]){
                switch_on = TRUE;
            }
            
            [cell.dealSwitch setOn:switch_on animated:YES];
            return cell;
        }
            break;
            
        case 1 : {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            if( ! [self getToggleStateForSection:1]){
                
                cell.textLabel.text = self.sortbyArrayLabel[ [(NSNumber *)[self getFilterSettings:@"sort_opt"] intValue]]            ;}else {
                    cell.textLabel.text = self.sortbyArrayLabel[indexPath.row];
                }
            return cell;
            
        }
            break;
        case 2 : {
            
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            if( ! [self getToggleStateForSection:2]){
               // cell.textLabel.text = self.radiusArray[ [[self getFilterSettings:@"radius_opt"] intValue]];
                cell.textLabel.text = self.radiusArray[ [ (NSNumber *)[self getFilterSettings:@"radius_opt"] intValue]];
                
                
            } else {
                cell.textLabel.text = self.radiusArray[indexPath.row];
            }
            return cell;
            
            
        }
            break;
            
        case 3: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSDictionary *catDict = self.categoriesArray[indexPath.row];
            //NSArray *keyArr = [catDict allKeys];
            NSMutableArray *category_selected = (NSMutableArray *)[self getFilterSettings:@"categories_selected"];
            
            if (! [self getToggleStateForSection:3]) {
                cell.textLabel.text = [catDict objectForKey:@"value"];
                if (indexPath.row == 2) {
                    cell.textLabel.text = @"See More";
                }
                
            } else {
                cell.textLabel.text = [catDict objectForKey:@"value"];
            }
            
            if ( [category_selected containsObject: [NSNumber numberWithInt:indexPath.row ]] ) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
            
            return cell;
            
        }
            break;
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"Section %d row %d", indexPath.section, indexPath.row];
            return cell;
        }
            break;
    }
    
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        case 0 :
            return @"Deals";
            break;
        case 1 :
            return @"SortBy";
            break;
        case 2 :
            return @"Distance";
            break;
        case 3 :
            return @"Categories";
            break;
            
        default:
            return @"hehe";
            break;
            
            
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"Inside didSelectRow");
    
    
    if (indexPath.section  == 1) {
        NSString *sortValue = [NSString stringWithFormat:@"%d",indexPath.row];
        [self setFilterSettings:@"sort" value:sortValue];
        //[self setFilterSettings:@"sort_opt" value:[NSString stringWithFormat:@"%d",indexPath.row]];
        [self setFilterSettings:@"sort_opt" value:[NSNumber numberWithInt:indexPath.row]];
    }
    if (indexPath.section == 2 ) {
        
        NSString *radius = [self.radiusDict objectForKey:self.radiusArray[indexPath.row]];
        [self setFilterSettings:@"radius_filter" value:radius];
        //[self setFilterSettings:@"radius_opt" value:[NSString stringWithFormat:@"%d",indexPath.row]];
        [self setFilterSettings:@"radius_opt" value:[NSNumber numberWithInt:indexPath.row]];
    }
    
    if (indexPath.section == 3 ) {
        
        NSMutableArray *selectedIndexes = [[NSMutableArray alloc]init];
        NSMutableArray *selectedCategories = [[NSMutableArray alloc]init];
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if ([selectedCell accessoryType] == UITableViewCellAccessoryNone && indexPath.row != 2) {
            NSLog(@"Checking");
            [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [selectedIndexes addObject:[NSNumber numberWithInt:indexPath.row]];
            [selectedCategories addObject:selectedCell.textLabel.text];
        } else {
            [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
            [selectedIndexes removeObject:[NSNumber numberWithInt:indexPath.row]];
            [selectedCategories removeObject:selectedCell.textLabel.text];
        }
        [self setFilterSettings:@"categories_selected" value:selectedIndexes];
        
        NSString *selection = [selectedCategories componentsJoinedByString:@","];
        NSLog(@"Category Selection %@",selection);
        [self setFilterSettings:@"category_filter" value:selection];
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    [self setToggleStateForSection:indexPath.section];
    
    [self.filterTableView reloadData];
    
    
    
}

#pragma  mark - events
-(void)onSearchButton {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - save data

-(void)setFilterSettings:(NSString *) key value:(NSObject *)val {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:val forKey:key];
    [defaults synchronize];
}

-(NSObject * )getFilterSettings:(NSString *) key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *val = [defaults objectForKey:key];
    
    return val;
    
}

@end
