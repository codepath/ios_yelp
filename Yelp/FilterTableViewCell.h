//
//  FilterTableViewCell.h
//  Yelp
//
//  Created by Guozheng Ge on 6/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;

@end
