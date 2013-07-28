//
//  RedeemViewController.h
//  Hershey's
//
//  Created by Vijay Sridhar on 7/28/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemViewController : UIViewController <UITextFieldDelegate> {
    BOOL redeemCode;
}
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *redeemButton;

@end
