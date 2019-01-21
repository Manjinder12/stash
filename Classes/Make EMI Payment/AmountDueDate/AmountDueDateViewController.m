//
//  AmountDueDateViewController.m
//  StashFin
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "AmountDueDateViewController.h"
#import "PaymentPageViewController.h"

@interface AmountDueDateViewController ()

@end

@implementation AmountDueDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:42]];
    [self.noteLabel setFont:[ApplicationUtils GETFONT_REGULAR:14]];

    [self.duedateValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.emiAmountValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

    [self.duedateLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.emiAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.amountTF setFont:[ApplicationUtils GETFONT_REGULAR:18]];

    [self.payNowButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    
    self.duedateValueLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].locData[@"next_emi_date"]];
    self.emiAmountValueLabel.text = [CURRENCY_SYMBOL stringByAppendingString:[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"next_emi_amount"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Make EMI Payment";
    
    [ApplicationUtils setNavigationTitleAndButtonColorWithNavigationBar:self.navigationController.navigationBar withHeaderColor:ROSE_PINK_COLOR];
    [[AppDelegate instance].notifcationButton setHighlighted:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
    
    [ApplicationUtils setNavigationTitleAndButtonColorWithNavigationBar:self.navigationController.navigationBar withHeaderColor:[UIColor whiteColor]];
    [[AppDelegate instance].notifcationButton setHighlighted:NO];
}

#pragma mark  - UITextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;

    if ([string validateNumeric] && newLength <= 7) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.amountLabel.text = [CURRENCY_SYMBOL stringByAppendingString:newString];
    }
    else {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - service

- (IBAction)payNowButtonAction:(id)sender {
    if ([self.amountTF.text floatValue] > 0)
    {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"quickWallet"      forKey:@"mode"];
        [dictParam setValue:@"0"                forKey:@"paymode"];
        [dictParam setValue:self.amountTF.text  forKey:@"amount"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                PaymentPageViewController *vc = [[PaymentPageViewController alloc] initWithNibName:@"PaymentPageViewController" bundle:nil];
                [vc setPaymentInfoDic:response];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

/*
 
 {
 "payment_status" = success;
 "return_url" = "http://api.stashfin.com/QuickWallet_controller/returnPage";
 url = "https://app.quikwallet.com/#paymentrequest/2QHgB1G";
 }
 
 
 mode=tokenApiCategoryList
 
 
*/

@end
