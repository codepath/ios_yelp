//
//  SwitchCell.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell


@property (weak, nonatomic) id<SwitchCellDelegate> delegate;
@property (nonatomic, assign) BOOL on;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
