//
//  CustomTableViewCell.m
//  Oglie
//
//  Created by Anthony Olukitibi on 1/18/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import "CustomTableViewCell.h"
#import "MapAnnotation.h"

@interface CustomTableViewCell ()

@property (nonatomic, strong) Result *theMainResult;

@end

@implementation CustomTableViewCell



-(void) setData:(Result *) theResult {
    
    self.theMainResult = theResult;
    self.title.text = theResult.title;
    [self.phone setTitle:theResult.phone forState:UIControlStateNormal];
    
    CLLocationCoordinate2D coord;
    coord.latitude = theResult.latitude;
    coord.longitude = theResult.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.02, 0.02));
    [self.myMapView setRegion:region];
    
    [self.myMapView removeAnnotations:self.myMapView.annotations];
    
    MapAnnotation *ann = [[MapAnnotation alloc] init];
    ann.title = theResult.title;
    ann.coordinate = coord;
    [self.myMapView addAnnotation:ann];
    
}

-(IBAction)phoneNumberLabelTap {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",[self.phone titleForState:UIControlStateNormal]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

-(IBAction)openDirections {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(self.theMainResult.latitude, self.theMainResult.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:self.theMainResult.title];
        // Pass the map item to the Maps app
        
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

@end
