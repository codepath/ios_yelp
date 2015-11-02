//
//  YelpBusinessTableViewCell.h
//  Yelp
//
//  Created by Alex Lester on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpBusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *StarLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfStarsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfReviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *GenreLabel;
@property (weak, nonatomic) IBOutlet UIView *businessImage;


@end
