//
//  AnalysisCell.h
//  StashFin
//
//  Created by sachin khard on 14/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *analysisLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
