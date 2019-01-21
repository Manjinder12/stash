//
//  CardPinViewController.m
//  StashFin
//
//  Created by sachin khard on 05/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "CardPinViewController.h"

@interface CardPinViewController () 

@end

@implementation CardPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.otpStaticLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.enterOTPStaticLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.submitButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    [self.resendOTPButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    [self.resendOTPButton setTitleColor:ROSE_PINK_COLOR forState:UIControlStateNormal];
    [self.resendOTPButton setTitle:@"Send  OTP" forState:UIControlStateNormal];
    
    [ApplicationUtils setFieldViewProperties:self.otpView];
    [ApplicationUtils setFieldViewProperties:self.pinView];

    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.bgView.layer.shadowOpacity = 0.2f;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 5;
    self.bgView.layer.cornerRadius = 5.0;
    self.bgView.layer.masksToBounds = NO;

    self.submitButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Change Card PIN";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.submitButtonTopConstraint setConstant:-(self.submitButton.frame.size.height/2)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Verify OTP

- (IBAction)submitButtonAction:(id)sender {
    //Call Change Pin Service
    
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    UITextField *ptf = (UITextField *)[self.pinView viewWithTag:101];
    
    if ([ApplicationUtils validateStringData:otf.text].length > MAX_OTP_LENGTH || [ApplicationUtils validateStringData:otf.text].length < MIN_OTP_LENGTH) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid OTP"];
    }
    else if ([ApplicationUtils validateStringData:ptf.text].length != PIN_LENGTH) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid PIN"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"changeCardPin"        forKey:@"mode"];
        [dictParam setValue:ptf.text                forKey:@"newPin"];
        [dictParam setValue:otf.text                forKey:@"otp"];
        
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

#pragma mark - Send OTP

- (IBAction)resendOTPButtonAction:(id)sender {
    
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    otf.text = @"";
    self.submitButton.enabled = NO;

    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"sendCardPinChangeOtp"      forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            [ApplicationUtils showMessage:response[@"msg"] withTitle:@"" onView:self.view];
            
            [self.resendOTPButton disableButtonAndStartTimer];
        }
    }];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    NSUInteger otpLength;
    NSUInteger pinLength;

    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    UITextField *ptf = (UITextField *)[self.pinView viewWithTag:101];

    if(textField == otf) {
        otpLength = [textField.text length] + [string length] - range.length;
        pinLength = ptf.text.length;
    }
    else {
        pinLength = [textField.text length] + [string length] - range.length;
        otpLength = otf.text.length;
    }
    
    if (otpLength > MAX_OTP_LENGTH || pinLength > PIN_LENGTH) {
        return NO;
    }
    else {
        self.submitButton.enabled = (pinLength == PIN_LENGTH);
        return [string isEqualToString:filtered];
    }
}


@end
