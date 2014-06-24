//
//  DealTableViewCell.m
//  Yelp
//
//  Created by Sharad Ganapathy on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "DealTableViewCell.h"

@implementation DealTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)dealSwitchChanged:(id)sender {
    NSString *deals_filter;
    if ([sender isOn]) {
         deals_filter = @"true";
        NSLog(@"Deal switch %@", deals_filter);
    }
    else {
        deals_filter = @"false";
         NSLog(@"Deal switch %@", deals_filter);
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deals_filter forKey:@"deals_filter"];
    [defaults synchronize];

}
@end
