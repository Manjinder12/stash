//
//  ConfirmLoadCardViewController.m
//  StashFin
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ConfirmLoadCardViewController.h"
#import "SuccessLoadCardViewController.h"
#import "SimpleListViewController.h"
#import "SKPopoverController.h"


@interface ConfirmLoadCardViewController ()<TTTAttributedLabelDelegate, SKPopoverControllerDelegate>{
    SKPopoverController *vPopoverController;
}

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
    self.monthlyEMIValueLabel.text = [NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"emi_amount"]]];
    self.totalPaymentValueValueLabel.text = [NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"net_amount_payable"]]];
    self.disbursalAmountValueLabel.text = [NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"final_disbursal_amount"]]];
    self.requestedAmountValueLabel.text = [NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"requested_amount"]]];


    float fees = [[ApplicationUtils validateStringData:self.emiDetailDic[@"gst"]] floatValue] + [[ApplicationUtils validateStringData:self.emiDetailDic[@"processing_fees"]] floatValue] + [[ApplicationUtils validateStringData:self.emiDetailDic[@"upfront_interest"]] floatValue];
    
    self.processingFeesValueLabel.text = [NSString stringWithFormat:@"%@%.0f",CURRENCY_SYMBOL,fees];

    
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
    
    [self.infoButton setTintColor:ROSE_PINK_COLOR];
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

- (void)showDropDownListWithArray:(NSArray *)list withTitle:(NSString *)title withSource:(UIButton *)sender withTag:(NSInteger)tag {
    if (!vPopoverController) {
        SimpleListViewController *obj = [[SimpleListViewController alloc] initWithNibName:@"SimpleListViewController" bundle:nil];
        obj.preferredContentSize = CGSizeMake(180, 150);
        obj.modalInPopover = NO;
        obj.listArray = list;
        obj.headerTitle = title;
        obj.dropdowntag = tag;
        
        vPopoverController = [[SKPopoverController alloc] initWithContentViewController:obj];
        vPopoverController.delegate = self;
        vPopoverController.passthroughViews = @[sender];
        vPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        vPopoverController.wantsDefaultContentAppearance = NO;
        
        [vPopoverController presentPopoverFromRect:sender.bounds
                                            inView:sender
                          permittedArrowDirections:SKPopoverArrowDirectionAny
                                          animated:YES
                                           options:SKPopoverAnimationOptionFadeWithScale];
    }
    else {
        [vPopoverController dismissPopoverAnimated:YES completion:^{
            [self popoverControllerDidDismissPopover:vPopoverController];
        }];
    }
}

#pragma mark - SKPopoverController Delegate

- (void)popoverControllerDidDismissPopover:(SKPopoverController *)controller
{
    if (controller == vPopoverController)
    {
        vPopoverController.delegate = nil;
        vPopoverController = nil;
    }
}

- (IBAction)tandcButtonAction:(id)sender {
    self.tandcButton.selected = !self.tandcButton.selected;
    self.confirmButton.enabled = self.tandcButton.selected;
}

- (IBAction)infoButtonAction:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"GST = %@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"gst"]]]];
    [arr addObject:[NSString stringWithFormat:@"Service Charges = %@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"processing_fees"]]]];
    [arr addObject:[NSString stringWithFormat:@"Upfront Charges = %@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:self.emiDetailDic[@"upfront_interest"]]]];

    [self showDropDownListWithArray:arr withTitle:@"Charge Details" withSource:sender withTag:5555];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Service

- (IBAction)confirmButtonAction:(id)sender {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"locWithdrawalConfirm"                                                         forKey:@"mode"];
    [dictParam setValue:[ApplicationUtils validateStringData:self.emiDetailDic[@"requested_amount"]]    forKey:@"amount"];
    [dictParam setValue:[ApplicationUtils validateStringData:self.emiDetailDic[@"tenure"]]              forKey:@"tenure"];

    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            if ([[ApplicationUtils validateStringData:response[@"status"]] isEqualToString:@"DISBURED"]) {
                SuccessLoadCardViewController *vc = [[SuccessLoadCardViewController alloc] initWithNibName:@"SuccessLoadCardViewController" bundle:nil];
                [vc setAmount:[ApplicationUtils validateStringData:self.emiDetailDic[@"requested_amount"]]];
                [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
            }
            else {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:[ApplicationUtils validateStringData:response[@"msg"]]];
            }
        }
    }];
}


@end
