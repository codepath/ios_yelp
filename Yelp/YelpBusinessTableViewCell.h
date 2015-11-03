//
//  YelpBusinessTableViewCell.h
//  Yelp
//
//  Created by Alex Lester on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpBusiness.h"
#import "UIImageView+AFNetworking.h"

@interface YelpBusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *BusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *GenreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingIMageView;
@property (weak, nonatomic) IBOutlet UILabel *numberReviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (nonatomic, strong) YelpBusiness *business;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

- (void) setBusiness:(YelpBusiness *)business;

@end
