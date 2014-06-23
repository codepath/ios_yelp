//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic, strong) NSArray *businesses;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessTableViewCell"];
    
    [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        self.businesses = response[@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%d, row=%d", indexPath.section, indexPath.row);
    
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTableViewCell"];
    
    NSDictionary *business = self.businesses[indexPath.row];
    
    // load image
    NSURL *imageURL = [NSURL URLWithString:business[@"image_url"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    // rounded corner with border and inner shadow
//    cell.businessImage.layer.shadowColor = [[UIColor grayColor] CGColor];
//    cell.businessImage.layer.shadowRadius = 10.0;
//    cell.businessImage.layer.shadowOpacity = 1.0;
//    cell.businessImage.layer.shadowOffset = CGSizeMake(0, 0);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.businessImage.bounds cornerRadius:10.0];
//    cell.businessImage.layer.shadowPath = path.CGPath;
    cell.businessImage.layer.cornerRadius = 10.0;
    cell.businessImage.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.businessImage.layer.borderWidth = 1.0;
    cell.businessImage.layer.masksToBounds = YES;
    [cell.businessImage setImageWithURL:imageURL placeholderImage:placeholderImage];
    
    
    // load start image
    NSURL *ratingImageURL = [NSURL URLWithString:business[@"rating_img_url"]];
    UIImage *defaultStarImage = [UIImage imageNamed:@"DefaultStars"];
    [cell.ratingImage setImageWithURL:ratingImageURL placeholderImage:defaultStarImage];
    
    // load text values
    
    // name
    cell.businessName.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, business[@"name"]];
    
    // review count
    cell.review.text = [NSString stringWithFormat:@"%@ Reviews", business[@"review_count"]];

    // address
    NSArray *addressArray = business[@"location"][@"display_address"];
    cell.address.text = [NSString stringWithFormat:@"%@, %@", addressArray[0], addressArray[1]];
    
    // categories is an array of arrays
    NSMutableString *categoriesString = [[NSMutableString alloc] init];
    NSArray *categories = business[@"categories"];
    NSInteger i = 0;
    for (NSArray *category in categories) {
        if (i != 0) {
            [categoriesString appendString:@", "];
        }
        [categoriesString appendString:category[0]];
        i++;
    }
    cell.categories.text = categoriesString;
    
    // distance, 1 meter = 0.000621371 mile
    float distanceInMile = [business[@"distance"] floatValue] * 0.000621371;
    cell.distance.text = [NSString stringWithFormat:@"%.1f mi", distanceInMile];
    
    // cost
    
    return cell;
}

@end
