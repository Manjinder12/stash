//
//  CardPinViewController.h
//  StashFin
//
//  Created by sachin khard on 05/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardPinViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *otpStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterOTPStaticLabel;
@property (weak, nonatomic) IBOutlet CountdownButton *resendOTPButton;
@property (weak, nonatomic) IBOutlet UIView *pinView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonTopConstraint;


- (IBAction)resendOTPButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;


@end
