//
//  FiltersViewController.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "SliderCell.h"

int const CATEGORIES_SECTION_INDEX = 0;
int const DEALS_SECTION_INDEX = 1;
int const SORT_SECTION_INDEX = 2;
int const RADIUS_SECTION_INDEX = 3;


@interface FiltersViewController () <UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate, SliderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, assign) BOOL dealsOnly;
@property (nonatomic, assign) NSString *sortBy;
@property (nonatomic, assign) float radius;


@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        [self initSorts];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellReuseIdentifier:@"SliderCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    [self populateControlsFromStorage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == CATEGORIES_SECTION_INDEX) {
        return @"Categories";
    } else if (section == DEALS_SECTION_INDEX) {
        return @"Deals";
    } else if (section == SORT_SECTION_INDEX) {
        return @"Sort";
    } else if (section == RADIUS_SECTION_INDEX) {
        return @"Radius";
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == CATEGORIES_SECTION_INDEX) {
        return self.categories.count;
    } else if (section == DEALS_SECTION_INDEX) {
        return 1;
    } else if (section == SORT_SECTION_INDEX) {
        return 3;
    } else if (section == RADIUS_SECTION_INDEX) {
        return 1;
    }
    return -1; // should never get here
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CATEGORIES_SECTION_INDEX) { // categories
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        [cell setOn:[self.selectedCategories containsObject:self.categories[indexPath.row]]];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == DEALS_SECTION_INDEX) { // deals
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = @"Deals only";
        [cell setOn:self.dealsOnly];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == SORT_SECTION_INDEX) { // sort by
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = self.sorts[indexPath.row][@"label"];
        [cell setOn:[self.sortBy isEqualToString:self.sorts[indexPath.row][@"code"]]];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == RADIUS_SECTION_INDEX) { // radius
        SliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SliderCell"];
        [cell setSliderValue:self.radius];
        cell.delegate = self;
        return cell;
    }

    return nil;
}

#pragma mark - Switch cell delegate methods

-(void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == CATEGORIES_SECTION_INDEX) { // categories
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    } else if (indexPath.section == DEALS_SECTION_INDEX) { // deals
        self.dealsOnly = value;
    } else if (indexPath.section == SORT_SECTION_INDEX) { // sort
        if (value) {
            self.sortBy = self.sorts[indexPath.row][@"code"];
            
            [self toggleOtherSortsOff];
            
        } else {
            self.sortBy = nil;
        }
    }
}

#pragma mark - Slider cell delegate methods

-(void)sliderCell:(SliderCell *)sliderCell valueChanged:(float)value {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sliderCell];
    
    if(indexPath.section == RADIUS_SECTION_INDEX && indexPath.row == 0) {
        self.radius = value;
    }
}

#pragma mark - Private methods

-(NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    if (self.dealsOnly) {
        [filters setObject:@"true" forKey:@"deals_filter"];
    }
    
    [filters setObject:[NSString stringWithFormat:@"%0.0f", self.radius * 1609.34449789 /*meters per mile*/] forKey:@"radius_filter"];
    
    if (self.sortBy) {
        [filters setObject:self.sorts[[self.sortBy integerValue]][@"code"] forKey:@"sort"];
    }
    
    return filters;
}

-(void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onApplyButton {
    [self saveControlsToStorage];
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)toggleOtherSortsOff {
    for(int i = 0; i < self.sorts.count; i++) {
        SwitchCell *cell = (SwitchCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:SORT_SECTION_INDEX]];
        if (cell) {
            [cell setOn:(self.sorts[i][@"code"] == self.sortBy) animated:YES];
        }
        
    }
}

-(void)populateControlsFromStorage {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL savedControlDataExists = [defaults boolForKey:@"savedControlDataExists"];
    if (savedControlDataExists) {
        self.radius = [defaults floatForKey:@"radius"];
        self.dealsOnly = [defaults boolForKey:@"dealsOnly"];
        self.sortBy = [defaults objectForKey:@"sortBy"];
        self.selectedCategories = [NSMutableSet setWithSet:[self convertArrayToSet:[defaults objectForKey:@"selectedCategories"]]];
    } else {
        self.radius = 5;
        self.dealsOnly = NO;
        self.sortBy = @"0";
    }
}

-(void)saveControlsToStorage {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"savedControlDataExists"];
    [defaults setFloat:self.radius forKey:@"radius"];
    [defaults setBool:self.dealsOnly forKey:@"dealsOnly"];
    [defaults setObject:self.sortBy forKey:@"sortBy"];
    [defaults setObject:[self convertSetToArray:self.selectedCategories] forKey:@"selectedCategories"];
}

-(NSSet *)convertArrayToSet:(NSArray *)array {
    return [NSSet setWithArray:array];
}

-(NSArray *)convertSetToArray:(NSSet *)set {
    return [set allObjects];
}

