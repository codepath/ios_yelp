//
//  FiltersViewController.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;


@protocol FiltersViewControllerDelegate <NSObject>

-(void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters;

@end


@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
