//
//  ViewController.h
//  StashFin
//
//  Created by Mac on 19/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *signupLabel;
@property (weak, nonatomic) IBOutlet UILabel *static1Label;
@property (weak, nonatomic) IBOutlet UILabel *static2Label;
@property (weak, nonatomic) IBOutlet UIButton *referralCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *signupwithemailButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;


- (IBAction)referralCodeButtonAction:(id)sender;
- (IBAction)cardButtonAction:(id)sender;
- (IBAction)fbButtonAction:(id)sender;
- (IBAction)googleButtonAction:(id)sender;
- (IBAction)signinButtonAction:(id)sender;
- (IBAction)signupwithemailButtonAction:(id)sender;

@end

