//
//  LineCreditVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LineCreditVC.h"
#import "ServerCall.h"

@interface LineCreditVC ()

@end

@implementation LineCreditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    [self serverCallForWithdrawalRequest];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Button Action
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuAction:(id)sender
{
    
}
#pragma mark Server Call
- (void)serverCallForWithdrawalRequest
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"locWithdrawalRequestform" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        
        NSLog(@"response === %@", response);
        NSLog(@"response === %@", response);
        
        
    }];
}
@end
