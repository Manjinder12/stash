//
//  LoginScreen.m
//  Stasheasy
//
//  Created by duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LoginScreen.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "UserServices.h"
#import "CommonFunctions.h"
#import "ServerCall.h"
#import "REFrostedViewController.h"
#import "RejectedVC.h"
#import "SignupScreen.h"
#import "StatusVC.h"
#import "AppDelegate.h"
#import "LandingVC.h"
#import "SignupScreen.h"

@interface LoginScreen ()<UITextFieldDelegate>
{
    AppDelegate *appDelegate;
    UserServices *service;
    NSMutableDictionary *param;
    REFrostedViewController *refrostedVC;
    NSDictionary *dictLoginResponse;
    BOOL isLoginWithOTP, isVerifyOtpGenerated, isForgot;
    NSString *strMobileOTP;
    NSInteger time;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtForgotMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtForgotOTP;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassord;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileOTP;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnsForgotViewHeight;


@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyOTP;

@property (weak, nonatomic) IBOutlet UILabel *lblMobileNo;


@property (weak, nonatomic) IBOutlet UIView *viewForgotPopUp;
@property (weak, nonatomic) IBOutlet UIView *viewOTPLogin;
@property (weak, nonatomic) IBOutlet UIView *viewEmailLogin;
@property (weak, nonatomic) IBOutlet UIView *viewMobileOTP;
@property (weak, nonatomic) IBOutlet UIView *viewOtpVerify;
@property (weak, nonatomic) IBOutlet UIView *viewForgotInner;

@property (weak, nonatomic) IBOutlet UIButton *btnSendOTP;
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;
@property (weak, nonatomic) IBOutlet UIButton *btnGenerateOTP;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnsMobileOtpHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnsForgotInnerViewHeight;

@end

@implementation LoginScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ self customInitialization ];
}
- (void)customInitialization
{
    appDelegate = [ AppDelegate sharedDelegate ];
    service = [[UserServices alloc] init];
    param = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    isLoginWithOTP = NO;
    strMobileOTP = @"";
    _viewForgotPopUp.hidden = YES;
    _viewForgotInner.hidden = YES;
    _viewMobileOTP.hidden = YES;
    _viewOTPLogin.hidden = YES;
    _viewOtpVerify.hidden = YES;
    _lblAlert.hidden = YES;

    isVerifyOtpGenerated = NO;
    _cnsMobileOtpHeight.constant = 0;
    
    _txtNewPassord.secureTextEntry = YES;
    
    [ Utilities setBorderAndColor:_btnSendOTP ];
    [ Utilities setBorderAndColor:_btnChangePassword ];
    
    _cnsForgotViewHeight.constant = _cnsForgotViewHeight.constant - _cnsForgotInnerViewHeight.constant;
    _cnsForgotInnerViewHeight.constant = 0;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gesture];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark Textfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField == _txtMobile || textField == _txtForgotMobile)
    {
        if ( (_txtMobile.text.length >= 10 || _txtForgotMobile.text.length >= 10) && range.length == 0 )
        {
            return NO;
        }
        else
            return YES;

    }

    else if ( textField == _txtMobileOTP || textField == _txtForgotOTP || textField == _txtVerifyOTP )
    {
        if (textField.text.length >= 4 && range.length == 0 )
        {
            return NO;
        }
        else
            return YES;
    }
    else
    {
        return YES;
    }
}
#pragma mark Button Action
- (IBAction)loginAction:(id)sender
{
    if ([self performValidation])
    {
        [self.view endEditing:YES];
        [self serverCallForLogin];
    }
}

