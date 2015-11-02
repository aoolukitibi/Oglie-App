//
//  MainViewController.m
//  Oglie
//
//  Created by Anthony Olukitibi on 1/15/15.
//  Copyright (c) 2015 Anthony Olukitibi All rights reserved.
//

#import "MainViewController.h"
#import "ResultsTableViewController.h"
#import "DataGrabber.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface MainViewController () <DataGrabberDelegate, CLLocationManagerDelegate, UITextFieldDelegate>{
    NSArray *downloadResults;
    int count;
    DataGrabber *dataGrabber;
}

@property (weak, nonatomic) IBOutlet UITextField *whatTextField;
@property (weak, nonatomic) IBOutlet UITextField *whereTextField;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *coder;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataGrabber = [[DataGrabber alloc] init];
    dataGrabber.dataGrabberDelegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    count = 0;
}

- (IBAction)useCurrentLocation {
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

- (IBAction)searchStuff {
    [dataGrabber getDataWithType:self.whatTextField.text atLocation:self.whereTextField.text atCount:0];
}


-(void) provide:(NSArray *)freshData{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ResultsTableViewController *resultsTableViewController = (ResultsTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ResultsTableViewController"];
    resultsTableViewController.theQueryCount = 10;
    resultsTableViewController.what = self.whatTextField.text;
    resultsTableViewController.where = self.whereTextField.text;
    resultsTableViewController.passedDataArray = freshData;
    
    [self.navigationController pushViewController:resultsTableViewController animated:YES];
    
}


-(void) sameData {
    NSLog(@"ERRor");
}

#pragma mark - Location Manager delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations: %@", [locations lastObject]);
    CLLocation *theLocation =[locations lastObject];
    [self.locationManager stopUpdatingLocation];
    self.coder = [[CLGeocoder alloc] init];
    [self.coder reverseGeocodeLocation:theLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(!error){
            CLPlacemark *placemark = [placemarks lastObject];
            self.whereTextField.text = placemark.postalCode;
            NSLog(@"%@",placemark.postalCode);
        }
    }];
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location services not authorized"
                                                        message:@"This app needs you to authorize locations services to work."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else
        NSLog(@"Wrong location status");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self searchStuff];
    return YES;
    
}

@end
