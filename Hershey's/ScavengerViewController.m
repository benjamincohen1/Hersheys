//
//  ScavengerViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/28/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "ScavengerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface ScavengerViewController ()

@end

@implementation ScavengerViewController
@synthesize locationManager, mapView;

- (void)viewDidLoad
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter=10.0;
    [locationManager startUpdatingLocation];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)dropPoint:(id)sender {
    DorC = @"Drop";
    NSLog(@"Drop");
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter=10.0;
    [locationManager startUpdatingLocation];
}

- (IBAction)pickUpPoint:(id)sender {
    DorC = @"Collect";
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter=10.0;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
        // Stop Location Services
        [self.locationManager stopUpdatingLocation];
        
        // Some Reverse Geocoding...
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        float longitude = coordinate.longitude;
        float latitude = coordinate.latitude;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([DorC isEqualToString:@"Drop"]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/rewards/add_point"]];
        
        //set HTTP Method
        [request setHTTPMethod:@"POST"];
        
        //Implement request_body for send request here username and password set into the body.
        NSString *request_body = [NSString stringWithFormat:@"Username=%@&lat=%f&lon=%f", appDelegate.acUsername, latitude, longitude];
        //set request body into HTTPBody.
        [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set request url to the NSURLConnection
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [theConnection start];
        
    } else if ([DorC isEqualToString:@"Collect"]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/map/collect"]];
        
        //set HTTP Method
        [request setHTTPMethod:@"POST"];
        
        //Implement request_body for send request here username and password set into the body.
        NSString *request_body = [NSString stringWithFormat:@"Username=%@&lat=%f&lon=%f", appDelegate.acUsername, latitude, longitude];
        //set request body into HTTPBody.
        [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set request url to the NSURLConnection
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [theConnection start];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/map/closest"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"lat=%f&lon=%f", latitude, longitude];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    closestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [closestConnection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    if ([DorC isEqualToString:@"Drop"]) {
        if (connection == closestConnection) {} else {
    NSLog(@"heres data:%@", [NSString stringWithUTF8String:[data bytes]]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drop Posted!"
                                                        message:@"Your gift has been sent!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Yay!"
                                              otherButtonTitles: nil];
        [alert show];
        }
    } else if ([DorC isEqualToString:@"Collect"]) {
        if (connection == closestConnection) {} else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woohoo!"
                                                        message:@"Thank Ben For Dropping This Gift!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Thanks Ben!"
                                              otherButtonTitles: nil];
        [alert show];
        }
    }
    
    if (connection == closestConnection) {
        [self.mapView removeAnnotations:[self.mapView annotations]];
        NSLog(@"lat long:%@", [NSString stringWithUTF8String:[data bytes]]);
        NSString *bigString = [NSString stringWithUTF8String:[data bytes]];
        NSArray *latLong = [bigString componentsSeparatedByString:@";"];
        for (NSString *coordinates in latLong) {
            NSString *lat = [[coordinates componentsSeparatedByString:@","] objectAtIndex:0];
            NSString *lon = [[coordinates componentsSeparatedByString:@","] objectAtIndex:1];
            
            CLLocationCoordinate2D ctrpoint;
            ctrpoint.latitude = [lat floatValue];
            ctrpoint.longitude = [lon floatValue];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:ctrpoint];
            int randNum = rand() % (95 - 3) + 3; //create the random number.
            
            NSString *num = [NSString stringWithFormat:@"%d Points", randNum]; //Make the number into a string.

            [annotation setTitle:num]; //You can set the subtitle too
            [self.mapView addAnnotation:annotation];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTP" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
