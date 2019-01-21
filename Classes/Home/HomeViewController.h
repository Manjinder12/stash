//
//  HomeViewController.h
//  StashFin
//
//  Created by Mac on 09/05/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCircleGradientView.h"

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UIView *bg1View;
@property (weak, nonatomic) IBOutlet UIView *bg2View;
@property (weak, nonatomic) IBOutlet UIView *bg3View;

@property (weak, nonatomic) IBOutlet UILabel *remainingAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingAmountValue;
@property (weak, nonatomic) IBOutlet UILabel *nextEMIDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextEMIDateValue;
@property (weak, nonatomic) IBOutlet UILabel *nextEMIAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextEMIAmountValue;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *approvedLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *approvedLimitValue;
@property (weak, nonatomic) IBOutlet UILabel *usedLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedLimitValue;
@property (weak, nonatomic) IBOutlet UILabel *availableLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLimitValue;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (weak, nonatomic) IBOutlet SFCircleGradientView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *trasparentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

- (void)getLOCDetailsFromServer;

@end
