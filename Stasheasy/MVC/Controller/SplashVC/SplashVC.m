//
//  SplashVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 03/08/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "SplashVC.h"
#import "ServerCall.h"
#import "LandingVC.h"
#import "LineCreditVC.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "SignupScreen.h"
#import "RejectedVC.h"

@interface SplashVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation SplashVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    appDelegate = [AppDelegate sharedDelegate];
    [self serverCallToCheckTokenValidity];
}
- (void)checkTokenAndNavigate
{
    if ([[Utilities getUserDefaultValueFromKey:@"islogin"] intValue] == 0 && [Utilities getUserDefaultValueFromKey:@"auth_token"] == nil )
    {
        [self navigateToLandingVC];
    }
    else
    {
        [self navigateToLOCDashboard];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)navigateToLOCDashboard
{
    ViewController *vc = (ViewController *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"] ;
    UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
    navigationController.viewControllers = @[vc];
    navigationController.navigationBar.hidden = YES;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    appDelegate.window.rootViewController = navigationController;
    
}
- (void)navigateToLandingVC
{
    LandingVC *vc = (LandingVC *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingVC"] ;
    UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
    navigationController.viewControllers = @[vc];
    navigationController.navigationBar.hidden = YES;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    appDelegate.window.rootViewController = navigationController;
}

- (void)serverCallToCheckTokenValidity
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"checkAuthTokenValidity" forKey:@"mode"];
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [self navigateToLandingVC];
             }
             else
             {

                 if ([[Utilities getUserDefaultValueFromKey:@"islogin"] intValue] != 0 && [[Utilities getUserDefaultValueFromKey:@"isLoanDisbursed"] intValue] != 0 )
                 {
                     [self serverCallForCardOverview];
                 }
                 else if ([[Utilities getUserDefaultValueFromKey:@"islogin"] intValue] != 0 && [[Utilities getUserDefaultValueFromKey:@"isLoanDisbursed"] intValue] == 0 )
                 {
                     [ self serverCallForPersonalDetail ];
                 }
                 else
                 {
                     [self navigateToLandingVC];
                 }
             }
         }
         else
         {
                [self navigateToLandingVC];
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
                 appDelegate.dictCustomer = [NSDictionary dictionaryWithDictionary:response];
             }
             
             [self navigateAccordingLandingPageStatus:response];

         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}

- (void)serverCallForCardOverview
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"cardOverview" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
             
         }
         
         
     }];
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
        signupScreen.signupStep = 2;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    
    else if ( [response[@"landing_page"] isEqualToString:@"professional_info"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        [Utilities setUserDefaultWithObject:@"3" andKey:@"signupStep"];
        signupScreen.signupStep = 3;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    else if ( [response[@"landing_page"] isEqualToString:@"doc_upload"] )
    {
        SignupScreen *signupScreen = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
        [Utilities setUserDefaultWithObject:@"4" andKey:@"signupStep"];
        signupScreen.signupStep = 4;
        [self.navigationController pushViewController:signupScreen animated:YES];
    }
    else
    {
        if ( [response[@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] )
        {
            // Navigate To LOC Dashboard
            
            [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
            [Utilities setUserDefaultWithObject:@"1" andKey:@"isLoanDisbursed"];
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
@end
