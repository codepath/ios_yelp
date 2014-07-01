//
//  YelpTableViewCell.m
//  Yelp
//
//  Created by Harsha Badami Nagaraj on 6/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation YelpTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)listing {
    NSMutableArray *categories = [NSMutableArray array];

    //Name
    self.nameLabel.text = listing[@"name"];
    
    //Address
    if ([listing[@"location"][@"address"] count] != 0 ) {
        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@", listing[@"location"][@"address"][0], listing[@"location"][@"city"]];
    } else {
        self.addressLabel.text = @" ";
    }
    
    //Categories
    if ([listing[@"categories"] count] != 0) {
        for (NSArray *cuisineArr in listing[@"categories"]) {
            [categories addObject:cuisineArr[0]];
        }
        self.cuisineLabel.text = [categories componentsJoinedByString:@", "];
    } else {
        self.cuisineLabel.text = @" ";
    }
    
    //Reviews
    if(listing[@"review_count"]) {
        self.reviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews", listing[@"review_count"]];
    }
    
    //Distance
    if (listing[@"distance"]) {
        NSString *string = [NSString stringWithFormat:@"%@", listing[@"distance"]];
        float stringFloat = [string floatValue];
        stringFloat = stringFloat * 0.000621371;
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", stringFloat];
    }
    
    //Set Rating Image & Thumbnail Image
    [self.thumbnailImage setImageWithURL:[NSURL URLWithString:listing[@"image_url"]]];
    [self.ratingImage setImageWithURL:[NSURL URLWithString:listing[@"rating_img_url"]]];
}
@end
