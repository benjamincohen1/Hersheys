//
//  ViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {
    NSString *theUsername, *thePassword, *account;
    IBOutlet UIScrollView *scrollView;
}

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *retrievePTS;
@property (weak, nonatomic) IBOutlet UIButton *removePTS;
@property (weak, nonatomic) IBOutlet UIButton *addPTS;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, retain) UIScrollView *scrollView;

- (void)addImageWithName:(NSString*)imageString atPosition:(int)position;

@end
