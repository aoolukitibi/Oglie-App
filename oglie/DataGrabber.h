//
//  DataGrabber.h
//  FlickrProject
//
//  Created by Anthony Olukitibi on 2/2/13.
//  Copyright (c) 2013 Anthony Olukitibi All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@protocol DataGrabberDelegate <NSObject>

@optional
-(void) provide:(NSArray *)freshData;
-(void) sameData;
@end

@interface DataGrabber : NSObject

@property (nonatomic, assign) id <DataGrabberDelegate> dataGrabberDelegate;

-(void) getDataWithType:(NSString *)theType atLocation:(NSString *)theLocation atCount:(int)theCount;

@end
