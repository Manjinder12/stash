//
//  ReferralCodeViewController.h
//  StashFin
//
//  Created by sachin khard on 21/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ReferralCodeVCDelegate<NSObject>
@optional
- (void)dismissClicked;
@end


@interface ReferralCodeViewController : UIViewController

@property (assign, nonatomic) id <ReferralCodeVCDelegate>delegate;

@property (strong, nonatomic) NSDictionary *prefilledDic;

@property (weak, nonatomic) IBOutlet UILabel *static1Label;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyButtonTopConstraint;

- (IBAction)applyButtonAction:(id)sender;
- (IBAction)tapAction:(id)sender;

@end
