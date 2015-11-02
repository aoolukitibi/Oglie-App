//
//  MapAnnotation.h
//  Oglie
//
//  Created by Anthony Olukitibi on 1/18/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
