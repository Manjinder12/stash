//
//  LineCreditVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LineCreditVC.h"
#import "ServerCall.h"
#import "REFrostedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <LGPlusButtonsView/LGPlusButtonsView.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "ConsolidatedEMIVC.h"
#import "ReloadCardVC.h"

@interface LineCreditVC ()<LGPlusButtonsViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;
    NSString *strRemainLOC;
}
@property (weak, nonatomic) IBOutlet UILabel *lblApprovedCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblUserCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblCash;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestStatus;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UIView *viewLower;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation LineCreditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    
    _viewUpper.layer.shadowOffset = CGSizeMake(1, 1);
    _viewUpper.layer.shadowRadius = 4;
    _viewUpper.layer.shadowOpacity = 0.5;
    _viewUpper.layer.cornerRadius = 8.0f;
    _viewUpper.layer.masksToBounds = YES;
    _viewUpper.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    _viewLower.layer.shadowOffset = CGSizeMake(1, 1);
    _viewLower.layer.shadowRadius = 4;
    _viewLower.layer.shadowOpacity = 0.5;
    _viewLower.layer.cornerRadius = 8.0f;
    _viewLower.layer.masksToBounds = YES;
    _viewLower.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    _scrollView.contentSize = CGSizeMake(_viewContainer.frame.size.width, _viewContainer.frame.size.height);
    _scrollView.autoresizingMask = YES;
    _scrollView.scrollEnabled = YES;

    
    [self serverCallForWithdrawalRequest];

}
- (void)viewDidLayoutSubviews
{
    _scrollView.contentSize = CGSizeMake(_viewContainer.frame.size.width, _viewContainer.frame.size.height);
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.scrollEnabled = YES;
}
#pragma mark LGPlusButtonsView
- (void)addStashfinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:6 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    //stashfinButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    stashfinButton.plusButtonAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndPop;
    stashfinButton.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    
    [stashfinButton setDescriptionsTexts:@[@"", @"Lost/Stolan Card", @"Change Pin", @"Reload Card",@"Apply fr new loan",@"Chat"]];
    
    [stashfinButton setButtonsImages:@[[UIImage imageNamed:@"actionBtn"], [UIImage imageNamed:@"lostCardBtn"], [UIImage imageNamed:@"pinBtn"], [UIImage imageNamed:@"topupcardBtn"],[UIImage imageNamed:@"loanBtn"] ,[UIImage imageNamed:@"chatBtn"]]
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Button Action
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

#pragma mark Server Call
- (void)serverCallForWithdrawalRequest
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"locDetails" forKey:@"mode"];
    
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
                [self populateLOCDetails:response];
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
    
    
    }];
}
- (void)populateLOCDetails:(NSDictionary *)dictLOC
{
    _lblApprovedCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"loc_limit"] intValue]];
    _lblUserCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"used_loc"] intValue]];
    
    strRemainLOC = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"remaining_loc"] intValue]];
    _lblRemainCredit.text = strRemainLOC;
    
    _lblBalance.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"total_balance"] intValue]];
    _lblCash.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"last_loc_request_amount"] intValue]];
    _lblEMIDate.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"next_emi_date"] intValue]];
    _lblEMIAmount.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"next_emi_amount"] intValue]];
    _lblRequestAmount.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"last_loc_request_amount"] intValue]];
    _lblRequestStatus.text = [NSString stringWithFormat:@"%@",[dictLOC valueForKey:@"last_loc_request_status"]].uppercaseString;
    
    NSDictionary *dict = [Utilities getDayDateYear:[dictLOC valueForKey:@"last_loc_request_date"]];
    
    _lblRequestDate.text = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForKey:@"day"],[dict valueForKey:@"month"],[dict valueForKey:@"year"]];


}
- (IBAction)consolidatedEMIAction:(id)sender
{
    ConsolidatedEMIVC *consolidatedEMIVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"ConsolidatedEMIVC"];
    [self.navigationController pushViewController:consolidatedEMIVC animated:YES];
}
-(IBAction)reloadCardAction:(id)sender
{
    ReloadCardVC *reloadCardVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"ReloadCardVC"];
    reloadCardVC.strRemainLOC = strRemainLOC;
    [self.navigationController pushViewController:reloadCardVC animated:YES];

    
}
- (IBAction)refreshAction:(id)sender
{
    NSLog(@"refreshAction");
    NSLog(@"refreshAction");
    NSLog(@"refreshAction");
    NSLog(@"consolidatedEMIAction");

}

@end
