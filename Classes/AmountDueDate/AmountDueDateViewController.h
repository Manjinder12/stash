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
@property (weak, nonatomic) IBOutlet UILabel *gstLabel;
@property (weak, nonatomic) IBOutlet UILabel *gstValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargesLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargesValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *netAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *netAmountValueLabel;


- (IBAction)payNowButtonAction:(id)sender;

@end
