//
//  PaybackViewController.m
//  StashFin
//
//  Created by Mac on 04/12/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "PaybackViewController.h"
#import "PaybackResultViewController.h"


@interface PaybackViewController ()

@end

@implementation PaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.generatePinButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.submitButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    
    [ApplicationUtils setFieldViewProperties:self.numberView];
    [ApplicationUtils setFieldViewProperties:self.pinView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"PAYBACK";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (IBAction)generatePinButtonAction:(id)sender {
    UITextField *ntf = (UITextField *)[self.numberView viewWithTag:101];
    
    if (![ApplicationUtils validateStringData:ntf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter mobile or payback card number"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"getPassword"          forKey:@"mode"];
        [dictParam setValue:ntf.text                forKey:@"phone"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response[@"message"]];
            }
        }];
    }
}

- (IBAction)submitButtonAction:(id)sender {
    UITextField *ntf = (UITextField *)[self.numberView viewWithTag:101];
    UITextField *ptf = (UITextField *)[self.pinView viewWithTag:101];
    
    //SK Change
//    ntf.text = @"9532517547";
//    ptf.text = @"6344";
    
    if (![ApplicationUtils validateStringData:ntf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter mobile or payback card number"];
    }
    else if (![ApplicationUtils validateStringData:ptf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid pin"];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"PaybackRewardPoints"          forKey:@"mode"];
        [dictParam setValue:ntf.text                        forKey:@"phone"];
        [dictParam setValue:ptf.text                        forKey:@"pin"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
                PaybackResultViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PaybackResultViewController"];
                [vc setDataDic:response];
                [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    UITextField *ntf = (UITextField *)[self.numberView viewWithTag:101];
    
    if(textField == ntf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 16) ? NO : [string isEqualToString:filtered];
    }
    
    UITextField *ptf = (UITextField *)[self.pinView viewWithTag:101];
    
    if(textField == ptf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : [string isEqualToString:filtered];
    }
    
    return YES;
}


@end
