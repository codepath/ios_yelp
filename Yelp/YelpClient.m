//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term withFilters:(NSDictionary *)filters success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//    NSDictionary *parameters = @{@"term": term, @"location" : @"San Francisco"};
    
    // need to give lattitude and longitude to get distance info in response
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"term": term, @"ll" : @"37.788022,-122.399797"}];
    
    // sort
    NSString *sort = filters[@"sort"];
    if (sort && ([sort isEqualToString:@"0"] || [sort isEqualToString:@"1"] || [sort isEqualToString:@"2"])) {
        [parameters setValue:sort forKey:@"sort"];
        NSLog(@"sort parameter set to %@", sort);
    }
    
    // radius
    int radius = [filters[@"radius"] intValue];
    if (radius != 0 && radius < 40000) {
        [parameters setValue:[NSString stringWithFormat:@"%i", radius] forKey:@"radius_filter"];
        NSLog(@"radius parameter set to %i", radius);
    }
    
    // deals
    NSString *deals = filters[@"deals"];
    if (deals) {
        [parameters setValue:([deals isEqualToString:@"YES"]) ? @"true" : @"false" forKey:@"deals_filter"];
        NSLog(@"deals parameter set to %@", deals);
    }
    
    // category
    NSMutableString *s = [NSMutableString stringWithString:@""];
    NSDictionary *categories = filters[@"category"];
    if (categories) {
        [categories enumerateKeysAndObjectsUsingBlock:^(id k, id v, BOOL *stop) {
            if ([v isEqualToString:@"YES"]) {
                [s appendString:k];
                [s appendString:@","];
                NSLog(@"category %@ set to YES", k);
            }
        }];
        NSLog(@"category parameter set to %@", s);
    }
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self searchWithTerm:term withFilters:@{} success:success failure:failure];
}

@end
