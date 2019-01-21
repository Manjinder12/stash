//
//  ChangePasswordViewController.m
//  StashFin
//
//  Created by sachin khard on 25/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.changeLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.stashfinLabel setFont:[ApplicationUtils GETFONT_BOLD:22]];
    [self.staticLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.loginButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    
    [ApplicationUtils setFieldViewProperties:self.nwPasswordView];
    [ApplicationUtils setFieldViewProperties:self.confirmPasswordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonAction:(id)sender {

}

- (IBAction)backAction:(id)sender {
    [ApplicationUtils popVCWithFadeAnimation:self.navigationController];
}

@end
