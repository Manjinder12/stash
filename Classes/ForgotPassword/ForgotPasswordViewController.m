//
//  ForgotPasswordViewController.m
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.forgotLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.staticLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.sendOTPButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.changePasswordButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.otpView setHidden:YES];
    [self.passwordView setHidden:YES];
    [self.changePasswordButton setHidden:YES];
    
    [ApplicationUtils setFieldViewProperties:self.mobileView];
    [ApplicationUtils setFieldViewProperties:self.otpView];
    [ApplicationUtils setFieldViewProperties:self.passwordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.sendOTPCenterConstraint.constant = [AppDelegate instance].window.center.x/2;
}

- (IBAction)sendOTPButtonAction:(id)sender {
    
    UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    UITextField *ptf = (UITextField *)[self.passwordView viewWithTag:101];
    otf.text = @"";
    ptf.text = @"";

    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validateMobileString]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid mobile number"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"generateForgotPasswordOTP"    forKey:@"mode"];
        [dictParam setValue:tf.text                         forKey:@"phone_no"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                self.sendOTPCenterConstraint.constant = [AppDelegate instance].window.frame.size.width/128;

                [ApplicationUtils showMessage:response[@"msg"] withTitle:@"" onView:self.view];
                [self.otpView setHidden:NO];
                [self.passwordView setHidden:NO];
                [self.changePasswordButton setHidden:NO];
                
                [self.sendOTPButton disableButtonAndStartTimer];
            }
        }];
    }
}

- (IBAction)backAction:(id)sender {
    [ApplicationUtils popVCWithFadeAnimation:self.navigationController];
}

- (IBAction)changePasswordButtonAction:(id)sender {
    UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    UITextField *ptf = (UITextField *)[self.passwordView viewWithTag:101];

    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validateMobileString]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid mobile number"];
    }
    else if (![ApplicationUtils validateStringData:otf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid OTP"];
    }
    else if (![ApplicationUtils validateStringData:ptf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter Password"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"resetPassword"                forKey:@"mode"];
        [dictParam setValue:tf.text                         forKey:@"phone_no"];
        [dictParam setValue:otf.text                        forKey:@"otp"];
        [dictParam setValue:ptf.text                        forKey:@"password"];

        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:[ApplicationUtils validateStringData:response[@"msg"]] cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
                    
                    [self backAction:nil];
                    
                }] otherButtonItems: nil];
                [[AlertViewManager sharedManager].alertView show];
            }
        }];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    UITextField *tf = (UITextField *)[self.mobileView viewWithTag:101];
    
    if(textField == tf){
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

@end
