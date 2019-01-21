//
//  ChangePasswordViewController.h
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UILabel *stashfinLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UIView *nwPasswordView;
@property (weak, nonatomic) IBOutlet UIView *confirmPasswordView;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end
