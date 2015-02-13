//
//  BusinessCell.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.posterView.layer.cornerRadius = 3;
    self.posterView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBusiness:(Business *) business {
    _business = business;
    
    [self.posterView setImageWithURL:[NSURL URLWithString:business.imageUrl]];
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImageUrl]];
    self.nameLabel.text = business.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", business.numReviews];
    self.addressLabel.text = business.address;
    self.categoriesLabel.text = business.categories;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", business.distance];
    // totally artificial way to randomize the dollar signs:
    //self.priceLabel.text = [@"" stringByPaddingToLength:(business.numReviews % 3 + 1) withString:@"$" startingAtIndex:0];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
