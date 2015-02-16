//
//  BusinessLocation.m
//  Yelp
//
//  Created by Naeim Semsarilar on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessLocation.h"


@interface BusinessLocation ()
@end

@implementation BusinessLocation

- (id)initWithBusiness:(Business *)business {
    if ((self = [super init])) {
        self.business = business;
    }
    return self;
}

- (NSString *)title {
    return _business.name;
}

- (NSString *)subtitle {
    return _business.address;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_business.latitude, _business.longitude);
}

- (MKMapItem*)mapItem {
    //NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end