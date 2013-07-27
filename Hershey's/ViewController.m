//
//  ViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize username, password;
- (void)viewDidLoad
{
    username.delegate = self;
    password.delegate = self;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addPoints:(id)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/money/add"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Ammount=10", theUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (IBAction)removePoints:(id)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/money/remove"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Ammount=10", theUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (IBAction)retrievePoints:(id)sender {
    if (theUsername.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Type in your username!"
                                                        message:@"Press OK to submit your data!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        NSLog(@"Hey");
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/users/money"]];
        
        //set HTTP Method
        [request setHTTPMethod:@"POST"];
        
        //Implement request_body for send request here username and password set into the body.
        NSString *request_body = [NSString stringWithFormat:@"Username=%@&Password=%@", theUsername, thePassword];
        //set request body into HTTPBody.
        [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //set request url to the NSURLConnection
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [theConnection start];
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Success!");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"This is the description: %@", textField.placeholder);
    NSString *whichText = [textField.placeholder stringByReplacingOccurrencesOfString:@"description: " withString:@""];
    if ([whichText isEqualToString:@"username"]) {
        theUsername = textField.text;
        [self retrievePoints:self];
    } else if ([whichText isEqualToString:@"password"]) {
        thePassword = textField.text;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"heres data:%@", [NSString stringWithUTF8String:[data bytes]]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
