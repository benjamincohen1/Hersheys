//
//  IntroViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSAnimatedImagesView.h"

@interface IntroViewController : UIViewController <UITextFieldDelegate, JSAnimatedImagesViewDataSource> {
    NSString *theUsername, *thePassword, *account;
    NSArray *imageArray;
}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet JSAnimatedImagesView *animatedImageView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end
