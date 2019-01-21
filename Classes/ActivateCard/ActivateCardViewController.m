//
//  ActivateCardViewController.m
//  StashFin
//
//  Created by sachin khard on 20/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ActivateCardViewController.h"

@interface ActivateCardViewController ()

@end

@implementation ActivateCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activateLbabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.staticTextLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.activateButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Activate Card";
    
    NSDictionary *cardStatus = [AppDelegate instance].loginData[@"card_status"];
    
    if ([[ApplicationUtils validateStringData:cardStatus[@"otp_verified"]] boolValue]) {
        self.activateButton.hidden = YES;
        self.staticTextLabel.text = @"Your card activation is under process, it will activate soon.";
    }
    else {
        self.activateButton.hidden = NO;
        self.staticTextLabel.text = @"Dear user please activate your card for loading and using your card.";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
