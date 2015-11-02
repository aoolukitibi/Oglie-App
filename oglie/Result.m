//
//  Result.m
//  Oglie
//
//  Created by Anthony Olukitibi on 1/18/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import "Result.h"

@implementation Result

- (instancetype)initWithTitle:(NSString *)title andPhone:(NSString *)thePhone withLat:(double)lat andLong:(double)lng
{
    self = [super init];
    if (self) {
        self.title = title;
        self.phone = thePhone;
        self.latitude = lat;
        self.longitude = lng;
    }
    return self;
}

@end
