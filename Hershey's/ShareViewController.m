//
//  ShareViewController.m
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "ShareViewController.h"
#import "MGInstagram.h"
#import "AppDelegate.h"
#import <Social/Social.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)openTheTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                    //  This means the user cancelled without sending the Tweet
                case SLComposeViewControllerResultCancelled:
                    break;
                    //  This means the user hit 'Send'
                case SLComposeViewControllerResultDone:
                    break;
            }
            
            //  dismiss the Tweet Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    if (result == SLComposeViewControllerResultCancelled) {
                    } else if (result == SLComposeViewControllerResultDone) {
                        // Do Something If Tweeted.
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/twitter/sent"]];

                        NSLog(@"GFFFF Delegate %@", appDelegate.acUsername);
                        //set HTTP Method
                        [request setHTTPMethod:@"POST"];
                        
                        //Implement request_body for send request here username and password set into the body.
                        NSString *request_body = [NSString stringWithFormat:@"Username=%@", appDelegate.acUsername];
                        //set request body into HTTPBody.
                        [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        //set request url to the NSURLConnection
                        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [theConnection start];
                    }
                }];
            });
        };
        
        //  Set the initial body of the Tweet
        [tweetSheet setInitialText:@"Spread Love. Share Happiness. Send a smile. #hersheys"];
        
        //  Presents the Tweet Sheet to the user
        [self presentViewController:tweetSheet animated:YES completion:^{
            NSLog(@"Tweet sheet has been presented.");
        }];
    }

}

- (IBAction)openTheFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        SLComposeViewController *fbSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        fbSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                    //  This means the user cancelled without sending the FB Status
                case SLComposeViewControllerResultCancelled:
                    break;
                    //  This means the user hit 'Send'
                case SLComposeViewControllerResultDone:
                    NSLog(@"SENT");
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/facebook/sent"]];
                    NSLog(@"GFFFF Delegate %@", appDelegate.acUsername);
                    //set HTTP Method
                    [request setHTTPMethod:@"POST"];
                    
                    //Implement request_body for send request here username and password set into the body.
                    NSString *request_body = [NSString stringWithFormat:@"Username=%@", appDelegate.acUsername];
                    //set request body into HTTPBody.
                    [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    //set request url to the NSURLConnection
                    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    
                    [theConnection start];

                    break;
            }
            
            //  dismiss the FB Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                
                }];
            });
        };
        
        //  Set the initial body of the Tweet
        [fbSheet setInitialText:@"Spread Love. Share Happiness. Send a smile. #hersheys"];
        
        //  Presents the Tweet Sheet to the user
        [self presentViewController:fbSheet animated:YES completion:^{
            NSLog(@"Facebook sheet has been presented.");
        }];
    }
    
}

- (IBAction)openInstagram:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.instagramImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = self.instagramImage;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([MGInstagram isAppInstalled] == YES) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-184-169-235-149.us-west-1.compute.amazonaws.com/facebook/sent"]];
            NSLog(@"GFFFF Delegate %@", appDelegate.acUsername);
            //set HTTP Method
            [request setHTTPMethod:@"POST"];
            
            //Implement request_body for send request here username and password set into the body.
            NSString *request_body = [NSString stringWithFormat:@"Username=%@", appDelegate.acUsername];
            //set request body into HTTPBody.
            [request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
            
            //set request url to the NSURLConnection
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [theConnection start];
            [MGInstagram postImage:self.instagramImage withCaption:@"Share the love #hersheys" inView:self.view];
        }
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTP" object:nil];
    [self performSegueWithIdentifier:@"GoBack" sender:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
