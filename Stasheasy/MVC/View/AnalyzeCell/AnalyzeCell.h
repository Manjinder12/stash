//
//  AnalyzeCell.h
//  Stasheasy
//
//  Created by Tushar  on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyzeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTxnCount;
@property (weak, nonatomic) IBOutlet UIView *mainview;
@property (weak, nonatomic) IBOutlet UIView *samllView;

@end
