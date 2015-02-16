//
//  UIImageView+NSAdditions.h
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/8/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NSAdditions)

- (void)fadeInImageWithURLRequest:(NSURLRequest *)urlRequest
                 placeholderImage:(UIImage *)placeholderImage;

@end
