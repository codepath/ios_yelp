//
//  RestaurantTableViewCell.h
//  Yelp
//
//  Created by Sharad Ganapathy on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *serialLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *restPosterView;

@property (weak, nonatomic) IBOutlet UIImageView *ratingsPosterView;

-(void)setRestaurant:(NSDictionary * ) restaurant index:(int)index;

@end
