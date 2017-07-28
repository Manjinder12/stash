//
//  LOCWithdrawalVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 28/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LOCWithdrawalVC.h"
#import "ServerCall.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>

@interface LOCWithdrawalVC ()<LGPlusButtonsViewDelegate,UIAlertViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;
}
@property (weak, nonatomic) IBOutlet UILabel *lblRemainLOC;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTenure;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNetPayable;

@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UIView *viewLower;


@end

@implementation LOCWithdrawalVC
@synthesize dictResponce;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    
    [Utilities setCornerRadius:_viewUpper];
    [Utilities setCornerRadius:_viewLower];
    
    [self addStashfinButtonView];
    isStashExpand = NO;
    
    [self populateLOCWithrawalResponse];
}
- (void)populateLOCWithrawalResponse
{
    _lblRemainLOC.text = [NSString stringWithFormat:@"%d",[[dictResponce valueForKey:@"remaining_loc"] intValue]];
    
    _lblRate.text = [NSString stringWithFormat:@"%d",[[dictResponce valueForKey:@"rate_of_interest"] intValue]];
  
    _lblRequestAmount.text = [NSString stringWithFormat:@"%@",[dictResponce valueForKey:@"requested_amount"]] ;
   
    _lblEMIAmount.text = [NSString stringWithFormat:@"%@",[dictResponce valueForKey:@"emi_amount"]];
    
    _lblTenure.text = [NSString stringWithFormat:@"%@",[dictResponce valueForKey:@"tenure"]];
    
    _lblDate.text = [NSString stringWithFormat:@"%@",[dictResponce valueForKey:@"first_emi_date"]];
    
    _lblNetPayable.text = [NSString stringWithFormat:@"%@",[dictResponce valueForKey:@"net_amount_payable"]];
}

#pragma mark LGPlusButtonsView
- (void)addStashfinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:6 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    //stashfinButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    stashfinButton.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    stashfinButton.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    
    [stashfinButton setDescriptionsTexts:@[@"", @"Lost/Stolen Card", @"Change Pin", @"Reload Card",@"Apply fr new loan",@"Chat"]];
    
    [stashfinButton setButtonsImages:@[[UIImage imageNamed:@"actionBtn"], [UIImage imageNamed:@"lostCardBtn"], [UIImage imageNamed:@"pinBtn"], [UIImage imageNamed:@"topupcardBtn"],[UIImage imageNamed:@"loanBtn"] ,[UIImage imageNamed:@"chatBtn"]]
                            forState:UIControlStateNormal
                      forOrientation:LGPlusButtonsViewOrientationAll];
    if ([[self.storyboard valueForKey:@"name"] isEqual:@"iPhone"])
    {
        [stashfinButton setButtonsSize:CGSizeMake(60.f, 60.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:60.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:13] forOrientation:LGPlusButtonsViewOrientationAll];
        
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
    [self.view bringSubviewToFront:stashfinButton];
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
        
    }
    else if (index == 1)
    {
        // Lost Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            //            AddInvoiceQuoteVC *addInvoiceQuoteVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"AddInvoiceQuoteVC"];
            //            addInvoiceQuoteVC.isInvoice = YES;
            //            [ self.navigationController pushViewController:addInvoiceQuoteVC animated:YES ];
            
        }];
    }
    else if (index == 2)
    {
        // Change Pin
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            //            AddNoteVC *addNoteVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"AddNoteVC"];
            //            addNoteVC.tempScheduleObject = _tempScheduleObject;
            //            [ self.navigationController pushViewController:addNoteVC animated:YES ];
            
        }];
    }
    else if (index == 3)
    {
        // Reload Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            
        }];
    }
    else if (index == 4)
    {
        //Apply for new loan
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            //            AddInvoiceQuoteVC *addInvoiceQuoteVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"AddInvoiceQuoteVC"];
            //            addInvoiceQuoteVC.isInvoice = NO;
            //            [ self.navigationController pushViewController:addInvoiceQuoteVC animated:YES ];
            
        }];
    }
    else
    {
        //Chat
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Action

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender
{
    [self serverCammForLOCWithdrawolConfirmation];
}
- (void)serverCammForLOCWithdrawolConfirmation
{
    NSDictionary *param = [ NSDictionary dictionaryWithObjectsAndKeys:@"locWithdrawalConfirm",@"mode",_lblRemainLOC.text,@"amount",_lblTenure.text,@"tenure", nil];

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
                [self showAlertWithTitle:@"Stashfin" withMessage:[response valueForKey:@"msg"]];

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
        [Utilities popToNumberOfControllers:2 withNavigation:self.navigationController];
    }];
    
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
