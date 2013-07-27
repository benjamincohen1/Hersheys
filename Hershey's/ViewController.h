//
//  ViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate> {
    NSString *theUsername, *thePassword;
}

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *retrievePTS;
@property (weak, nonatomic) IBOutlet UIButton *removePTS;
@property (weak, nonatomic) IBOutlet UIButton *addPTS;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
