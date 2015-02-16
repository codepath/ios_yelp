//
//  ShowMoreCell.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "ShowMoreCell.h"

@interface ShowMoreCell ()
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImage;

@end

@implementation ShowMoreCell

- (void)awakeFromNib {
    // Initialization code
    self.downArrowImage.image = [self.downArrowImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

}
- (IBAction)onShowMoreButton:(id)sender {
    [self.delegate showMoreInvoked:self];
}

@end
