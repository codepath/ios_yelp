//
//  YelpBusinessTableViewCell.m
//  Yelp
//
//  Created by Alex Lester on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "YelpBusinessTableViewCell.h"

@implementation YelpBusinessTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBusiness:(YelpBusiness *)business {
	self.business = business;
	[self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
	self.BusinessLabel.text = self.business.name;
	[self.ratingIMageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
	self.numberReviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews", self.business.reviewCount];
	self.AddressLabel.text = self.business.address;
	self.distanceLabel.text = [NSString stringWithFormat:@"%@ mi", self.business.distance];
	
}

@end
