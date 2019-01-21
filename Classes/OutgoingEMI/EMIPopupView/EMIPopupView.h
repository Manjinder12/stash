//
//  EMIPopupView.h
//  StashFin
//
//  Created by sachin khard on 13/10/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMIPopupView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenureLabel;

@property (weak, nonatomic) IBOutlet UILabel *amount1Label;
@property (weak, nonatomic) IBOutlet UILabel *amount2Label;
@property (weak, nonatomic) IBOutlet UILabel *amount3Label;
@property (weak, nonatomic) IBOutlet UILabel *amount4Label;
@property (weak, nonatomic) IBOutlet UILabel *amount5Label;
@property (weak, nonatomic) IBOutlet UILabel *amount6Label;

@property (weak, nonatomic) IBOutlet UILabel *date1Label;
@property (weak, nonatomic) IBOutlet UILabel *date2Label;
@property (weak, nonatomic) IBOutlet UILabel *date3Label;
@property (weak, nonatomic) IBOutlet UILabel *date4Label;
@property (weak, nonatomic) IBOutlet UILabel *date5Label;
@property (weak, nonatomic) IBOutlet UILabel *date6Label;

- (void)setData:(NSDictionary *)tempDic;

@end
