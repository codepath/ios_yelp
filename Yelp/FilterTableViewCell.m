//
//  FilterTableViewCell.m
//  Yelp
//
//  Created by Paritosh Aggarwal on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
  [self.delegate filterCell:self didUpdateValue:self.toggleSwitch];
}

- (void)setOn:(BOOL)on {
  _on = on;
  [self.toggleSwitch setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
  _on = on;
  [self.toggleSwitch setOn:on animated:animated];
}

@end
