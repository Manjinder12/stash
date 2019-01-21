//
//  AppStatusViewController.h
//  StashFin
//
//  Created by sachin khard on 19/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppStatusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *staticTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *approvedLabel;
@property (weak, nonatomic) IBOutlet UILabel *docUploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startTickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *approvedTickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *docUploadTickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *doneTickImageView;



@end
