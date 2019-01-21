//
//  SuccessLoadCardViewController.m
//  StashFin
//
//  Created by sachin khard on 10/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "SuccessLoadCardViewController.h"

@interface SuccessLoadCardViewController ()

@end

@implementation SuccessLoadCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.doneLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
    [self.amountLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];

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

@end
