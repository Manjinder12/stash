//
//  LoginViaOTP.m
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "LoginViaOTP.h"
#import "SignupViewController.h"
#import "HomeViewController.h"


@interface LoginViaOTP ()

@end

@implementation LoginViaOTP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loginLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.sendOTPButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.loginButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.otpView setHidden:YES];
    [self.loginButton setHidden:YES];
    
    [ApplicationUtils setFieldViewProperties:self.mobileView];
    [ApplicationUtils setFieldViewProperties:self.otpView];
    
    if (self.isFromRegisteration) {
        [self.loginLabel setText:@"Sign Up"];
        [self.loginButton setTitle:@"Register" forState:UIControlStateNormal];
        
        if (self.cardScanDic) {
            NSString *mobileNumber = [ApplicationUtils validateStringData:self.prefilledDic[MOBILE_NUMBER_KEY]];
            
            if (mobileNumber.length) {
                UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];
                [tf setText:mobileNumber];
                [tf setEnabled:NO];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendOTPButtonAction:(id)sender {

    UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    otf.text = @"";
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validateMobileString]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid mobile number"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];

        if (self.isFromRegisteration) {
            [dictParam setValue:@"SendOTPBeforeRegistration"    forKey:@"mode"];
            [dictParam setValue:tf.text                         forKey:@"phone_number"];
        }
        else {
            [dictParam setValue:@"generateOTPForLogin"          forKey:@"mode"];
            [dictParam setValue:tf.text                         forKey:@"number"];
        }
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [ApplicationUtils showMessage:response[@"msg"] withTitle:@"" onView:self.view];
                [self.otpView setHidden:NO];
                [self.loginButton setHidden:NO];
                
                [self.sendOTPButton disableButtonAndStartTimer];
            }
        }];
    }
}

- (IBAction)backAction:(id)sender {
    [ApplicationUtils popVCWithFadeAnimation:self.navigationController];
}

- (IBAction)loginButtonAction:(id)sender {
    
    UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];

    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validateMobileString]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid mobile number"];
    }
    else if (![ApplicationUtils validateStringData:otf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid OTP"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];

        if (self.isFromRegisteration) {
            [dictParam setValue:tf.text                             forKey:@"phone_number"];
            [dictParam setValue:otf.text                            forKey:@"otp"];
            [dictParam setValue:@"verifyNumberBeforeRegistration"   forKey:@"mode"];
        }
        else {
            [dictParam setValue:tf.text                         forKey:@"number"];
            [dictParam setValue:otf.text                        forKey:@"otp"];
            [dictParam setValue:@"login"                        forKey:@"mode"];
            [dictParam setValue:@"iOS"                          forKey:@"source"];
            [dictParam setValue:[ApplicationUtils getDeviceID]  forKey:@"device_id"];
        }

        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                if (self.isFromRegisteration) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.prefilledDic];
                    [dic setValue:tf.text forKey:MOBILE_NUMBER_KEY];
                    
                    SignupViewController *obj = [[SignupViewController alloc] init];
                    [obj setPrefilledDic:dic];
                    [obj setCardScanDic:self.cardScanDic];
                    [self.navigationController popViewControllerAnimated:NO];
                    [ApplicationUtils pushVCWithFadeAnimation:obj andNavigationController:[AppDelegate instance].homeNavigationControler];
                }
                else {
                    [[AppDelegate instance] navigateToCorrespondingScreenAfterLoginWithResponse:response withController:self];
                }
            }
        }];
    }
}

- (void)navigateToSignUpScreenStep:(NSInteger)step {
    SignupViewController *obj = [[SignupViewController alloc] init];
    [obj setLandingPage:step];
    [self.navigationController popViewControllerAnimated:NO];
    [ApplicationUtils pushVCWithFadeAnimation:obj andNavigationController:[AppDelegate instance].homeNavigationControler];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];

    if(textField == tf){
        if (!self.otpView.hidden) {
            [self.otpView setHidden:YES];
            [self.loginButton setHidden:YES];
            [self.sendOTPButton setTitle:@"Send OTP" forState:UIControlStateNormal];
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > MOBILE_NUMBER_LENGTH) ? NO : [string isEqualToString:filtered];
     }
    
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    
    if(textField == otf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > MAX_OTP_LENGTH) ? NO : [string isEqualToString:filtered];
    }

    return YES;
}

/*
 {
 "auth_token" = 50ad092074c91ee6ec8a0e9cd1bf2037a0d74564b9e49ddfc0417e29986806f8;
 "card_status" =     {
 "card_found" = 0;
 "card_registered" = 0;
 "otp_verified" = 0;
 };
 "customer_id" = 95255;
 "customer_name" = "TESTGCGHH TYGG";
 dob = "1990-05-22";
 email = "depp@gmail.com";
 "landing_page" = professional;
 lastDeviceLogDates =     {
 lastAppDate = "<null>";
 lastCalenderDate = "<null>";
 lastCallDate = "<null>";
 lastContactDate = "<null>";
 lastSmsDate = "<null>";
 };
 "latest_loan_details" =     {
 "current_status" = start;
 "loan_creation_date" = "22-May-2018";
 "loan_id" = 108149;
 "requested_amount" = "";
 "requested_rate" = "";
 "requested_tenure" = "";
 };
 "loan_id" = 108149;
 "loan_status" = "Incomplete Application";
 phone = 9535653595;
 "profile_pic" = "";
 "signature_upload" = 0;
 }
 */

@end
