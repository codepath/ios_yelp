//
//  ShowMoreCell.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowMoreCell;

@protocol ShowMoreCellDelegate <NSObject>

-(void)showMoreInvoked:(ShowMoreCell *)showMoreCell;

@end

@interface ShowMoreCell : UITableViewHeaderFooterView

@property (nonatomic, weak) id<ShowMoreCellDelegate> delegate;

@end
