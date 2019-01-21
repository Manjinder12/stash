//
//  AmountDueDateViewController.h
//  StashFin
//
//  Created by Mac on 11/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmountDueDateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *payNowButton;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *duedateLabel;
@property (weak, nonatomic) IBOutlet UILabel *duedateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiAmountValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;


- (IBAction)payNowButtonAction:(id)sender;

@end
