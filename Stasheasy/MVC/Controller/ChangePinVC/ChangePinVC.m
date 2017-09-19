//
//  ChangePinVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 03/08/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ChangePinVC.h"
#import "REFrostedViewController.h"
#import "ServerCall.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>
#import "AppDelegate.h"

@interface ChangePinVC ()<UITextFieldDelegate,LGPlusButtonsViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    NSString *strOTP;
    BOOL isStashExpand;

}
@property (nonatomic, strong) IBOutlet UITextField* txtOTP;
@property (nonatomic, strong) IBOutlet UIButton* btnSubmit;
@property (nonatomic, strong) IBOutlet UIView* viewTextfield;

@property (nonatomic, strong) IBOutlet UILabel* lblCardNo;
@property (nonatomic, strong) IBOutlet UILabel* lblCardDate;

@end

@implementation ChangePinVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    _viewTextfield.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
//    [self addStashfinButtonView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark Textfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_txtOTP becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtOTP resignFirstResponder];
    return YES;
}
#pragma mark LGPlusButtonsView
- (void)addStashfinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:5 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    //stashfinButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    stashfinButton.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    stashfinButton.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    
    [stashfinButton setDescriptionsTexts:@[@"", @"Lost/Stolan Card", @"Change Pin", @"Reload Card",@"Chat"]];
    
    [stashfinButton setButtonsImages:@[[UIImage imageNamed:@"actionBtn"], [UIImage imageNamed:@"lostCardBtn"], [UIImage imageNamed:@"pinBtn"], [UIImage imageNamed:@"topupcardBtn"] ,[UIImage imageNamed:@"chatBtn"]]
                            forState:UIControlStateNormal
                      forOrientation:LGPlusButtonsViewOrientationAll];
    if ([[self.storyboard valueForKey:@"name"] isEqual:@"iPhone"])
    {
        [stashfinButton setButtonsSize:CGSizeMake(60.f, 60.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:60.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:16] forOrientation:LGPlusButtonsViewOrientationAll];
    }
    else
    {
        [stashfinButton setButtonsSize:CGSizeMake(90.f, 90.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:90.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:26.0] forOrientation:LGPlusButtonsViewOrientationAll];
    }
    
    [stashfinButton setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    // [stashfinButton setButtonsLayerShadowColor:[UIColor whiteColor]];
    [stashfinButton setButtonsLayerShadowOpacity:0.5];
    [stashfinButton setButtonsLayerShadowRadius:3.f];
    [stashfinButton setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    
    [stashfinButton setDescriptionsTextColor:[UIColor whiteColor]];
    [stashfinButton setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [stashfinButton setDescriptionsLayerShadowOpacity:0.25];
    [stashfinButton setDescriptionsLayerShadowRadius:1.f];
    [stashfinButton setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [stashfinButton setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    //[stashfinButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [stashfinButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) forOrientation:LGPlusButtonsViewOrientationAll];
    
    [self.view addSubview:stashfinButton];
}
#pragma mark LGPlusButtonsView Delegate
- (void)plusButtonsViewDidHideButtons:(LGPlusButtonsView *)plusButtonsView
{
    isStashExpand = NO;
}
- (void)plusButtonsView:(LGPlusButtonsView *)plusButtonsView buttonPressedWithTitle:(NSString *)title description:(NSString *)description index:(NSUInteger)index
{
    if (index == 0)
    {
        //        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
        //         {
        //             isStashExpand = NO;
        //         }];
    }
    else if (index == 1)
    {
        // Lost Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"LostStolenVC"];
         }];
    }
    else if (index == 2)
    {
        // Reload Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"ChangePinVC"];
         }];
    }
    else if (index == 3)
    {
        // Change Pin
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            [self navigateToViewControllerWithIdentifier:@"ReloadCardVC"];
        }];
    }
    else
    {
        //Chat
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"ChatScreen"];
         }];
    }
}
- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *vc = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)submitAction:(id)sender
{
    if ( [_btnSubmit.titleLabel.text isEqualToString:@"Generate OTP"]  )
    {
        [self serverCallToGetOTP];
    }
    else if ( [_btnSubmit.titleLabel.text isEqualToString:@"Submit"] )
    {
        if ( _txtOTP.text.length > 1 )
        {
            [self serverCallToSubmitOTP];
        }
        else
        {
            [Utilities showAlertWithMessage:@"Enter received OTP"];
        }
    }
    else
    {
        if ( _txtOTP.text.length == 4)
        {
            [self serverCallToChangePin];
        }
        else
        {
            [Utilities showAlertWithMessage:@"Pin length should be of 4 digits"];
        }
    }
}

#pragma mark Server Call
- (void)serverCallToGetOTP
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"sendCardPinChangeOtp" forKey:@"mode"];
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [Utilities showAlertWithMessage:response[@"msg"]];
                 _viewTextfield.hidden = NO;
                 [_txtOTP becomeFirstResponder];
                 [_btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}
- (void)serverCallToSubmitOTP
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"submitCardChangePinOtp",@"mode",_txtOTP.text,@"otp", nil];
    
    strOTP = _txtOTP.text;
    
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [Utilities showAlertWithMessage:response[@"msg"]];
                 _txtOTP.text = @"";
                 _txtOTP.placeholder = @"Enter new card pin";
                 [_txtOTP becomeFirstResponder];
                 [_btnSubmit setTitle:@"Change" forState:UIControlStateNormal];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}
- (void)serverCallToChangePin
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"changeCardPin",@"mode",_txtOTP.text,@"newPin",strOTP,@"otp", nil];
    
    strOTP = _txtOTP.text;
    
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [self showAlertWithTitle:@"Statshfin" withMessage:response[@"msg"]];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}
#pragma mark UIAlertController Delegate
-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message
{
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:atitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        [Utilities navigateToLOCDashboard:self.navigationController];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
