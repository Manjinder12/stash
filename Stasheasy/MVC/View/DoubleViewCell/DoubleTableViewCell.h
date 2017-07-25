//
//  DoubleTableViewCell.h
//  Stasheasy
//
//  Created by Duke on 02/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *firstField;
@property (strong, nonatomic) IBOutlet UITextField *secondField;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondCalBtn;

@end
