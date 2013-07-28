//
//  ScavengerViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/28/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ScavengerViewController : UIViewController <CLLocationManagerDelegate> {
    NSString *DorC;
}

@property (nonatomic,retain)  CLLocationManager *locationManager;

@end
