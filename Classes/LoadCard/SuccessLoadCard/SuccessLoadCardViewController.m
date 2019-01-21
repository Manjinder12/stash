//
//  SuccessLoadCardViewController.m
//  StashFin
//
//  Created by sachin khard on 10/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "SuccessLoadCardViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "HomeViewController.h"

@interface SuccessLoadCardViewController ()

@end

@implementation SuccessLoadCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.doneButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
    [self.amountLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];

    self.amountLabel.text = [NSString stringWithFormat:@"Your requested amount %@%@ added on your StashFin card.",CURRENCY_SYMBOL,self.amount];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Load My Card";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonAction:(id)sender {
    [self navigationShouldPopOnBackButton];
}

#pragma mark - Back Button Handller

- (BOOL)navigationShouldPopOnBackButton
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HomeViewController class]]) {
            [(HomeViewController *)obj getLOCDetailsFromServer];
            [self.navigationController popToViewController:obj animated:NO];
        }
    }];
    return NO;
}

@end
