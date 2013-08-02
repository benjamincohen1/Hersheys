//
//  KiipConnectViewController.m
//  Hershey's
//
//  Created by Development Account on 8/2/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "KiipConnectViewController.h"

@interface KiipConnectViewController ()

@end

@implementation KiipConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
