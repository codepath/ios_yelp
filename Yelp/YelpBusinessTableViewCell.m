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
	self.BusinessLabel.preferredMaxLayoutWidth = self.BusinessLabel.frame.size.width;
	self.thumbImageView.layer.cornerRadius =3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
	[super layoutSubviews];
	self.BusinessLabel.preferredMaxLayoutWidth = self.BusinessLabel.frame.size.width;
}

@end
