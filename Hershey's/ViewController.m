//
//  ViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize username, password, pointsLabel;
- (void)viewDidLoad
{
    account = @"No";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *quick = [defaults objectForKey:@"username"];
    if (quick.length > 4) {
        NSLog(@"username %@", [defaults objectForKey:@"username"]);
        theUsername = [defaults objectForKey:@"username"];
        thePassword = [defaults objectForKey:@"password"];
    }
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLabel) name:@"pointsRefreshed" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)refreshLabel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    pointsLabel.text = [defaults objectForKey:@"points"];
}

- (IBAction)addPoints:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/money/add"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Ammount=10", appDelegate.acUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
    
    [self refreshLabel];

}

- (IBAction)removePoints:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/money/remove"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Ammount=10", appDelegate.acUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (IBAction)retrievePoints:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.acUsername.length < 4) {
        NSLog(@"%d", appDelegate.acUsername.length);
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
        NSString *request_body = [NSString stringWithFormat:@"Username=%@&Password=%@", appDelegate.acUsername, thePassword];
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

//- (IBAction)newAccount:(id)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.224.41.14:5000/users/new"]];
//    
//    NSLog(@"lglglg %@", appDelegate.acUsername);
//    //set HTTP Method
//    [request setHTTPMethod:@"POST"];
//
//    //Implement request_body for send request here username and password set into the body.
//    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Password=%@", appDelegate.acUsername, thePassword];
//    //set request body into HTTPBody.
//    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //set request url to the NSURLConnection
//    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [theConnection start];
//}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"heres data:%@", [NSString stringWithUTF8String:[data bytes]]);
    [pointsLabel setText:[NSString stringWithUTF8String:[data bytes]]];
    if ([[NSString stringWithUTF8String:[data bytes]] isEqualToString:@"ACCOUNT NOT CREATED"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username Taken"
                                                        message:@"The username has been taken. Please choose another one."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        account = @"No";
        [username becomeFirstResponder];
    }

    [self refreshLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
