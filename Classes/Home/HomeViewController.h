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

@property (strong, nonatomic) NSDictionary *cardOverviewDic;
@property (strong, nonatomic) NSDictionary *locDetailDic;

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

@end
