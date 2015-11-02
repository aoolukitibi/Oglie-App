//
//  CustomTableViewCell.h
//  Oglie
//
//  Created by Anthony Olukitibi on 1/18/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Result.h"

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet MKMapView *myMapView;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UIButton *phone;


-(void) setData:(Result *) theResult;

@end
