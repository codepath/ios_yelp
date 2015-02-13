//
//  SliderCell.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SliderCell.h"

@interface SliderCell()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

-(void)setSliderValue:(float)value callDelegate:(BOOL)callDelegate;


@end

@implementation SliderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onValueChanged:(id)sender {
    float value = [self.slider value];
    
    [self setSliderValue:value callDelegate:YES];
}

-(void)setSliderValue:(float)value {
    [self setSliderValue:value callDelegate:NO];
}

-(void)setSliderValue:(float)value callDelegate:(BOOL)callDelegate {
    float roundedValue = floorf(value);
    
    // snap behavior
    [self.slider setValue:(float)roundedValue animated:YES];
    
    // update the label
    if (roundedValue == 1) {
        self.sliderLabel.text = @"1 mile";
    } else {
        self.sliderLabel.text = [NSString stringWithFormat:@"%0.0f miles", roundedValue];
    }

    if (callDelegate) {
        // call the delegate
        [self.delegate sliderCell:self valueChanged:roundedValue];
    }
}

@end
