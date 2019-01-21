//
//  ReferralCodeViewController.m
//  StashFin
//
//  Created by sachin khard on 21/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ReferralCodeViewController.h"
#import "LoginViaOTP.h"


@interface ReferralCodeViewController ()

@end

@implementation ReferralCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, [AppDelegate instance].window.frame.size.width, [AppDelegate instance].window.frame.size.height);
    [self.static1Label setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.codeTF setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.codeTF.layer setCornerRadius:3.0];
    [self.codeTF.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.codeTF.layer setBorderWidth:0.5];
    self.codeTF.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.applyButtonTopConstraint setConstant:-(self.applyButton.frame.size.height/2)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyButtonAction:(id)sender {
    
    if (![ApplicationUtils validateStringData:self.codeTF.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid referral code"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"referral_check"   forKey:@"mode"];
        [dictParam setValue:self.codeTF.text    forKey:@"referral_code"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
                self.codeTF.text = @"";
            }
            else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(dismissClicked)]) {
                    [self.delegate dismissClicked];
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.prefilledDic];
                [dic setValue:self.codeTF.text forKey:REFERRAL_CODE];

                LoginViaOTP *obj = [[LoginViaOTP alloc] init];
                [obj setIsFromRegisteration:YES];
                [obj setPrefilledDic:dic];
                [[AppDelegate instance].homeNavigationControler pushViewController:obj animated:YES];
            }
        }];
    }
}

- (IBAction)tapAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissClicked)]) {
        [self.delegate dismissClicked];
    }
}


@end
