//
//  ViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <KiipSDK/KiipSDK.h>

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
    // add the last image (image4) into the first position
	[self addImageWithName:@"image4.jpg" atPosition:0];
	
	// add all of the images to the scroll view
	for (int i = 1; i < 5; i++) {
		[self addImageWithName:[NSString stringWithFormat:@"image%i.jpg",i] atPosition:i];
	}
	
	// add the first image (image1) into the last position
	[self addImageWithName:@"image1.jpg" atPosition:5];
	
	scrollView.contentSize = CGSizeMake(1920, 197);
	[scrollView scrollRectToVisible:CGRectMake(320,0,320,197) animated:NO];

    [self retrievePoints:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKiipReward) name:@"kiip" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)addImageWithName:(NSString*)imageString atPosition:(int)position {
	// add image to scroll view
	UIImage *image = [UIImage imageNamed:imageString];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(position*320, 0, 320, 197);
	[scrollView addSubview:imageView];
}

- (void)refreshLabel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    pointsLabel.text = [defaults objectForKey:@"points"];
}

- (void)showKiipReward {
    [[Kiip sharedInstance] saveMoment:@"Test Moment" withCompletionHandler:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
	NSLog(@"%f",scrollView.contentOffset.x);
	// The key is repositioning without animation
	if (scrollView.contentOffset.x == 0) {
		// user is scrolling to the left from image 1 to image 4
		// reposition offset to show image 4 that is on the right in the scroll view
		[scrollView scrollRectToVisible:CGRectMake(1280,0,320,197) animated:NO];
	}
	else if (scrollView.contentOffset.x == 1600) {
		// user is scrolling to the right from image 4 to image 1
		// reposition offset to show image 1 that is on the left in the scroll view
		[scrollView scrollRectToVisible:CGRectMake(320,0,320,197) animated:NO];
	}
}


- (IBAction)addPoints:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/money/add"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Ammount=15", appDelegate.acUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (IBAction)removePoints:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/money/remove"]];
    
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Ammount=15", appDelegate.acUsername];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (IBAction)retrievePoints:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTP" object:nil];    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Success!");
}

//- (IBAction)newAccount:(id)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/users/new"]];
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
    
    if ([[NSString stringWithUTF8String:[data bytes]] isEqualToString:@"FAILURE"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Negative Points"
                                                        message:@"Accounts can't have negative points. The '-' button removes 10 points. '+' adds 15. PROTOTYPE ONLY FEATURE!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        [pointsLabel setText:[NSString stringWithUTF8String:[data bytes]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
