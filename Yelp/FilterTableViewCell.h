//
//  FilterTableViewCell.h
//  Yelp
//
//  Created by Paritosh Aggarwal on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterTableViewCell;

@protocol FilterTableViewCellDelegate <NSObject>
- (void)filterCell:(FilterTableViewCell *)cell didUpdateValue:(BOOL)value;
@end

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) id<FilterTableViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

- (IBAction)switchValueChanged:(id)sender;
@end
