//
//  Business.m
//  Yelp
//
//  Created by Paritosh Aggarwal on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    @try
    {
    NSArray *categories = dictionary[@"categories"];
    NSMutableArray *categoryNames = [[NSMutableArray array] init];
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      [categoryNames addObject:obj[0]];
    }];
    self.categories = [categoryNames componentsJoinedByString:@", "];
    self.name = dictionary[@"name"];
    self.imageUrl = dictionary[@"image_url"];
    NSString *street = [dictionary valueForKeyPath:@"location.address"][0];
    NSString *neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
    self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
    self.numReviews = [dictionary[@"review_count"] integerValue];
    self.ratingImageUrl = dictionary[@"rating_img_url"];
    float milesPerMeter = 0.000621371;
    self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
    }     @catch(NSException *exception) {
      
    }

  }
  return self;
}

+ (NSMutableArray *)businessWithDictionaries:(NSArray* )dictionaries {
  NSMutableArray *businesses = [NSMutableArray array];
  for (NSDictionary* businessDict in dictionaries) {
    Business* business = [[Business alloc] initWithDictionary:businessDict];
    [businesses addObject:business];
  }
  return businesses;
}

@end
