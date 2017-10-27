//
//  ResidencePinVC.m
//  Stasheasy
//
//  Created by Tushar  on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ResidencePinVC.h"
#import "SignupScreen.h"
#import "AppDelegate.h"

@interface ResidencePinVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pintextField;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)nextBtnTapped:(id)sender;

@end

@implementation ResidencePinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pintextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( _pintextField.text.length >=6 && range.length == 0 )
    {
        return NO;
    }
    return YES;
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextBtnTapped:(id)sender {
    
    if (self.pintextField.text.length == 0) {
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:nil message:@"Please enter pin" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else {
        AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        appdelegate.cityName =self.cityName;
        appdelegate.cityId =self.cityid;
        appdelegate.stateName =self.stateName;
        appdelegate.stateid =self.stateId;
        appdelegate.residencePin = self.pintextField.text;
        
        NSArray *vcArr = [self.navigationController viewControllers];
        for (UIViewController *controller in vcArr)
        {
            if ([controller isKindOfClass:[SignupScreen  class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scp" object:nil];
    }
    
}
@end
