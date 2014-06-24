//
//  DealTableViewCell.h
//  Yelp
//
//  Created by Sharad Ganapathy on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *dealSwitch;

- (IBAction)dealSwitchChanged:(id)sender;
@end
