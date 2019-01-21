//
//  PaybackViewController.h
//  StashFin
//
//  Created by Mac on 04/12/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaybackViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *pinView;
@property (weak, nonatomic) IBOutlet UIButton *generatePinButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)generatePinButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
