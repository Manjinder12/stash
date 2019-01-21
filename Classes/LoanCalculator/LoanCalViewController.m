//
//  LoanCalViewController.m
//  StashFin
//
//  Created by sachin khard on 07/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "LoanCalViewController.h"

@interface LoanCalViewController ()

@end

@implementation LoanCalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    steps = 500;
    minAmount = 500;
    maxAmount = 200000;
    minTenure = 1;
    maxTenure = 24;
    minROI = 1;
    maxROI = 60;
    
    [self.amountLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.amountSlider setTintColor:ROSE_PINK_COLOR];
    [self.amountSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
    
    [self.tenureLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.tenureSlider setTintColor:ROSE_PINK_COLOR];
    [self.tenureSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
    
    [self.roiLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.roiSlider setTintColor:ROSE_PINK_COLOR];
    [self.roiSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
    
    [self.amountTF setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [self.tenureTF setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [self.roiTF setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    
    [self.emiLabel setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [self.emiValueLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
    
    [self.rupeeSymbolLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.monthSymbolLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.percentSymbolLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];

    [self.chargesLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    
    [self.amountSlider setMinimumValue:minAmount];
    [self.amountSlider setMaximumValue:maxAmount];
    
    [self.tenureSlider setMinimumValue:minTenure];
    [self.tenureSlider setMaximumValue:maxTenure];
    
    [self.roiSlider setMinimumValue:minROI];
    [self.roiSlider setMaximumValue:maxROI];
    
    self.amountTF.text = [NSString stringWithFormat:@"%.0f",self.amountSlider.value];
    self.tenureTF.text = [NSString stringWithFormat:@"%.0f",self.tenureSlider.value];
    self.roiTF.text = [NSString stringWithFormat:@"%.0f",self.roiSlider.value];
    
    [self calculateExpectedEMI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"EMI Calculator";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)roiSliderAction:(id)sender {
    CGFloat steps = 1;
    
    float newStep = roundf((self.roiSlider.value) / steps);
    self.roiSlider.value = newStep * steps;
    
    self.roiTF.text = [NSString stringWithFormat:@"%.0f",self.roiSlider.value];
    
    [self calculateExpectedEMI];
}

- (void)calculateExpectedEMI {
    NSNumber *num = [NSNumber numberWithDouble:([self.amountTF.text floatValue] * ([self.roiTF.text floatValue]/1200))/(1-1/(pow(1+[self.roiTF.text floatValue]/1200, [self.tenureTF.text floatValue])))];
    self.emiValueLabel.text = [NSString stringWithFormat:@"%@%ld",CURRENCY_SYMBOL,(long)[num integerValue]];
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
            else if(textField == self.roiTF && [newString floatValue] <= maxROI){
                self.roiSlider.value = [newString floatValue];
            }
            else{
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
        else if(textField == self.roiTF){
            self.roiSlider.value = [newString floatValue];
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
    else if(textField == self.roiTF && [textField.text floatValue] < minROI){
        self.roiTF.text = [NSString stringWithFormat:@"%.0f",self.roiSlider.value];
    }
    [self calculateExpectedEMI];
    return YES;
}

@end

