//
//  BusinessCellTableViewCell.m
//  Yelp
//
//  Created by Paritosh Aggarwal on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCellTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation BusinessCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
  self.restaurantName.preferredMaxLayoutWidth = self.restaurantName.frame.size.width;
  self.thumbImageView.layer.cornerRadius = 3;
  self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBusiness:(Business *)business {
  _business = business;
  [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
  self.restaurantName.text = self.business.name;
  [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
  self.dollarReviews.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
  self.addressLabel.text = self.business.address;
  self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", self.business.distance];
  if (self.business.categories) {
    self.cuisineLabel.text = self.business.categories;
  } else {
    self.cuisineLabel.text = @"";
  }
}

- (void) layoutSubviews {
  [super layoutSubviews];
  self.restaurantName.preferredMaxLayoutWidth = self.restaurantName.frame.size.width;
}

@end
