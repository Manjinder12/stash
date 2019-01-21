//
//  OutgoingEMICell.h
//  StashFin
//
//  Created by sachin khard on 27/05/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutgoingEMICell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *roiLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *emiAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeDateValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *infoBtn;

@end
