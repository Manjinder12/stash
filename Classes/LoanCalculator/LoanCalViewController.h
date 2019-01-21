//
//  LoanCalViewController.h
//  StashFin
//
//  Created by sachin khard on 07/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanCalViewController : UIViewController {
    CGFloat steps;
    CGFloat monthlyROI;
    CGFloat minTenure;
    CGFloat maxTenure;
    CGFloat minAmount;
    CGFloat maxAmount;
    CGFloat minROI;
    CGFloat maxROI;
}

@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *tenureTF;
@property (weak, nonatomic) IBOutlet UITextField *roiTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UILabel *tenureLabel;
@property (weak, nonatomic) IBOutlet UISlider *tenureSlider;
@property (weak, nonatomic) IBOutlet UILabel *roiLabel;
@property (weak, nonatomic) IBOutlet UISlider *roiSlider;
@property (weak, nonatomic) IBOutlet UILabel *emiLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rupeeSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargesLabel;
- (IBAction)amountSliderAction:(id)sender;
- (IBAction)tenureSliderAction:(id)sender;
- (IBAction)roiSliderAction:(id)sender;
@end

