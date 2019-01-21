//
//  CardActivationViewController.m
//  StashFin
//
//  Created by Mac on 20/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "CardActivationViewController.h"

@interface CardActivationViewController ()

@end

@implementation CardActivationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.staticTextLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [ApplicationUtils setFieldViewProperties:self.cardNumberView];
    [ApplicationUtils setFieldViewProperties:self.otpView];

    [self.sendOTPButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    [self.activateButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    
    self.activateButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Card Activation";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (IBAction)sendOTPButtonAction:(id)sender {
    
    UITextField *tf = (UITextField *)[self.cardNumberView viewWithTag:101];

    if (tf.text.length == 16) {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"submitCardNo"        forKey:@"mode"];
        [dictParam setValue:tf.text                forKey:@"cardNo"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
                otf.text = @"";
                self.activateButton.enabled = YES;
                [self.sendOTPButton disableButtonAndStartTimer];
                
                [ApplicationUtils showAlertWithTitle:@"" andMessage:@"OTP has been sent to your registered mobile number. Please enter OTP and press activate button"];
            }
        }];
    }
    else {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid card number"];
    }
}

- (IBAction)activateButtonAction:(id)sender {
   
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    UITextField *tf = (UITextField *)[self.cardNumberView viewWithTag:101];

    if ([ApplicationUtils validateStringData:otf.text].length > MAX_OTP_LENGTH || [ApplicationUtils validateStringData:otf.text].length < MIN_OTP_LENGTH) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid OTP"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"submitCardOtp"        forKey:@"mode"];
        [dictParam setValue:tf.text                 forKey:@"cardNo"];
        [dictParam setValue:otf.text                forKey:@"otp"];

        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [self getLoginDetailsFromServer];
            }
        }];
    }
}

#pragma mark - Service

- (void)getLoginDetailsFromServer
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"getLoginData"     forKey:@"mode"];
    [dictParam setValue:@"iOS"              forKey:@"device_type"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        
        NSString *message = @"";
        
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            message = [ApplicationUtils validateStringData:response[@"msg"]];
        }
        else {
            [[AppDelegate instance] updateLoginData:response];
            message = @"Your card activation is under process, it will activate soon.";
        }
        
        [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Your card activation is under process, it will activate soon." cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
            
            [[AppDelegate instance].leftMenuReferenceVC selectMenuActionWithIndex:0];
            
        }] otherButtonItems: nil];
        [[AlertViewManager sharedManager].alertView show];
    }];
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    UITextField *tf = (UITextField *)[self.cardNumberView viewWithTag:101];
    
    if(textField == tf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 16) ? NO : [string isEqualToString:filtered];
    }
    
    UITextField *otf = (UITextField *)[self.otpView viewWithTag:101];
    
    if(textField == otf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > MAX_OTP_LENGTH) ? NO : [string isEqualToString:filtered];
    }
    
    return YES;
}

@end
