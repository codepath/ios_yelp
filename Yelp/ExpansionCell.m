//
//  ExpansionCell.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "ExpansionCell.h"

@interface ExpansionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *downArrowImage;

@end

@implementation ExpansionCell

- (void)awakeFromNib {
    // Initialization code
    self.downArrowImage.image = [self.downArrowImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
