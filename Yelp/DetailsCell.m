//
//  DetailsCell.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DetailsCell.h"

@interface DetailsCell()


@end

@implementation DetailsCell

- (void)awakeFromNib {
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
