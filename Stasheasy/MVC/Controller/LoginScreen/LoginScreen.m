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

@interface LoginScreen ()
{
    AppDelegate *appDelegate;
    UserServices *service;
    NSMutableDictionary *param;
    REFrostedViewController *refrostedVC;
    NSDictionary *dictLoginResponse;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtOTP;
@property (weak, nonatomic) IBOutlet UIView *viewPopUp;
@property (weak, nonatomic) IBOutlet UIButton *btnSendOTP;

@end

@implementation LoginScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
  }
- (void)customInitialization
{
    appDelegate = [ AppDelegate sharedDelegate ];
    service = [[UserServices alloc] init];
    param = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    _viewPopUp.hidden = YES;
    [ Utilities setBorderAndColor:_btnSendOTP ];
    
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

#pragma mark Button Action
- (IBAction)loginAction:(id)sender
{
    if ([self performValidation])
    {
        [self.view endEditing:YES];
        [self serverCallForLogin];
    }
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)otpLoginAction:(id)sender
{
    
}
- (IBAction)sendOTPAction:(id)sender
{
    
}

- (IBAction)forgotPasswordAction:(id)sender
{
    _viewPopUp.hidden = NO;
    [ self showPopupView:_viewPopUp onViewController:self ];
}

-(BOOL)performValidation
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
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Staheasy" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    return NO;
}

#pragma mark - Server Call
- (void)serverCallForLogin
{
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"response === %@", response);

        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
                [Utilities setUserDefaultWithObject:[ response objectForKey:@"auth_token"] andKey:@"auth_token"];
                dictLoginResponse = response;
                [ self serverCallForCardOverview ];
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
    }];
}
- (void)serverCallForCardOverview
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObject:@"cardOverview" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
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
             [ Utilities showAlertWithMessage:response ];
         }
    }];
}
- (void)serverCallForPersonalDetail
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObject:@"getLoginData" forKey:@"mode"];
    
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
                 appDelegate.dictCustomer = [NSDictionary dictionaryWithDictionary:response];
             }
             
             if ( [dictLoginResponse[@"landing_page"] isEqualToString:@"profile"] )
             {
                 [self navigateAccordingToCurrentStatus:dictLoginResponse];
             }
             else
             {
                 [self navigateAccordingLandingPageStatus:dictLoginResponse];
             }

         }
         else
         {
             [Utilities showAlertWithMessage:response];
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
        signupScreen.signupStep = 2;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    
    else if ( [response[@"landing_page"] isEqualToString:@"professional_info"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        signupScreen.signupStep = 3;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    else if ( [response[@"landing_page"] isEqualToString:@"doc_upload"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        signupScreen.signupStep = 4;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
}
- (void)navigateAccordingToCurrentStatus:(NSDictionary *)response
{
    if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] )
    {
        // Navigate To LOC Dashboard

//        [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
//        [Utilities setUserDefaultWithObject:[ response objectForKey:@"auth_token"] andKey:@"auth_token"];

        ViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
        [self.navigationController pushViewController:vc animated:YES];
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
    [self hidePopupView:_viewPopUp fromViewController:self];
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
