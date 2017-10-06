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
                 
                 if ([[Utilities getUserDefaultValueFromKey:@"islogin"] intValue] != 0)
                 {
                     [self serverCallForPersonalDetail];
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
                 appDelegate.isLoanDisbursed = YES;
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
         }
         else
         {
         }
         
         [self navigateToLOCDashboard];
         
     }];
}
@end
