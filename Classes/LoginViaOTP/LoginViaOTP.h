//
//  LoginViaOTP.h
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViaOTP : UIViewController

@property (assign, nonatomic) BOOL isFromRegisteration;
@property (strong, nonatomic) NSDictionary *prefilledDic;
@property (strong, nonatomic) NSDictionary *cardScanDic;

@property (weak, nonatomic) IBOutlet UIButton *sendOTPButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UIView *otpView;

- (IBAction)sendOTPButtonAction:(id)sender;
- (IBAction)loginButtonAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end
