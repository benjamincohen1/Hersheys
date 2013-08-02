//
//  AppDelegate.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KiipSDK/KiipSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, KiipDelegate> {
    NSURLConnection *totalPoint, *facebookAdd;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *acUsername, *acPassword, *totalPoints, *account;

@end
