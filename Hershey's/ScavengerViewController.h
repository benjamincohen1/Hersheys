//
//  ScavengerViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/28/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ScavengerViewController : UIViewController <CLLocationManagerDelegate> {
    NSString *DorC;
    NSURLConnection *closestConnection;
}

@property (nonatomic,retain)  CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
