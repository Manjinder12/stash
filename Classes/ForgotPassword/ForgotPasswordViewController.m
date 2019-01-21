//
//  ForgotPasswordViewController.m
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ChangePasswordViewController.h"


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
    [self.changePasswordButton setHidden:YES];
    
    [ApplicationUtils setFieldViewProperties:self.mobileView];
    [ApplicationUtils setFieldViewProperties:self.otpView];
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
        [dictParam setValue:@"generateForgotPasswordOTP"    forKey:@"mode"];
        [dictParam setValue:tf.text                         forKey:@"phone_no"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [ApplicationUtils showMessage:response[@"msg"] withTitle:@"" onView:self.view];
                [self.otpView setHidden:NO];
                [self.changePasswordButton setHidden:NO];
                [self.sendOTPButton setTitle:@"Resend OTP" forState:UIControlStateNormal];
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

    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validateMobileString]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid mobile number"];
    }
    else if (![ApplicationUtils validateStringData:otf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid OTP"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"resetPassword"                forKey:@"mode"];
        [dictParam setValue:tf.text                         forKey:@"phone_no"];
        [dictParam setValue:otf.text                        forKey:@"otp"];
        [dictParam setValue:tf.text                         forKey:@"password"]; //SK Change

        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
                [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
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
        return (newLength > OTP_LENGTH) ? NO : [string isEqualToString:filtered];
    }
    
    return YES;
}

@end
