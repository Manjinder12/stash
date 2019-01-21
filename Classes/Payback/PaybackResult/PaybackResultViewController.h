//
//  PaybackResultViewController.h
//  StashFin
//
//  Created by Mac on 04/12/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaybackResultViewController : UIViewController

@property (strong, nonatomic) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *paybackStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *paybackIDValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *eligibleStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *eligiblePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *unlockStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *redeemPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tandcLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tandcLabelHeight;


@end

NS_ASSUME_NONNULL_END
