//
//  Business.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, strong) NSString *ratingImageUrlLarge;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) int index;

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries startingAtOffset:(int)offset;

@end