- (IBAction)changePasswordAction:(id)sender
{
    if ( _txtNewPassord.text.length < 8 )
    {
        [ Utilities showAlertWithMessage:@"Password should be of miminum 8 characters" ];
    }
    else
    {
        [ self serverCallForChangePassword ];
    }
}
- (IBAction)backAction:(id)sender
{
    if ( !appDelegate.isPreApproved )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        AppDelegate *appdelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        LandingVC *vc = (LandingVC *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingVC"] ;
        UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
        navigationController.viewControllers = @[vc];
        navigationController.navigationBar.hidden = YES;
        appdelegate.window.rootViewController = navigationController;
    }
}
- (IBAction)otpLoginAction:(id)sender
{
    isLoginWithOTP = YES;
    _viewEmailLogin.hidden = YES;
    _viewOTPLogin.hidden = NO;
}
- (IBAction)sendOTPAction:(id)sender
{
    if ( _txtForgotMobile.text.length == 0 )
    {
        [ Utilities showAlertWithMessage:@"Enter mobile number." ];
    }
    else if ( _txtForgotMobile.text.length < 10 || _txtMobile.text.length > 11)
    {
        [ Utilities showAlertWithMessage:@"Enter valid mobile number." ];
    }
    else
    {
        [ self serverCallToGenerateForgotPasswordOTP];
    }
}
- (IBAction)generateOtpAction:(id)sender
{
    if ( _txtMobile.text.length == 0 )
    {
        [ Utilities showAlertWithMessage:@"Enter mobile number." ];
    }
    else if ( _txtMobile.text.length < 10 || _txtMobile.text.length > 10)
    {
        [ Utilities showAlertWithMessage:@"Enter valid mobile number." ];
    }
    else
    {
        isForgot = NO;
        [ _txtMobile resignFirstResponder ];
        [ self serverCallToGenerateOTPForLogin ];
      
        /*if ( ! isGenerateOTPView )
        {
            [ _btnGenerateOTP setTitle:@"RESEND OTP" forState:UIControlStateNormal];
            
            isGenerateOTPView = YES;
            _viewMobileOTP.hidden = NO;
            _cnsMobileOtpHeight.constant = 26;
        }*/
    }
}
- (IBAction)emailLoginAction:(id)sender
{
    isLoginWithOTP = NO;
    _viewEmailLogin.hidden = NO;
    _viewOTPLogin.hidden = YES;

}
- (IBAction)forgotPasswordAction:(id)sender
{
    if ( ![timer isValid] )
    {
        isForgot = YES;
        _viewForgotPopUp.hidden = NO;
        [ self showPopupView:_viewForgotPopUp onViewController:self ];
    }
}
- (IBAction)verifyAction:(id)sender
{
    [ self serverCallToSubmitOTPForVerification ];
}
- (IBAction)resendVerifyOtpAction:(id)sender
{
    [ self serverCallToGenerateOTPForLogin ];
}
-(BOOL)performValidation
{
    if ( !isLoginWithOTP )
    {
        NSString *message;
        if ([_txtEmail.text isEqualToString:@""])
        {
            message = @"Please enter email";
        }
        else if ([_txtPassword.text isEqualToString:@""])
        {
            message = @"Please enter password";
        }
        else
        {
            [param setObject:_txtEmail.text forKey:@"email"];
            [param setObject:_txtPassword.text forKey:@"password"];
            [param setObject:@"login" forKey:@"mode"];
            [param setObject:[NSString stringWithFormat:@"%@",[Utilities getDeviceUDID]] forKey:@"device_id"];
            return YES;
        }
        
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"StashFin" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    else
    {
        [param setObject:_txtMobile.text forKey:@"number"];
        [param setObject:_txtMobileOTP.text forKey:@"otp"];
        [param setObject:@"login" forKey:@"mode"];
        [param setObject:[NSString stringWithFormat:@"%@",[Utilities getDeviceUDID]] forKey:@"device_id"];
        return YES;
    }
}

#pragma mark - Server Call
- (void)serverCallForLogin
{
    [ SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack ];
    [ SVProgressHUD show ];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
    {
        NSLog(@"response === %@", response);

        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
                [ SVProgressHUD dismiss ];
            }
            else
            {
                dictLoginResponse = response;
                [Utilities setUserDefaultWithObject:[ response objectForKey:@"auth_token"] andKey:@"auth_token"];

                if ( [appDelegate.dictCustomer [@"landing_page"] isEqualToString:@"profile"] && ([appDelegate.dictCustomer [@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] || [appDelegate.dictCustomer [@"latest_loan_details"][@"current_status"] isEqualToString:@"closed"] ))
                {
                    [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
                    [Utilities setUserDefaultWithObject:@"1" andKey:@"isLoanDisbursed"];
                    [ self serverCallForCardOverview ];
                }
                else if ( [response[@"landing_page"] isEqualToString:@"otp_verification"] )
                {
                    [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];
                    [Utilities setUserDefaultWithObject:@"0" andKey:@"isLoanDisbursed"];

                    isVerifyOtpGenerated = YES;
                    _lblMobileNo.text = [ NSString stringWithFormat:@"%@",dictLoginResponse[@"phone"]];
                    [ self serverCallToGenerateOTPToVerifyMobileNumber ];
                }
                else
                {
                    [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
                    [Utilities setUserDefaultWithObject:@"0" andKey:@"isLoanDisbursed"];

                    appDelegate.dictCustomer = ( NSMutableDictionary * )response;
                    [self navigateAccordingLandingPageStatus:dictLoginResponse];
                }
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
            [ SVProgressHUD dismiss ];
        }
    }];
}

- (void)serverCallForCardOverview
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObject:@"cardOverview" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 appDelegate.isCardFound = NO;
             }
             else
             {
                 
                 appDelegate.isCardFound = YES;
             }
             
             [ self serverCallForPersonalDetail ];
         }
         else
         {
             [ Utilities showAlertWithMessage:@"Card not found"];
            
             [ SVProgressHUD dismiss ];
         }
         
    }];
}
- (void)serverCallForPersonalDetail
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObject:@"getLoginData" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 appDelegate.dictCustomer = [NSMutableDictionary dictionaryWithDictionary:response];
             }
             
             [self navigateAccordingLandingPageStatus:dictLoginResponse];
         }
         else
         {

         }
         
         [ SVProgressHUD dismiss ];
     }];
}
- (void)serverCallToGenerateOTPForLogin
{
    NSMutableDictionary *dictParam = [ NSMutableDictionary dictionary ];
    [ dictParam setObject:@"generateOTPForLogin" forKey:@"mode" ];
    [ dictParam setObject:_txtMobile.text forKey:@"number" ];
    [ dictParam setObject:strMobileOTP forKey:@"otp" ];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             _txtMobileOTP.text = @"";
             
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [Utilities showAlertWithMessage:response[@"msg"]];
                 strMobileOTP = [ NSString stringWithFormat:@"%d", [response[@"otp"] intValue]];
                 [ _btnGenerateOTP setTitle:@"GENERATE OTP" forState:UIControlStateNormal];
                 isVerifyOtpGenerated = NO;
                 _viewMobileOTP.hidden = NO;
                 _cnsMobileOtpHeight.constant = 26;
                 [ self startTimer ];

            }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];

}
- (void)serverCallToGenerateOTPToVerifyMobileNumber
{
    NSMutableDictionary *dictParam = [ NSMutableDictionary dictionary ];
    [ dictParam setObject:@"generateOtp" forKey:@"mode" ];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
     {
         NSLog(@" generateOtp response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                [ self showPopupView:_viewOtpVerify onViewController:self ];
                 
                 _lblMobileNo.text = @"";
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}
- (void)serverCallToSubmitOTPForVerification
{
    NSDictionary *dictParam = [ NSDictionary dictionaryWithObjectsAndKeys:@"mode",@"submitOtp",_txtVerifyOTP.text,@"otp", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [Utilities setUserDefaultWithObject:@"1" andKey:@"isOtpVerify"];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
    
}
- (void)serverCallToGenerateForgotPasswordOTP
{
    NSMutableDictionary *dictParam = [ NSMutableDictionary dictionary ];
    [ dictParam setObject:@"generateForgotPasswordOTP" forKey:@"mode" ];
    [ dictParam setObject:_txtForgotMobile.text forKey:@"phone_no" ];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 isForgot = YES;
                 _viewForgotInner.hidden = NO;
                 _cnsForgotViewHeight.constant = 270;
                 _cnsForgotInnerViewHeight.constant = 127;
                 [_btnSendOTP setTitle:@"RESEND OTP" forState:UIControlStateNormal];
                 [ self startTimer ];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
    
}
- (void)serverCallForChangePassword
{
    NSMutableDictionary *dictParam = [ NSMutableDictionary dictionary ];
    [ dictParam setObject:@"resetPassword" forKey:@"mode" ];
    [ dictParam setObject:_txtForgotOTP.text forKey:@"otp" ];
    [ dictParam setObject:_txtNewPassord.text forKey:@"password" ];
    [ dictParam setObject:_txtForgotMobile.text forKey:@"phone_no" ];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"resetPassword response === %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [ Utilities showAlertWithMessage:errorStr ];
             }
             else
             {
                 [ Utilities showAlertWithMessage:response[@"msg"] ];
                 [ self hidePopupView:_viewForgotPopUp fromViewController:self ];
             }
         }
         else
         {
             [ SVProgressHUD dismiss ];
         }
         
     }];
}
-(void)loginApiCall
{
    if ([CommonFunctions reachabiltyCheck]) {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        NSString *post =[NSString stringWithFormat:@"mode=login&device_id=%@&email=%@&password=%@",[param objectForKey:@"device_id"],[param objectForKey:@"email"],[param objectForKey:@"password"]];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
                NSString *errorStr = [responseDic objectForKey:@"error"];
                if (errorStr.length>0) {
                    [self showAlertWithTitle:@"stasheasy" withMessage:errorStr];
                    UIViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
                }
                else {
                    UIViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
                    [CommonFunctions setUserDefault:@"islogin" value:@"1"];
                }
            });
        }]
         
         resume
         ];

    } else {
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
}

