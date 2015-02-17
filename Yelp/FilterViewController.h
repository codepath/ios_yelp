//
//  FilterViewController.h
//  Yelp
//
//  Created by Paritosh Aggarwal on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters;
@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;
@end
