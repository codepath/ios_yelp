//
//  UIImageView+NSAdditions.m
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/8/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import "UIImageView+NSAdditions.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (NSAdditions)

- (void)fadeInImageWithURLRequest:(NSURLRequest *)urlRequest
                 placeholderImage:(UIImage *)placeholderImage {

    UIImageView *me = self;
    [self setImageWithURLRequest:urlRequest
                placeholderImage:placeholderImage
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             if (response == nil || placeholderImage != nil) {
                                 // if response is nil, image came from cache, so don't animate
                                 // also, if there is a placeholder (such as a lowres image) don't fade in
                                 [me setImage:image];
                             } else {
                                 me.alpha = 0.0;
                                 [UIView beginAnimations:@"fade in" context:nil];
                                 [UIView setAnimationDuration:0.3];
                                 [me setImage:image];
                                 me.alpha = 1.0;
                                 [UIView commitAnimations];
                             }
                         }
                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                             // do nothing
                         }];
}

@end
