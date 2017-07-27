//
//  LoanCell.h
//  Stasheasy
//
//  Created by Mohd Ali Khan on 27/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblLoanDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEMI;
@property (weak, nonatomic) IBOutlet UIView *viewConatiner;


@end
