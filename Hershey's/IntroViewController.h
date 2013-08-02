//
//  IntroViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/27/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSAnimatedImagesView.h"

@interface IntroViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {
    NSString *theUsername, *thePassword, *account, *loginOrRegister;
    NSArray *imageArray;
}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *image1, *image2, *image3, *image4;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end
