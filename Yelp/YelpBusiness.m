//
//  YelpBusiness.m
//  Yelp
//
//  Created by Nicholas Aiwazian on 10/24/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "YelpBusiness.h"

@implementation YelpBusiness

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _name = dict[@"name"];

        NSString *imageUrlString = dict[@"image_url"];
        _imageUrl = imageUrlString ? [NSURL URLWithString:imageUrlString] : nil;

        NSMutableString *address = [[NSMutableString alloc] initWithString:@""];
        NSDictionary *locationDictionary = dict[@"location"];
        if (locationDictionary) {
            NSArray *addressArray = locationDictionary[@"address"];
            if (addressArray && addressArray.count > 0) {
                [address appendString:addressArray[0]];
            }

            NSArray *neighborhoods = locationDictionary[@"neighborhoods"];
            if (neighborhoods && neighborhoods.count > 0) {
                if (address.length > 0) {
                    [address appendString:@", "];
                }
                [address appendString:neighborhoods[0]];
            }
        }
        _address = address;

        NSArray *categoriesArray = dict[@"categories"];
        if (categoriesArray) {
            NSMutableArray *categoryNames = [[NSMutableArray alloc] initWithArray:@[]];
            for (NSArray *category in categoriesArray) {
                NSString *categoryName = category[0];
                [categoryNames addObject:categoryName];
            }
            _categories = [categoryNames componentsJoinedByString:@", "];
        }

        NSNumber *distanceMeters = dict[@"distance"];
        if (distanceMeters) {
            float milesPerMeter = 0.000621371;
            _distance = [NSString stringWithFormat:@"%.2f mi", milesPerMeter * [distanceMeters doubleValue]];
        }

        NSString *ratingImageUrlString = dict[@"rating_img_url_large"];
        _ratingImageUrl = ratingImageUrlString ? [NSURL URLWithString:ratingImageUrlString] : nil;

        _reviewCount = dict[@"review_count"];
    }
    return self;
}

+ (NSArray *)businessesFromJsonArray:(NSArray *)jsonArray {
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:@[]];
    for (NSDictionary *json in jsonArray) {
        YelpBusiness *business = [[YelpBusiness alloc] initWithDictionary:json];
        [result addObject:business];
    }
    return result;
}

+ (void)searchWithTerm:(NSString *)term
            completion:(void (^)(NSArray *businesses, NSError *error))completion {

    [[YelpClient sharedInstance] searchWithTerm:term completion:completion];
}

+ (void)searchWithTerm:(NSString *)term
              sortMode:(YelpSortMode)sortMode
            categories:(NSArray *)categories
                 deals:(BOOL)hasDeal
            completion:(void (^)(NSArray *businesses, NSError *error))completion {

    [[YelpClient sharedInstance] searchWithTerm:term
                                       sortMode:sortMode
                                     categories:categories
                                          deals:hasDeal
                                     completion:completion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n\tName:%@\n\tAddress:%@\n\tImageUrl:%@\n\tCategories:%@\n\tDistance:%@\n\tRatingImageUrl:%@\n\tReviewCount:%@\n\t",
            self.name,
            self.address,
            self.imageUrl,
            self.categories,
            self.distance,
            self.ratingImageUrl,
            self.reviewCount];
}

@end