-(void)initSorts {
    self.sorts =
    @[@{@"label" : @"Best Matched", @"code" : @"0"},
      @{@"label" : @"Distance", @"code" : @"1"},
      @{@"label" : @"Highest Rated", @"code" : @"2"}];
}

-(void)initCategories {
    self.categories =
    @[@{@"name" : @"Afghan", @"code": @"afghani" },
      @{@"name" : @"African", @"code": @"african" },
      @{@"name" : @"American, New", @"code": @"newamerican" },
      @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
      @{@"name" : @"Arabian", @"code": @"arabian" },
      @{@"name" : @"Argentine", @"code": @"argentine" },
      @{@"name" : @"Armenian", @"code": @"armenian" },
      @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
//      @{@"name" : @"Asturian", @"code": @"asturian" },
//      @{@"name" : @"Australian", @"code": @"australian" },
//      @{@"name" : @"Austrian", @"code": @"austrian" },
//      @{@"name" : @"Baguettes", @"code": @"baguettes" },
//      @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
//      @{@"name" : @"Barbeque", @"code": @"bbq" },
//      @{@"name" : @"Basque", @"code": @"basque" },
//      @{@"name" : @"Bavarian", @"code": @"bavarian" },
//      @{@"name" : @"Beer Garden", @"code": @"beergarden" },
//      @{@"name" : @"Beer Hall", @"code": @"beerhall" },
//      @{@"name" : @"Beisl", @"code": @"beisl" },
//      @{@"name" : @"Belgian", @"code": @"belgian" },
//      @{@"name" : @"Bistros", @"code": @"bistros" },
//      @{@"name" : @"Black Sea", @"code": @"blacksea" },
//      @{@"name" : @"Brasseries", @"code": @"brasseries" },
//      @{@"name" : @"Brazilian", @"code": @"brazilian" },
//      @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
//      @{@"name" : @"British", @"code": @"british" },
//      @{@"name" : @"Buffets", @"code": @"buffets" },
//      @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
//      @{@"name" : @"Burgers", @"code": @"burgers" },
//      @{@"name" : @"Burmese", @"code": @"burmese" },
//      @{@"name" : @"Cafes", @"code": @"cafes" },
//      @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
//      @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
//      @{@"name" : @"Cambodian", @"code": @"cambodian" },
//      @{@"name" : @"Canadian", @"code": @"New)" },
//      @{@"name" : @"Canteen", @"code": @"canteen" },
//      @{@"name" : @"Caribbean", @"code": @"caribbean" },
//      @{@"name" : @"Catalan", @"code": @"catalan" },
//      @{@"name" : @"Chech", @"code": @"chech" },
//      @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
//      @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
//      @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
//      @{@"name" : @"Chilean", @"code": @"chilean" },
//      @{@"name" : @"Chinese", @"code": @"chinese" },
//      @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
//      @{@"name" : @"Corsican", @"code": @"corsican" },
//      @{@"name" : @"Creperies", @"code": @"creperies" },
//      @{@"name" : @"Cuban", @"code": @"cuban" },
//      @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
//      @{@"name" : @"Cypriot", @"code": @"cypriot" },
//      @{@"name" : @"Czech", @"code": @"czech" },
//      @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
//      @{@"name" : @"Danish", @"code": @"danish" },
//      @{@"name" : @"Delis", @"code": @"delis" },
//      @{@"name" : @"Diners", @"code": @"diners" },
//      @{@"name" : @"Dumplings", @"code": @"dumplings" },
//      @{@"name" : @"Eastern European", @"code": @"eastern_european" },
//      @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
//      @{@"name" : @"Fast Food", @"code": @"hotdogs" },
//      @{@"name" : @"Filipino", @"code": @"filipino" },
//      @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
//      @{@"name" : @"Fondue", @"code": @"fondue" },
//      @{@"name" : @"Food Court", @"code": @"food_court" },
//      @{@"name" : @"Food Stands", @"code": @"foodstands" },
//      @{@"name" : @"French", @"code": @"french" },
//      @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
//      @{@"name" : @"Galician", @"code": @"galician" },
//      @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
//      @{@"name" : @"Georgian", @"code": @"georgian" },
//      @{@"name" : @"German", @"code": @"german" },
//      @{@"name" : @"Giblets", @"code": @"giblets" },
//      @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
//      @{@"name" : @"Greek", @"code": @"greek" },
//      @{@"name" : @"Halal", @"code": @"halal" },
//      @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
//      @{@"name" : @"Heuriger", @"code": @"heuriger" },
//      @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
//      @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
//      @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
//      @{@"name" : @"Hot Pot", @"code": @"hotpot" },
//      @{@"name" : @"Hungarian", @"code": @"hungarian" },
//      @{@"name" : @"Iberian", @"code": @"iberian" },
//      @{@"name" : @"Indian", @"code": @"indpak" },
//      @{@"name" : @"Indonesian", @"code": @"indonesian" },
//      @{@"name" : @"International", @"code": @"international" },
//      @{@"name" : @"Irish", @"code": @"irish" },
//      @{@"name" : @"Island Pub", @"code": @"island_pub" },
//      @{@"name" : @"Israeli", @"code": @"israeli" },
//      @{@"name" : @"Italian", @"code": @"italian" },
//      @{@"name" : @"Japanese", @"code": @"japanese" },
//      @{@"name" : @"Jewish", @"code": @"jewish" },
//      @{@"name" : @"Kebab", @"code": @"kebab" },
//      @{@"name" : @"Korean", @"code": @"korean" },
//      @{@"name" : @"Kosher", @"code": @"kosher" },
//      @{@"name" : @"Kurdish", @"code": @"kurdish" },
//      @{@"name" : @"Laos", @"code": @"laos" },
//      @{@"name" : @"Laotian", @"code": @"laotian" },
//      @{@"name" : @"Latin American", @"code": @"latin" },
//      @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
//      @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
//      @{@"name" : @"Malaysian", @"code": @"malaysian" },
//      @{@"name" : @"Meatballs", @"code": @"meatballs" },
//      @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
//      @{@"name" : @"Mexican", @"code": @"mexican" },
//      @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
//      @{@"name" : @"Milk Bars", @"code": @"milkbars" },
//      @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
//      @{@"name" : @"Modern European", @"code": @"modern_european" },
//      @{@"name" : @"Mongolian", @"code": @"mongolian" },
//      @{@"name" : @"Moroccan", @"code": @"moroccan" },
//      @{@"name" : @"New Zealand", @"code": @"newzealand" },
//      @{@"name" : @"Night Food", @"code": @"nightfood" },
//      @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
//      @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
//      @{@"name" : @"Oriental", @"code": @"oriental" },
//      @{@"name" : @"Pakistani", @"code": @"pakistani" },
//      @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
//      @{@"name" : @"Parma", @"code": @"parma" },
//      @{@"name" : @"Persian/Iranian", @"code": @"persian" },
//      @{@"name" : @"Peruvian", @"code": @"peruvian" },
//      @{@"name" : @"Pita", @"code": @"pita" },
//      @{@"name" : @"Pizza", @"code": @"pizza" },
//      @{@"name" : @"Polish", @"code": @"polish" },
//      @{@"name" : @"Portuguese", @"code": @"portuguese" },
//      @{@"name" : @"Potatoes", @"code": @"potatoes" },
//      @{@"name" : @"Poutineries", @"code": @"poutineries" },
//      @{@"name" : @"Pub Food", @"code": @"pubfood" },
//      @{@"name" : @"Rice", @"code": @"riceshop" },
//      @{@"name" : @"Romanian", @"code": @"romanian" },
//      @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
//      @{@"name" : @"Rumanian", @"code": @"rumanian" },
//      @{@"name" : @"Russian", @"code": @"russian" },
//      @{@"name" : @"Salad", @"code": @"salad" },
//      @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
//      @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
//      @{@"name" : @"Scottish", @"code": @"scottish" },
//      @{@"name" : @"Seafood", @"code": @"seafood" },
//      @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
//      @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
//      @{@"name" : @"Singaporean", @"code": @"singaporean" },
//      @{@"name" : @"Slovakian", @"code": @"slovakian" },
//      @{@"name" : @"Soul Food", @"code": @"soulfood" },
//      @{@"name" : @"Soup", @"code": @"soup" },
//      @{@"name" : @"Southern", @"code": @"southern" },
//      @{@"name" : @"Spanish", @"code": @"spanish" },
//      @{@"name" : @"Steakhouses", @"code": @"steak" },
//      @{@"name" : @"Sushi Bars", @"code": @"sushi" },
//      @{@"name" : @"Swabian", @"code": @"swabian" },
//      @{@"name" : @"Swedish", @"code": @"swedish" },
//      @{@"name" : @"Swiss Food", @"code": @"swissfood" },
//      @{@"name" : @"Tabernas", @"code": @"tabernas" },
//      @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
//      @{@"name" : @"Tapas Bars", @"code": @"tapas" },
//      @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
//      @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
//      @{@"name" : @"Thai", @"code": @"thai" },
//      @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
//      @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
//      @{@"name" : @"Trattorie", @"code": @"trattorie" },
//      @{@"name" : @"Turkish", @"code": @"turkish" },
//      @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
//      @{@"name" : @"Uzbek", @"code": @"uzbek" },
//      @{@"name" : @"Vegan", @"code": @"vegan" },
//      @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
//      @{@"name" : @"Venison", @"code": @"venison" },
//      @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
//      @{@"name" : @"Wok", @"code": @"wok" },
//      @{@"name" : @"Wraps", @"code": @"wraps" },
      @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];
}

@end
