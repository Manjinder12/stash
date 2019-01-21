//
//  EMIPopupView.m
//  StashFin
//
//  Created by sachin khard on 13/10/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "EMIPopupView.h"

@implementation EMIPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"EMIPopupView" owner:self options:nil] firstObject];
        self.frame = frame;
        
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        
        [self.rateLabel setTextColor:ROSE_PINK_COLOR];
        [self.tenureLabel setTextColor:[UIColor greenColor]];
        
        [self.amountLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.amountValueLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.rateLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.tenureLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];

        [self.amount1Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.amount2Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.amount3Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.amount4Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.amount5Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.amount6Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.date1Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
        [self.date2Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
        [self.date3Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
        [self.date4Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
        [self.date5Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
        [self.date6Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    }
    return self;
}

- (void)setData:(NSDictionary *)tempDic {
    
    self.amountValueLabel.text = [NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"approved_amount"]]];
    self.rateLabel.text = [[NSString stringWithFormat:@"@%@",[ApplicationUtils validateStringData:tempDic[@"approved_rate"]]] stringByAppendingString:@"% PM"];
    self.tenureLabel.text = [NSString stringWithFormat:@"For %@ Months",[ApplicationUtils validateStringData:tempDic[@"approved_tenure"]]];
    
    NSArray *tArray = tempDic[@"emis"];
    
    if (tArray && tArray.count >= 1) {
        NSDictionary *tDic = tArray[0];
        [self.amount1Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
        [self.date1Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tDic[@"emi_date"]] withOutputFormat:DATE_FORMATTER]];
    }

    if (tArray && tArray.count >= 2) {
        NSDictionary *tDic = tArray[1];
        [self.amount2Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
        [self.date2Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tDic[@"emi_date"]] withOutputFormat:DATE_FORMATTER]];
    }
    
    if (tArray && tArray.count >= 3) {
        NSDictionary *tDic = tArray[2];
        [self.amount3Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
        [self.date3Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tDic[@"emi_date"]] withOutputFormat:DATE_FORMATTER]];
    }
    
    if (tArray && tArray.count >= 4) {
        NSDictionary *tDic = tArray[3];
        [self.amount4Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
        [self.date4Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tDic[@"emi_date"]] withOutputFormat:DATE_FORMATTER]];
    }
    
    if (tArray && tArray.count >= 5) {
        NSDictionary *tDic = tArray[4];
        [self.amount5Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
        [self.date5Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tDic[@"emi_date"]] withOutputFormat:DATE_FORMATTER]];
    }
    
    if (tArray && tArray.count >= 6) {
        NSDictionary *tDic = tArray[5];
        [self.amount6Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
        [self.date6Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tDic[@"emi_date"]] withOutputFormat:DATE_FORMATTER]];
    }
}

- (IBAction)touchGesture:(id)sender {
    [ApplicationUtils fadeInOutView:0.0 duration:0.35 view:self];
}

@end
