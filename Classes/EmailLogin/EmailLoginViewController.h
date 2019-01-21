//
//  EmailLoginViewController.h
//  StashFin
//
//  Created by sachin khard on 21/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginviaOTPButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)loginviaOTPButtonAction:(id)sender;
- (IBAction)forgotPasswordButtonAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