#pragma mark UIAlertController Delegate
-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message
{
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:atitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)navigateAccordingLandingPageStatus:(NSDictionary *)response
{
    if ( [response[@"landing_page"] isEqualToString:@"rejected"] )
    {
        RejectedVC *rejectedVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"RejectedVC"];
        rejectedVC.dictDate = [Utilities getDayDateYear:response[@"latest_loan_details"][@"loan_creation_date"]];
        [self.navigationController pushViewController:rejectedVC animated:YES];
    }
    
    else if ( [response[@"landing_page"] isEqualToString:@"id_detail"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        [Utilities setUserDefaultWithObject:@"2" andKey:@"signupStep"];
        [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];
        signupScreen.signupStep = 2;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    
    else if ( [response[@"landing_page"] isEqualToString:@"professional_info"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        [Utilities setUserDefaultWithObject:@"3" andKey:@"signupStep"];
        [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];

        signupScreen.signupStep = 3;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    else if ( [response[@"landing_page"] isEqualToString:@"doc_upload"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        [Utilities setUserDefaultWithObject:@"4" andKey:@"signupStep"];
        [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];

        signupScreen.signupStep = 4;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    else
    {
        if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] || [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"closed"]  )
        {
            
            [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
            [Utilities setUserDefaultWithObject:[ response objectForKey:@"auth_token"] andKey:@"auth_token"];
            appDelegate.isLoanDisbursed = YES;
            
            ViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"rejected"] )
        {
            RejectedVC *rejectedVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"RejectedVC"];
            rejectedVC.dictDate = [Utilities getDayDateYear:response[@"latest_loan_details"][@"loan_creation_date"]];
            appDelegate.isLoanDisbursed = NO;
            [self.navigationController pushViewController:rejectedVC animated:YES];
        }

        else
        {
            appDelegate.isLoanDisbursed = NO;
            ViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    [ SVProgressHUD dismiss ];
    
}
- (void)navigateAccordingToCurrentStatus:(NSDictionary *)response
{
    if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] )
    {
        // Navigate To LOC Dashboard
        ViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"rejected"] )
    {
        RejectedVC *rejectedVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"RejectedVC"];
        rejectedVC.dictDate = [Utilities getDayDateYear:response[@"latest_loan_details"][@"loan_creation_date"]];
        [self.navigationController pushViewController:rejectedVC animated:YES];
    }
    
    else if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"rejected"] )
    {
        RejectedVC *rejectedVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"RejectedVC"];
        rejectedVC.dictDate = [Utilities getDayDateYear:response[@"latest_loan_details"][@"loan_creation_date"]];
        [self.navigationController pushViewController:rejectedVC animated:YES];
    }
    
    else
    {
        StatusVC *statusVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"StatusVC"];
        statusVC.dictLoandetail = response[@"latest_loan_details"];
        [self.navigationController pushViewController:statusVC animated:YES];
    }
}

