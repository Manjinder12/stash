//
//  CardActivationViewController.h
//  StashFin
//
//  Created by Mac on 20/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardActivationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *staticTextLabel;
@property (weak, nonatomic) IBOutlet UIView *cardNumberView;
@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet CountdownButton *sendOTPButton;
@property (weak, nonatomic) IBOutlet UIButton *activateButton;

- (IBAction)sendOTPButtonAction:(id)sender;
- (IBAction)activateButtonAction:(id)sender;

@end
