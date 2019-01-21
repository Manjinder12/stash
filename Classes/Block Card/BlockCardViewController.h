//
//  BlockCardViewController.h
//  StashFin
//
//  Created by sachin khard on 04/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *lostButton;
@property (weak, nonatomic) IBOutlet UIButton *stolenButton;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submitButtonAction:(id)sender;
- (IBAction)radioButtonAction:(id)sender;

@end
