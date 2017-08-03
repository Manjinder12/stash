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
    appDelegate.window.rootViewController = navigationController;
    
}
- (void)navigateToLandingVC
{
    LandingVC *vc = (LandingVC *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingVC"] ;
    UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
    navigationController.navigationBar.hidden = YES;
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
                 [self navigateToLOCDashboard];
             }
         }
         else
         {
                [self navigateToLandingVC];
         }
     }];
}
@end
