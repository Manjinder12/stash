//
//  LandingVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LandingVC.h"
#import "Utilities.h"
#import "SignupScreen.h"

@interface LandingVC ()

@end

@implementation LandingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Button Action

- (IBAction)existingUserAction:(id)sender
{
    [self navigateToViewControllerWithIdentifier:@"LoginScreen"];
}

- (IBAction)newUserAction:(id)sender
{
    SignupScreen *vc = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"SignupScreen"];
    vc.signupStep = [[Utilities getUserDefaultValueFromKey:@"signupStep"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)PreApprovedAction:(id)sender
{
    [self navigateToViewControllerWithIdentifier:@"PreCardScreen"];
}
- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *vc = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
