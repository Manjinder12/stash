//
//  RejectedVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 09/08/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "RejectedVC.h"
#import "Utilities.h"
#import "LandingVC.h"
#import "AppDelegate.h"

@interface RejectedVC ()
{
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end

@implementation RejectedVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [AppDelegate sharedDelegate];
    
    _lblDate.text = [NSString stringWithFormat:@"%@ %@ %@ | %@",[_dictDate valueForKey:@"day"],[_dictDate valueForKey:@"month"],[_dictDate valueForKey:@"year"],[_dictDate valueForKey:@"time"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(id)sender
{
    [self navigateToLandingVC];
}
- (void)navigateToLandingVC
{
    [Utilities popToNumberOfControllers:2 withNavigation:self.navigationController];
}
@end
