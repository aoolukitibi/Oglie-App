//
//  DataGrabber.m
//  FlickrProject
//
//  Created by Anthony Olukitibi on 2/2/13.
//  Copyright (c) 2013 Anthony Olukitibi All rights reserved.
//

#import "DataGrabber.h"
#import "Result.h"

@interface DataGrabber () {
    NSMutableData *receivedData;
    NSURLConnection *theConnection;
}

@end

@implementation DataGrabber

@synthesize dataGrabberDelegate;

-(void) getDataWithType:(NSString *)theType atLocation:(NSString *)theLocation atCount:(int)theCount {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        NSString *searchQuery = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20local.search(%d%%2C%d)%%20where%%20zip%%3D'%@'%%20and%%20query%%3D'%@'&format=json&callback=", theCount, theCount+10, theLocation, theType];
        
        
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:searchQuery] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

        receivedData = [NSMutableData dataWithCapacity: 0];

        theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

        if (!theConnection) {
            // Release the receivedData object.
            receivedData = nil;
            [dataGrabberDelegate sameData];

            // Inform the user that the connection failed.
        }
        
    } else {
        NSLog(@"ERROR");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    theConnection = nil;
    receivedData = nil;
    
    // inform the user
    [dataGrabberDelegate sameData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
    
    if(![[[dataDict objectForKey:@"query"] objectForKey:@"results"] isKindOfClass:[NSNull class]]){
        NSArray *results = [[[dataDict objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"Result"];
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *resultData in results) {
            double lat = [[resultData objectForKey:@"Latitude"] doubleValue];
            double lng = [[resultData objectForKey:@"Longitude"] doubleValue];
            if([[resultData objectForKey:@"Phone"] isKindOfClass:[NSNull class]] || [[resultData objectForKey:@"Title"] isKindOfClass:[NSNull class]]) {
            } else {
                Result *theResult = [[Result alloc] initWithTitle:[resultData objectForKey:@"Title"]  andPhone:[resultData objectForKey:@"Phone"] withLat:lat andLong:lng];
                [resultObjects addObject:theResult];
            }
            
        }
        [dataGrabberDelegate provide:resultObjects];
        
    } else {
        [dataGrabberDelegate sameData];
        NSLog(@"ERROR");
        
    }

   
    
    theConnection = nil;
    receivedData = nil;
}



@end
