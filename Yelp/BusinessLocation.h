//
//  BusinessLocation.h
//  Yelp
//
//  Created by Naeim Semsarilar on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#ifndef Yelp_BusinessLocation_h
#define Yelp_BusinessLocation_h


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface BusinessLocation : NSObject <MKAnnotation>

@property (nonatomic, strong) Business *business;

- (id)initWithBusiness:(Business *)business;
- (MKMapItem *)mapItem;

@end


#endif
