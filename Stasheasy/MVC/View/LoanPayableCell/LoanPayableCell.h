//
//  LoanPayableCell.h
//  Stasheasy
//
//  Created by Mohd Ali Khan on 10/10/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanPayableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UILabel *lblFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstDate;

@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondDate;

@property (weak, nonatomic) IBOutlet UILabel *lblThird;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdDate;

@property (weak, nonatomic) IBOutlet UILabel *lblFourth;
@property (weak, nonatomic) IBOutlet UILabel *lblFourthDate;

@property (weak, nonatomic) IBOutlet UILabel *lblFifth;
@property (weak, nonatomic) IBOutlet UILabel *lblFifthDate;

@property (weak, nonatomic) IBOutlet UILabel *lblSixth;
@property (weak, nonatomic) IBOutlet UILabel *lblSixthDate;

@end
