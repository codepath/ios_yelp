//
//  RestaurantTableViewCell.m
//  Yelp
//
//  Created by Sharad Ganapathy on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "RestaurantTableViewCell.h"
#import <UIImageView+AFNetworking.h>


@implementation RestaurantTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRestaurant:(NSDictionary * ) restaurant index:(int) index{
    
    self.nameLabel.text = restaurant[@"name"];
    self.serialLabel.text = [NSString stringWithFormat:@"%d", index + 1];
   // self.addrLabel.text = restaurant[@"location"][@"address"][0];
    self.tagsLabel.text = [restaurant[@"categories"][0] componentsJoinedByString:@","];
    [self.restPosterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:restaurant[@"image_url"]]] placeholderImage: NULL success:NULL failure:NULL];
    [self.ratingsPosterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:restaurant[@"rating_img_url"]]] placeholderImage: NULL success:NULL failure:NULL];
    self.distanceLabel.text = [NSString stringWithFormat:@"%d m", [restaurant[@"distance" ] integerValue]];
}
@end
