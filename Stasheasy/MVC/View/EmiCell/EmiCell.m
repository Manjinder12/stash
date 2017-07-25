//
//  EmiCell.m
//  Stasheasy
//
//  Created by tushar on 18/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "EmiCell.h"

@implementation EmiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupcellConfig:(int)row {
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"silderbtn"] forState:UIControlStateNormal];
    self.sliderOuterView.layer.cornerRadius = 5.0f;
    switch (row) {
        case 0:{
            self.titleLbl.text =@"How much do you want?";
            self.startlimitlbl.text =@"0";
            self.endLimitLbl.text = @"1 Lac";
            self.slider.minimumValue =0;
            self.slider.maximumValue = 100000;
            _cellrow = 0;
        }
         break;
        case 1:{
            self.titleLbl.text =@"How long do want it for?";
            self.startlimitlbl.text =@"0";
            self.endLimitLbl.text = @"18 Months";
            self.slider.minimumValue =0;
            self.slider.maximumValue = 18;
            _cellrow = 1;
        }
            break;
        case 2: {
            self.titleLbl.text =@"Rate of interest?";
            self.startlimitlbl.text =@"2%";
            self.endLimitLbl.text = @"5%";
            self.slider.minimumValue =2;
            self.slider.maximumValue = 5;
            _cellrow = 2;

        }
            break;
        default:
            break;
    }
    
}

- (IBAction)slidervalueChanged:(id)sender {
    if (sender == self.slider) {
        if (_cellrow==0) {
            self.amntLbl.text = [NSString stringWithFormat:@"₹%0.0f", self.slider.value];
        }
        else if (_cellrow ==1) {
            self.amntLbl.text = [NSString stringWithFormat:@"%0.0f Months", self.slider.value];
        }
        else if (_cellrow ==2) {
            self.amntLbl.text = [NSString stringWithFormat:@"%0.0f", self.slider.value];
            self.amntLbl.text = [self.amntLbl.text stringByAppendingString:@"%"];
        }
    }

}


@end
