//
//  RedeemViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/28/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "RedeemViewController.h"
#import "AppDelegate.h"

@interface RedeemViewController ()

@end

@implementation RedeemViewController
@synthesize codeTextfield;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)redeemCode:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/codes/redeem"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Code=%@", appDelegate.acUsername, codeTextfield.text];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Redeem data:%@", [NSString stringWithUTF8String:[data bytes]]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithUTF8String:[data bytes]] forKey:@"pointsAdded"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTP" object:nil];
    [self performSegueWithIdentifier:@"RedeemBack" sender:self];
    if ([[NSString stringWithUTF8String:[data bytes]] isEqualToString:@"ACCOUNT NOT CREATED"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username Taken"
                                                        message:@"The username has been taken. Please choose another one."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
