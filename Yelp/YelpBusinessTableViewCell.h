//
//  YelpBusinessTableViewCell.h
//  Yelp
//
//  Created by Alex Lester on 11/2/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpBusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BusinessImageView;
@property (weak, nonatomic) IBOutlet UILabel *BusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *GenreLabel;



@end
