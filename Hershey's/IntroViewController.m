//
//  IntroViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "IntroViewController.h"
#import "AppDelegate.h"

@interface IntroViewController ()

@end

@implementation IntroViewController
@synthesize username, password, scrollView, image3, image1, image2, image4, pageControl;

- (void)viewDidLoad
{
    account = @"No";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username.delegate = self;
    password.delegate = self;
    NSString *quick = [defaults objectForKey:@"username"];
    if (quick.length > 4) {
        NSLog(@"username %@", [defaults objectForKey:@"username"]); 
        username.hidden = YES;
        password.hidden = YES;
        theUsername = [defaults objectForKey:@"username"];
        thePassword = [defaults objectForKey:@"password"];
    }
    image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollView1.png"]];

    image1.frame = CGRectMake(0, 0, 1280, 300);
    [scrollView addSubview:image1];
    scrollView.contentSize = CGSizeMake(1280, 300);
    username.background = [UIImage imageNamed:@"usrpass.png"];
    password.background = [UIImage imageNamed:@"usrpass.png"];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    imageArray = [NSArray arrayWithObjects:@"BGImage1", @"BGImage2", @"BGImage3", nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)changePage:(id)sender {
    CGFloat x = pageControl.currentPage * scrollView.frame.size.width;
    [scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScroll  {
    NSInteger pageNumber = round(scrollView.contentOffset.x / 320);
    pageControl.currentPage = pageNumber;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *whichText = [textField.placeholder stringByReplacingOccurrencesOfString:@"description: " withString:@""];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Which Text: %@", whichText);
    if ([whichText isEqualToString:@"username"]) {
        theUsername = textField.text;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:theUsername forKey:@"username"];
        appDelegate.acUsername = theUsername;
        NSLog(@"Username %@", theUsername);
        [password becomeFirstResponder];
    } else if ([whichText isEqualToString:@"password"]) {
        thePassword = textField.text;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:thePassword forKey:@"password"];
        appDelegate.acPassword = thePassword;
        NSLog(@"Password %@", thePassword);
        [self newAccount:self];
    }
    return YES;
}


- (IBAction)newAccount:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/users/new"]];
    
    NSLog(@"New Account Username is: %@", appDelegate.acUsername);
    //set HTTP Method
    [request setHTTPMethod:@"POST"];
    
    //Implement request_body for send request here username and password set into the body.
    NSString *request_body = [NSString stringWithFormat:@"Username=%@&Password=%@", appDelegate.acUsername, appDelegate.acPassword];
    //set request body into HTTPBody.
    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set request url to the NSURLConnection
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"heres data:%@", [NSString stringWithUTF8String:[data bytes]]);
    if ([[NSString stringWithUTF8String:[data bytes]] isEqualToString:@"ACCOUNT NOT CREATED"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username Taken"
                                                        message:@"The username has been taken. Please choose another one."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        //[alert show];
        account = @"No";
        [username becomeFirstResponder];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountCreated" object:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.account = @"Yes";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Yes" forKey:@"account"];
    [self performSegueWithIdentifier:@"DoneAccount" sender:self];
}

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return 3;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    NSLog(@"%d", index);
    return [UIImage imageNamed:[imageArray objectAtIndex:index]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
