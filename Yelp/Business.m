//
//  Business.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.name = dictionary[@"name"];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.imageUrl = dictionary[@"image_url"];
        self.distance = [dictionary[@"distance"] integerValue] * 0.000621371 /*miles per meter*/;

        // address
        NSArray *addresses = [dictionary valueForKeyPath:@"location.address"];
        NSArray *neighborhoods = [dictionary valueForKeyPath:@"location.neighborhoods"];
        NSMutableArray *addressParts = [NSMutableArray array];
        if (addresses.count > 0) {
            [addressParts addObject:addresses[0]];
        }
        if (neighborhoods.count > 0) {
            [addressParts addObject:neighborhoods[0]];
        }
        self.address = [addressParts componentsJoinedByString:@", "];
        
        // categories
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        for(NSArray *category in categories) {
            [categoryNames addObject:category[0]];
        }
        self.categories = [categoryNames componentsJoinedByString:@", "];
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    
    return businesses;
}

@end
