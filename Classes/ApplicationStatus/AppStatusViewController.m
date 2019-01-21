//
//  AppStatusViewController.m
//  StashFin
//
//  Created by sachin khard on 19/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "AppStatusViewController.h"

@interface AppStatusViewController ()

@end

@implementation AppStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cardNameLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"name"]];
    self.cardNumberLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"card_no"]];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@/%@",[ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"expiry_month"]],[ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"expiry_year"]]];
    
    [self.cardNameLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.cardNumberLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
    [self.monthYearLabel setFont:[ApplicationUtils GETFONT_MEDIUM:14]];

    [self.staticTextLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
   
    [self.startLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [self.approvedLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [self.docUploadLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [self.doneLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    
//    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    self.bgView.layer.shadowOpacity = 0.2f;
//    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bgView.layer.shadowRadius = 5;
//    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.cornerRadius = 5.0;

    NSString *loanStatus = [[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"latest_loan_details"][@"current_status"]] lowercaseString];
    
    if ([loanStatus isEqualToString:@"start"]) {
        [self.startLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
        self.approvedTickImageView.hidden = YES;
        self.docUploadTickImageView.hidden = YES;
        self.doneTickImageView.hidden = YES;
    }
    else if ([loanStatus isEqualToString:@"approved"]) {
        [self.approvedLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
        self.docUploadTickImageView.hidden = YES;
        self.doneTickImageView.hidden = YES;
    }
    else if ([loanStatus isEqualToString:@"docpick"]) {
        [self.docUploadLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
        self.doneTickImageView.hidden = YES;
    }
    else if ([loanStatus isEqualToString:@"docpickdone"]) {
        [self.doneLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Application Status";
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
