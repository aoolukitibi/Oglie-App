//
//  Result.h
//  Oglie
//
//  Created by Anthony Olukitibi on 1/18/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;

- (instancetype)initWithTitle:(NSString *)title andPhone:(NSString *)thePhone withLat:(double)lat andLong:(double)lng;


@end
