//
//  BlockCardViewController.m
//  StashFin
//
//  Created by sachin khard on 04/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "BlockCardViewController.h"


@interface BlockCardViewController ()

@end

@implementation BlockCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cardNameLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"name"]];
    self.cardNumberLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"card_no"]];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@/%@",[ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"expiry_month"]],[ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"expiry_year"]]];

    [self.cardNameLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.cardNumberLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
    [self.monthYearLabel setFont:[ApplicationUtils GETFONT_MEDIUM:14]];
    
    [self.messageLabel setFont:[ApplicationUtils GETFONT_REGULAR:20]];
    [self.submitButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.textField setFont: [ApplicationUtils GETFONT_REGULAR:17]];
    [self.lostButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:20]];
    [self.stolenButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:20]];
    
    self.textField.layer.cornerRadius = 5.0;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.cardView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.cardView.layer.shadowOpacity = 0.2f;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowRadius = 5;
    self.cardView.layer.cornerRadius = 5.0;
    self.cardView.layer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Block Card";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.submitButtonTopConstraint setConstant:-(self.submitButton.frame.size.height/2)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (IBAction)submitButtonAction:(id)sender {
    
    if (![self.textField.text length]) {
        [ApplicationUtils showMessage:@"Please provide some details to block your card" withTitle:@"" onView:self.view];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"lostStolenCard"       forKey:@"mode"];
        [dictParam setValue:self.textField.text     forKey:@"details"];
        
        if (self.lostButton.selected) {
            [dictParam setValue:@"lost"         forKey:@"lost_or_stolen"];
        }
        else {
            [dictParam setValue:@"stolen"       forKey:@"lost_or_stolen"];
        }
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:[ApplicationUtils validateStringData:response[@"msg"]] cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
                    
                    [[AppDelegate instance].leftMenuReferenceVC selectMenuActionWithIndex:0];
                    
                }] otherButtonItems: nil];
                [[AlertViewManager sharedManager].alertView show];
            }
        }];
    }
}

- (IBAction)radioButtonAction:(id)sender {
 
    UIButton *btn = (UIButton *)sender;
    
    if (btn == self.lostButton) {
        self.lostButton.selected = YES;
        self.stolenButton.selected = NO;
    }
    else {
        self.lostButton.selected = NO;
        self.stolenButton.selected = YES;
    }
}

@end
