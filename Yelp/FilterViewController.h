//
//  FilterViewController.h
//  Yelp
//
//  Created by Harsha Badami Nagaraj on 6/30/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>
-(void)propagateFilters:(FilterViewController *)controller;
@end


@interface FilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *filters;
@property (strong, nonatomic) NSMutableDictionary *selectedValues;
@end
