//
//  LineCreditVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LineCreditVC.h"
#import "ServerCall.h"
#import "REFrostedViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LineCreditVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblApprovedCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblUserCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblCash;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestStatus;

@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UIView *viewLower;

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
    
    [Utilities setCornerRadius:_viewLower];
    [Utilities setCornerRadius:_viewLower];
    
    _viewUpper.layer.masksToBounds = NO;
    _viewUpper.layer.shadowOffset = CGSizeMake(1, 1);
    _viewUpper.layer.shadowRadius = 4;
    _viewUpper.layer.shadowOpacity = 0.5;
    _viewUpper.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    _viewLower.layer.masksToBounds = NO;
    _viewLower.layer.shadowOffset = CGSizeMake(1, 1);
    _viewLower.layer.shadowRadius = 4;
    _viewLower.layer.shadowOpacity = 0.5;
    _viewLower.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
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
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

#pragma mark Server Call
- (void)serverCallForWithdrawalRequest
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"locDetails" forKey:@"mode"];
    
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
                [self populateLOCDetails:response];
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
    
    
    }];
}
- (void)populateLOCDetails:(NSDictionary *)dictLOC
{
    _lblApprovedCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"loc_limit"] intValue]];
    _lblUserCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"used_loc"] intValue]];
    _lblRemainCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"remaining_loc"] intValue]];
    _lblBalance.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"total_balance"] intValue]];
    _lblCash.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"last_loc_request_amount"] intValue]];
    _lblEMIDate.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"next_emi_date"] intValue]];
    _lblEMIAmount.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"next_emi_amount"] intValue]];
    _lblRequestAmount.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"last_loc_request_amount"] intValue]];
    _lblRequestDate.text = [NSString stringWithFormat:@"%@",[dictLOC valueForKey:@"last_loc_request_date"] ];
    _lblEMIAmount.text = [NSString stringWithFormat:@"%@",[dictLOC valueForKey:@"last_loc_request_status"]];

}
- (IBAction)consolidatedEMIAction:(id)sender
{
    
}
-(IBAction)reloadCardAction:(id)sender
{
    
}
- (IBAction)refreshAction:(id)sender
{
    
}

@end
