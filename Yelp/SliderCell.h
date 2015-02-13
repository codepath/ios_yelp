//
//  SliderCell.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderCell;

@protocol SliderCellDelegate <NSObject>

-(void)sliderCell:(SliderCell *)sliderCell valueChanged:(float)value;

@end

@interface SliderCell : UITableViewCell

@property (weak, nonatomic) id<SliderCellDelegate> delegate;

-(void)setSliderValue:(float)value;

@end