#pragma mark Helper Method
- (void)startTimer
{
    time = 60;

    if ( !isForgot )
    {
        _btnGenerateOTP.userInteractionEnabled = NO;
        _btnGenerateOTP.enabled = NO;

        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [ _btnGenerateOTP setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];

    }
    else
    {
        _btnSendOTP.userInteractionEnabled = NO;
        _btnSendOTP.enabled = NO;

        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [ _btnSendOTP setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    }
}
- (void)updateTimer
{
    if ( time == 0 )
    {
        time = 60;
        
        if ( !isForgot )
        {
            [ _btnGenerateOTP setTitle:@"GENERATE OTP" forState:UIControlStateNormal];
            [ timer invalidate ];
            _btnGenerateOTP.userInteractionEnabled = YES;
            _btnGenerateOTP.enabled = YES;
            [ _btnGenerateOTP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];

        }
        else
        {
            [ _btnSendOTP setTitle:@"SEND OTP" forState:UIControlStateNormal];
            [ timer invalidate ];
            _btnSendOTP.userInteractionEnabled = YES;
            _btnSendOTP.enabled = YES;
            [ _btnSendOTP setTitleColor:[UIColor redColor] forState:UIControlStateNormal ];
        }
    }
    else
    {
        if ( !isForgot )
        {
            [ _btnGenerateOTP setTitle:[NSString stringWithFormat:@"GENERATE OTP(%ld)", (long)time] forState:UIControlStateNormal];
        }
        else
        {
            [ _btnSendOTP setTitle:[NSString stringWithFormat:@"RESEND OTP (%ld)", (long)time] forState:UIControlStateNormal];
        }
        
        time--;
    }
}
- (void)showPopupView:(UIView *)popupView onViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [overlayView setTag:786];
    [popupView setHidden:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnOverlay:)];
    [overlayView addGestureRecognizer:tapGesture];
    
    [viewcontroller.view addSubview:overlayView];
    [viewcontroller.view bringSubviewToFront:popupView];
    popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        popupView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
    {
        
    }];
    
}
- (void)tappedOnOverlay:(UIGestureRecognizer *)gesture
{
    if ( !isVerifyOtpGenerated )
    {
        [self hidePopupView:_viewForgotPopUp fromViewController:self];
        _viewForgotInner.hidden = YES;
        _cnsForgotViewHeight.constant = 143;
        _cnsForgotInnerViewHeight.constant = 0;
        _txtForgotMobile.text = @"";
        [_btnSendOTP setTitle:@"SEND OTP" forState:UIControlStateNormal];
        _btnSendOTP.enabled = YES;
        [ _btnSendOTP setTitleColor:[UIColor redColor] forState:UIControlStateNormal ];

    }
    else
    {
        isVerifyOtpGenerated = NO;
        [ self hidePopupView:_viewOtpVerify fromViewController:self ];
    }
    
    [timer invalidate];
}
- (void)hidePopupView:(UIView *)popupView fromViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [viewcontroller.view viewWithTag:786];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
     }
                     completion:^(BOOL finished)
     {
         [popupView setHidden:YES];
         
     }];
    
    
    [overlayView removeFromSuperview];
}


@end
