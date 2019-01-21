//
//  ConfirmLoadCardViewController.m
//  StashFin
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ConfirmLoadCardViewController.h"
#import "SuccessLoadCardViewController.h"

@interface ConfirmLoadCardViewController ()<TTTAttributedLabelDelegate>

@end

@implementation ConfirmLoadCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.bgView.clipsToBounds = NO;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.bgView.layer.shadowOpacity = 0.2f;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 5;

    [self.requestedAmountValueLabel setFont:[ApplicationUtils GETFONT_BOLD:42]];
    [self.requestedAmountLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

    [self.confirmButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

    [self.monthCountLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.roiValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.emiDateValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.monthlyEMIValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.totalPaymentValueValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.processingFeesValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.disbursalAmountValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];

    [self.monthLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.roiLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.emiDateLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.monthlyEMILabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.totalPaymentLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.processingFeesLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.disbursalAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];

    self.monthCountLabel.text = [ApplicationUtils validateStringData:self.emiDetailDic[@"tenure"]];
    self.roiValueLabel.text = [[ApplicationUtils validateStringData:self.emiDetailDic[@"rate_of_interest"]] stringByAppendingString:@"%"];
    self.emiDateValueLabel.text = [ApplicationUtils validateStringData:self.emiDetailDic[@"first_emi_date"]];
    self.monthlyEMIValueLabel.text = [NSString stringWithFormat:@"₹%@",[ApplicationUtils validateStringData:self.emiDetailDic[@"emi_amount"]]];
    self.totalPaymentValueValueLabel.text = [NSString stringWithFormat:@"₹%@",[ApplicationUtils validateStringData:self.emiDetailDic[@"net_amount_payable"]]];
    self.processingFeesValueLabel.text = [NSString stringWithFormat:@"₹%@",[ApplicationUtils validateStringData:self.emiDetailDic[@"upfront_interest"]]];
    self.disbursalAmountValueLabel.text = [NSString stringWithFormat:@"₹%@",[ApplicationUtils validateStringData:self.emiDetailDic[@"final_disbursal_amount"]]];
    self.requestedAmountValueLabel.text = [NSString stringWithFormat:@"₹%@",[ApplicationUtils validateStringData:self.emiDetailDic[@"requested_amount"]]];

    NSString *link = @"https://www.stashfin.com/loc_agreement";
    NSString *text = [NSString stringWithFormat:@"I have read & agree with all terms and condition listed in the \n%@\nStashFin Line of credit agreement.",link];
    [self.tandcLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.tandcLabel setUserInteractionEnabled:YES];
    self.tandcLabel.text = text;
    self.tandcLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    [self.tandcLabel setDelegate:self];
    
    NSRange linkRange = [text rangeOfString:link options:NSCaseInsensitiveSearch];
    
    self.tandcLabel.linkAttributes = @{NSForegroundColorAttributeName:ROSE_PINK_COLOR, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    [self.tandcLabel addLinkToURL:[NSURL URLWithString:link] withRange:linkRange];
    
    [self tandcButtonAction:self.tandcButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Load My Card";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tandcButtonAction:(id)sender {
    self.tandcButton.selected = !self.tandcButton.selected;
    self.confirmButton.enabled = self.tandcButton.selected;
}

- (IBAction)confirmButtonAction:(id)sender {
    SuccessLoadCardViewController *vc = [[SuccessLoadCardViewController alloc] initWithNibName:@"SuccessLoadCardViewController" bundle:nil];
    [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

@end
