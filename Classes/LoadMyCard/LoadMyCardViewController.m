//
//  LoadMyCardViewController.m
//  StashFin
//
//  Created by sachin khard on 07/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "LoadMyCardViewController.h"
#import "ConfirmLoadCardViewController.h"


@interface LoadMyCardViewController ()

@end

@implementation LoadMyCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self getLOCWithdrawalDetailsFromServer];
    
    self.cardNameLabel.text = [ApplicationUtils validateStringData:self.cardOverviewDic[@"card_details"][@"name"]];
    self.cardNumberLabel.text = [ApplicationUtils validateStringData:self.cardOverviewDic[@"card_details"][@"card_no"]];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@/%@",[ApplicationUtils validateStringData:self.cardOverviewDic[@"card_details"][@"expiry_month"]],[ApplicationUtils validateStringData:self.cardOverviewDic[@"card_details"][@"expiry_year"]]];

    [self.cardNameLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.cardNumberLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
    
    [self.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
    [self.amountSlider setTintColor:ROSE_PINK_COLOR];
    [self.amountSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
    
    [self.tenureLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
    [self.tenureSlider setTintColor:ROSE_PINK_COLOR];
    [self.tenureSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
    
    [self.minAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.maxAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.minTenureLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.maxTenureLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];

    [self.amountTF setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [self.tenureTF setFont:[ApplicationUtils GETFONT_REGULAR:19]];

    [self.balanceLabel setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [self.emiLabel setFont:[ApplicationUtils GETFONT_REGULAR:19]];

    [self.balanceValueLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
    [self.emiValueLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];

    [self.rupeeSymbolLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.monthSymbolLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.chargesLabel setFont:[ApplicationUtils GETFONT_REGULAR:14]];

    [self.loadNowButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
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


#pragma mark - service

- (void)getLOCWithdrawalDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"locWithdrawalRequestform"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            monthlyROI = [[ApplicationUtils validateStringData:response[@"rate_of_interest"]] floatValue];
            minTenure = [[ApplicationUtils validateStringData:response[@"min_tenure"]] floatValue];
            maxTenure = [[ApplicationUtils validateStringData:response[@"max_tenure"]] floatValue];
            minAmount = [[ApplicationUtils validateStringData:response[@"minimum_request_amount"]] floatValue];
            maxAmount = [[ApplicationUtils validateStringData:response[@"remaining_loc"]] floatValue];
            steps = [[ApplicationUtils validateStringData:response[@"request_amount_increment_step"]] floatValue];
            
            self.minAmountLabel.text = [NSString stringWithFormat:@"₹%.1f",minAmount];
            self.maxAmountLabel.text = [NSString stringWithFormat:@"₹%.1f",maxAmount];
            self.minTenureLabel.text = [NSString stringWithFormat:@"%.0f Months",minTenure];
            self.maxTenureLabel.text = [NSString stringWithFormat:@"%.0f Months",maxTenure];
            
            [self.amountSlider setMinimumValue:minAmount];
            [self.amountSlider setMaximumValue:maxAmount];
            
            [self.tenureSlider setMinimumValue:minTenure];
            [self.tenureSlider setMaximumValue:maxTenure];
            
            self.amountTF.text = [NSString stringWithFormat:@"%.0f",self.amountSlider.value];
            self.tenureTF.text = [NSString stringWithFormat:@"%.0f",self.tenureSlider.value];

            [self calculateExpectedEMI];
        }
    }];
}

- (IBAction)amountSliderAction:(id)sender {
    float newStep = roundf((self.amountSlider.value) / steps);
    self.amountSlider.value = newStep * steps;

    NSInteger val = maxAmount/steps;
    
    if (newStep == val) {
        self.amountTF.text = [NSString stringWithFormat:@"%.0f",maxAmount];
    }
    else {
        self.amountTF.text = [NSString stringWithFormat:@"%.0f",self.amountSlider.value];
    }
    
    [self calculateExpectedEMI];
}

- (IBAction)tenureSliderAction:(id)sender {
    CGFloat steps = 1;
    
    float newStep = roundf((self.tenureSlider.value) / steps);
    self.tenureSlider.value = newStep * steps;
    
    self.tenureTF.text = [NSString stringWithFormat:@"%.0f",self.tenureSlider.value];
    
    [self calculateExpectedEMI];
}

- (void)calculateExpectedEMI {
    
    CGFloat balance = maxAmount - [self.amountTF.text floatValue];
    self.balanceValueLabel.text = [NSString stringWithFormat:@"₹%.1f",balance];

    NSNumber *num = [NSNumber numberWithDouble:([self.amountTF.text floatValue] * (monthlyROI/100))/(1-1/(pow(1+monthlyROI/100, [self.tenureTF.text floatValue])))];
    self.emiValueLabel.text = [NSString stringWithFormat:@"₹%d",[num integerValue]];
}

- (IBAction)loadNowButtonAction:(id)sender {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"locWithdrawalRequest"     forKey:@"mode"];
    [dictParam setValue:self.amountTF.text          forKey:@"amount"];
    [dictParam setValue:self.tenureTF.text          forKey:@"tenure"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            ConfirmLoadCardViewController *vc = [[ConfirmLoadCardViewController alloc] initWithNibName:@"ConfirmLoadCardViewController" bundle:nil];
            [vc setEmiDetailDic:response];
            [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
        }
    }];
}

#pragma mark  - UITextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length) {
        if ([string validateNumeric]) {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if(textField == self.amountTF && [newString floatValue] <= maxAmount){
                self.amountSlider.value = [newString floatValue];
            }
            else if(textField == self.tenureTF && [newString floatValue] <= maxTenure){
                self.tenureSlider.value = [newString floatValue];
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }
    }
    else {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(textField == self.amountTF){
            self.amountSlider.value = [newString floatValue];
        }
        else if(textField == self.tenureTF){
            self.tenureSlider.value = [newString floatValue];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if(textField == self.amountTF && [textField.text floatValue] < minAmount){
        self.amountTF.text = [NSString stringWithFormat:@"%.0f",self.amountSlider.value];
    }
    else if(textField == self.tenureTF && [textField.text floatValue] < minTenure){
        self.tenureTF.text = [NSString stringWithFormat:@"%.0f",self.tenureSlider.value];
    }
    
    return YES;
}

@end
