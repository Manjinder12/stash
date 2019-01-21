//
//  PaybackResultViewController.m
//  StashFin
//
//  Created by Mac on 04/12/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "PaybackResultViewController.h"

@interface PaybackResultViewController ()

@end

@implementation PaybackResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.paybackStaticLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.paybackIDValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.eligibleStaticLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.eligiblePointsLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.unlockStaticLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.redeemPointsLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.tandcLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];

    self.paybackIDValueLabel.text = [NSString stringWithFormat:@"#%@",[ApplicationUtils validateStringData:self.dataDic[@"loyCardNumber"]]];
    self.eligiblePointsLabel.text = [NSString stringWithFormat:@"%@ Points",[ApplicationUtils validateStringData:self.dataDic[@"eligible_points"]]];
    self.redeemPointsLabel.text = [NSString stringWithFormat:@"%@ Points",[ApplicationUtils validateStringData:self.dataDic[@"balance"]]];

    self.paybackIDValueLabel.layer.cornerRadius = 20;
    self.eligiblePointsLabel.layer.cornerRadius = 20;
    self.redeemPointsLabel.layer.cornerRadius = 20;

    self.paybackIDValueLabel.clipsToBounds = YES;
    self.eligiblePointsLabel.clipsToBounds = YES;
    self.redeemPointsLabel.clipsToBounds = YES;

    self.eligiblePointsLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.eligiblePointsLabel.layer.borderWidth = 0.5;

    self.redeemPointsLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.redeemPointsLabel.layer.borderWidth = 0.5;

    self.tandcLabel.text = @"1. Shop online or offline using StashFin Card to become eligible for PAYBACK Points.\n\n2. Unlock points as you pay your EMIs on or before due date.\n\n3. Redeem points at multiple partner brands.";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"PAYBACK";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    float radius = self.paybackIDValueLabel.frame.size.height/2;
    
    self.paybackIDValueLabel.layer.cornerRadius = radius;
    self.eligiblePointsLabel.layer.cornerRadius = radius;
    self.redeemPointsLabel.layer.cornerRadius = radius;
    
    self.tandcLabelHeight.constant = [ApplicationUtils calculateCellTextHeight:self.tandcLabel.text RectSize:CGSizeMake(self.tandcLabel.frame.size.width, MAXFLOAT) font:self.tandcLabel.font];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
