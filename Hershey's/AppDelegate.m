//
//  AppDelegate.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize acUsername, acPassword, account, totalPoints;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Kiip *kiip = [[Kiip alloc] initWithAppKey:@"a1e4bece0a17a1a13cce774a5ca1f10a" andSecret:@"eeb15ac0472b6e045cb54d8c06ccf007"];
    kiip.delegate = self;
    [Kiip setSharedInstance:kiip];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    acUsername = [defaults objectForKey:@"username"];
    acPassword = [defaults objectForKey:@"password"];
    account = [defaults objectForKey:@"account"];
    totalPoints = [defaults objectForKey:@"points"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotal) name:@"RefreshTP" object:nil];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFB) name:@"RefreshStats" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStats) name:@"AccountCreated" object:nil];

    // Override point for customization after application launch.
    return YES;
}


- (void)refreshStats {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/users/money"]];
    
    NSLog(@"App Delegate %@", acUsername);
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@", acUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
    
}

- (void)refreshTotal {
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/users/money"]];
    NSLog(@"Refresh Total %@", acUsername);
    //set HTTP Method
    [request2 setHTTPMethod:@"POST"];

    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@", acUsername];
    //set request body into HTTPBody.
    [request2 setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];

    //set request url to the NSURLConnection
    NSURLConnection *theConnection2 = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];

    [theConnection2 start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Total Points: %@", [NSString stringWithUTF8String:[data bytes]]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    totalPoints = [NSString stringWithUTF8String:[data bytes]];
    [defaults setObject:totalPoints forKey:@"points"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"pointsRefreshed" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
