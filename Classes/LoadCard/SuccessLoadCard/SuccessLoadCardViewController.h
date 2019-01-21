//
//  SuccessLoadCardViewController.h
//  StashFin
//
//  Created by sachin khard on 10/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessLoadCardViewController : UIViewController

@property (strong, nonatomic) NSString *amount;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

- (IBAction)doneButtonAction:(id)sender;

@end
