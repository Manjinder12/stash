//
//  EmailLoginViewController.m
//  StashFin
//
//  Created by sachin khard on 21/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "LoginViaOTP.h"


@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.loginLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.orLabel.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.loginviaOTPButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.forgotPasswordButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.loginButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

    [ApplicationUtils setFieldViewProperties:self.emailView];
    [ApplicationUtils setFieldViewProperties:self.passwordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonAction:(id)sender {
    UITextField *etf = (UITextField *)[self.emailView viewWithTag:101];
    UITextField *ptf = (UITextField *)[self.passwordView viewWithTag:101];

    //SK Change
//    etf.text = @"ankur.bagla@stashfin.com";
//    ptf.text = @"123456789";

//    etf.text = @"raviprakashlts@gmail.com";
//    ptf.text = @"12345678";

//    etf.text = @"pc@stashfin.com";
//    ptf.text = @"123456";

    //Dev Environment
//    etf.text = @"ravi.prakash@stashfin.com";
//    ptf.text = @"123456";

    if (![ApplicationUtils validateStringData:etf.text].length || ![etf.text isEmail]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid email"];
    }
    else if (![ApplicationUtils validateStringData:ptf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid password"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"login"                        forKey:@"mode"];
        [dictParam setValue:etf.text                        forKey:@"email"];
        [dictParam setValue:ptf.text                        forKey:@"password"];
        [dictParam setValue:@"iOS"                          forKey:@"source"];
        [dictParam setValue:[ApplicationUtils getDeviceID]  forKey:@"device_id"];

        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [[AppDelegate instance] navigateToCorrespondingScreenAfterLoginWithResponse:response withController:self];
            }
        }];
    }
}

- (IBAction)loginviaOTPButtonAction:(id)sender {
    LoginViaOTP *vc = [[LoginViaOTP alloc] initWithNibName:@"LoginViaOTP" bundle:nil];
    [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
}

- (IBAction)forgotPasswordButtonAction:(id)sender {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
