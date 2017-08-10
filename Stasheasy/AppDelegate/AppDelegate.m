
//  AppDelegate.m
//  Stasheasy
//
//  Created by Duke on 31/05/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonFunctions.h"
#import "ViewController.h"
#import "Utilities.h"
#import "LandingVC.h"
#import "LoginScreen.h"
#import "REFrostedViewController.h"
#import "LineCreditVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize dictOverview,dictTransaction,dictAnalyze,loanRequestStatus;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dictOverview = [[NSDictionary alloc] init];
    dictAnalyze = [[NSDictionary alloc] init];
    dictTransaction = [[NSDictionary alloc] init];
    loanRequestStatus = @"";
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return YES;
}

- (void)navigateToLOCDashboard
{
    ViewController *vc = (ViewController *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"] ;
    UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
    navigationController.viewControllers = @[vc];
    [self.window setRootViewController:navigationController];

}
- (void)navigateToLandingVC
{
    LandingVC *vc = (LandingVC *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingVC"] ;
    UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
    navigationController.viewControllers = @[vc];
    [self.window setRootViewController:navigationController];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
