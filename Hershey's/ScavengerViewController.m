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
        
        longitude = coordinate.longitude;
        latitude = coordinate.latitude;
    
    MKCoordinateRegion coordinateRegion;   //Creating a local variable
    
    coordinateRegion.center = coordinate;  //See notes below
    coordinateRegion.span.latitudeDelta = .08;
    coordinateRegion.span.longitudeDelta = .08;
    
    [mapView setRegion:coordinateRegion animated:YES];
    
    [self forceRefresh];

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
        dropConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [dropConnection start];
        
    } else if ([DorC isEqualToString:@"Collect"]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/map/collect"]];
        
        //set HTTP Method
        [request setHTTPMethod:@"POST"];
        
        //Implement request_body for send request here username and password set into the body.
        NSString *request_body = [NSString stringWithFormat:@"Username=%@&lat=%f&lon=%f", appDelegate.acUsername, latitude, longitude];
        //set request body into HTTPBody.
        [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set request url to the NSURLConnection
        collectConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [collectConnection start];
    }
    
}

- (void)forceRefresh {
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
    if (connection == dropConnection) {
        NSLog(@"Dropped: %@", [NSString stringWithUTF8String:[data bytes]]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drop Posted!"
                                                        message:@"Your gift has been sent!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Yay!"
                                              otherButtonTitles: nil];
        [alert show];
        
        [self forceRefresh];
    }
    
    if (connection == collectConnection) {
        NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
        NSString *points = [NSString stringWithUTF8String:[data bytes]];
        if ([points isEqualToString:@"0\n"]) {
            NSLog(@"Yes");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No drops are close enough!"
                                                            message:@"Move closer to a drop point to pickup the drop."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Moving..."
                                                  otherButtonTitles: nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woohoo!"
                                                            message:@"You picked up a drop from Harrison H."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Thanks Harrison!"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        [self forceRefresh];
    }
    
//    if ([DorC isEqualToString:@"Drop"]) {
//        if (connection == closestConnection) {} else {
//        NSLog(@"Dropped: %@", [NSString stringWithUTF8String:[data bytes]]);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drop Posted!"
//                                                        message:@"Your gift has been sent!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Yay!"
//                                              otherButtonTitles: nil];
//        [alert show];
//        }
//    } else if ([DorC isEqualToString:@"Collect"]) {
//        if (connection == closestConnection) {} else {
//            NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
//            NSString *points = [NSString stringWithUTF8String:[data bytes]];
//            if ([points isEqualToString:@"0\n"]) {
//                NSLog(@"Yes");
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No drops are close enough!"
//                                                                message:@"Move closer to a drop point to pickup the drop."
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Moving..."
//                                                      otherButtonTitles: nil];
//                [alert show];
//            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woohoo!"
//                                                        message:@"You picked up a drop from Harrison H."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Thanks Harrison!"
//                                              otherButtonTitles: nil];
//                [alert show];
//            }
//        }
//    }
    
    if (connection == closestConnection) {
        [self.mapView removeAnnotations:[self.mapView annotations]];
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTP" object:nil];
        }
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
