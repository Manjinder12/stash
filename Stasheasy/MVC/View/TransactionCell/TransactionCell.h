//
//  TransactionCell.h
//  Stasheasy
//
//  Created by tushar on 18/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *tView;
@property (weak, nonatomic) IBOutlet UILabel *lblPartyName;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
