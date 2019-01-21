//
//  ForgotPasswordViewController.h
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sendOTPButton;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UILabel *forgotLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UIView *otpView;

- (IBAction)sendOTPButtonAction:(id)sender;
- (IBAction)changePasswordButtonAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end
