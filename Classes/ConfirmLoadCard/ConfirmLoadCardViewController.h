//
//  ConfirmLoadCardViewController.h
//  StashFin
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface ConfirmLoadCardViewController : UIViewController

@property (strong, nonatomic) NSDictionary *emiDetailDic;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *requestedAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestedAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *roiValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *roiLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyEMIValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyEMILabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPaymentValueValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *processingFeesValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *processingFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *disbursalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *disbursalAmountLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *tandcButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tandcLabel;

- (IBAction)confirmButtonAction:(id)sender;
- (IBAction)tandcButtonAction:(id)sender;

@end
