//
//  YelpClient.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface YelpClient : BDBOAuth1RequestOperationManager

typedef NS_ENUM(NSInteger, YelpSortMode) {
    YelpSortModeBestMatched = 0,
    YelpSortModeDistance = 1,
    YelpSortModeHighestRated = 2
};

+ (instancetype)sharedInstance;

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                completion:(void (^)(NSArray *businesses, NSError *error))completion;

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                                  sortMode:(YelpSortMode)sortMode
                                categories:(NSArray *)categories
                                     deals:(BOOL)hasDeal
                                completion:(void (^)(NSArray *businesses, NSError *error))completion;

@end
