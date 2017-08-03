//
//  LoginScreen.m
//  Stasheasy
//
//  Created by duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LoginScreen.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "UserServices.h"
#import "CommonFunctions.h"
#import "ServerCall.h"
#import "REFrostedViewController.h"

@interface LoginScreen ()
{
    UserServices *service;
    NSMutableDictionary *param;
    REFrostedViewController *refrostedVC;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
  }
- (void)customInitialization
{
    service = [[UserServices alloc] init];
    param = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBar.hidden = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gesture];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark Button Action
- (IBAction)loginAction:(id)sender
{
    if ([self performValidation])
    {
        [self serverCallForLogin];
    }
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)facebookAction:(id)sender
{
    
}
- (IBAction)googleAction:(id)sender
{
    
}
- (IBAction)forgotPasswordAction:(id)sender
{
    
}

-(BOOL)performValidation
{
    NSString *message;
    if ([_txtEmail.text isEqualToString:@""])
    {
        message = @"Please enter email";
    }
    else if ([_txtPassword.text isEqualToString:@""])
    {
        message = @"Please enter password";
    }
    else
    {
        [param setObject:_txtEmail.text forKey:@"email"];
        [param setObject:_txtPassword.text forKey:@"password"];
        [param setObject:@"login" forKey:@"mode"];
        [param setObject:[NSString stringWithFormat:@"%@",[Utilities getDeviceUDID]] forKey:@"device_id"];
        return YES;
    }
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Staheasy" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    return NO;
}

#pragma mark - Server Call
- (void)serverCallForLogin
{
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"response === %@", response);

        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
                [Utilities setUserDefaultWithObject:[ response objectForKey:@"auth_token"] andKey:@"auth_token"];
                
                ViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
    }];
}
-(void)loginApiCall
{
    if ([CommonFunctions reachabiltyCheck]) {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        NSString *post =[NSString stringWithFormat:@"mode=login&device_id=%@&email=%@&password=%@",[param objectForKey:@"device_id"],[param objectForKey:@"email"],[param objectForKey:@"password"]];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
                NSString *errorStr = [responseDic objectForKey:@"error"];
                if (errorStr.length>0) {
                    [self showAlertWithTitle:@"stasheasy" withMessage:errorStr];
                    UIViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
                }
                else {
                    UIViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
                    [CommonFunctions setUserDefault:@"islogin" value:@"1"];
                }
            });
        }]
         
         resume
         ];

    } else {
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
}

#pragma mark UIAlertController Delegate
-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message
{
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:atitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
