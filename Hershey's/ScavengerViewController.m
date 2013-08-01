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
@synthesize locationManager;

- (void)viewDidLoad
{
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
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([DorC isEqualToString:@"Drop"]) {
    NSLog(@"heres data:%@", [NSString stringWithUTF8String:[data bytes]]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drop Posted!"
                                                        message:@"Your gift has been sent!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Yay!"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woohoo!"
                                                        message:@"Thank Ben For Dropping This Gift!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Thanks Ben!"
                                              otherButtonTitles: nil];
        [alert show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTP" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
