//
//  ViewController.m
//  Stasheasy
//
//  Created by Duke on 31/05/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    AppDelegate *appDelegate;
}
@end

@implementation ViewController
@synthesize identifier;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    appDelegate = [ AppDelegate sharedDelegate ];
    
    self.frostedViewController.limitMenuViewSize = YES;
    if ( appDelegate.isLoanDisbursed )
    {
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    }
    else
    {
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"statusNavigation"];
    }
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftScreen"];
}


@end
