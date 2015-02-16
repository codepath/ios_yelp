//
//  BusinessViewController.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessViewController : UIViewController

@property (nonatomic, strong) Business *business;
@property (nonatomic, strong) UIImage *placeholderImage;

@end
