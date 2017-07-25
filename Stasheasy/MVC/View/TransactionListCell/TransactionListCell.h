//
//  TransactionListCell.h
//  Stasheasy
//
//  Created by Tushar  on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainview;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *valLbl;

@end
