//
//  LoadMyCardViewController.h
//  StashFin
//
//  Created by sachin khard on 07/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMyCardViewController : UIViewController {
    CGFloat steps;
    CGFloat monthlyROI;
    CGFloat minTenure;
    CGFloat maxTenure;
    CGFloat minAmount;
    CGFloat maxAmount;
}

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UILabel *tenureLabel;
@property (weak, nonatomic) IBOutlet UISlider *tenureSlider;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadNowButton;
@property (weak, nonatomic) IBOutlet UILabel *minAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTenureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTenureLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *tenureTF;
@property (weak, nonatomic) IBOutlet UILabel *chargesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rupeeSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSymbolLabel;

- (IBAction)amountSliderAction:(id)sender;
- (IBAction)tenureSliderAction:(id)sender;
- (IBAction)loadNowButtonAction:(id)sender;

@end
