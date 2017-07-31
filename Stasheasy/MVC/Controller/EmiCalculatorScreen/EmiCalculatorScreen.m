//
//  EmiCalculatorScreen.m
//  Stasheasy
//
//  Created by tushar on 18/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "EmiCalculatorScreen.h"
#import "EmiCell.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"

@interface EmiCalculatorScreen ()

@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTenure;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblInterest;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;


@property (weak, nonatomic) IBOutlet UITableView *emiTableView;
@property (weak, nonatomic) IBOutlet UIView *emiView;

@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UISlider *tenureSlider;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;

@end

@implementation EmiCalculatorScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark Button Action
- (IBAction)amountSliderValueChanged:(id)sender
{
    float number = [_amountSlider value];
    int value = (int)(number * 20);
     _lblAmount.text = [NSString stringWithFormat:@"₹%d", value * 10000];
}
- (IBAction)tenureSliderValueChanged:(id)sender
{
    float number = [_amountSlider value];
    int value = (int)(number * 17);
    _lblTenure.text = [NSString stringWithFormat:@"%d Months",value];
}
- (IBAction)rateSliderValueChanged:(id)sender
{
    float number = [_amountSlider value];
    int value = (int)(number * 60);
    _lblRate.text = [NSString stringWithFormat:@"%d",value];
}
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];

}


@end
