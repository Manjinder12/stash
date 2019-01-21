//
//  AmountDueDateViewController.m
//  StashFin
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "AmountDueDateViewController.h"

@interface AmountDueDateViewController ()

@end

@implementation AmountDueDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:42]];
    [self.noteLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];

    [self.duedateValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.gstValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.chargesValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.accountValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.netAmountValueLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

    [self.duedateLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.gstLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.chargesLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.accountLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.netAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];

    [self.payNowButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"EMIs Amount Due Date";
    
    [ApplicationUtils setNavigationTitleAndButtonColorWithNavigationBar:self.navigationController.navigationBar withHeaderColor:ROSE_PINK_COLOR];
    [[AppDelegate instance].notifcationButton setHighlighted:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
    
    [ApplicationUtils setNavigationTitleAndButtonColorWithNavigationBar:self.navigationController.navigationBar withHeaderColor:[UIColor whiteColor]];
    [[AppDelegate instance].notifcationButton setHighlighted:NO];
}

- (IBAction)payNowButtonAction:(id)sender {
}

@end
