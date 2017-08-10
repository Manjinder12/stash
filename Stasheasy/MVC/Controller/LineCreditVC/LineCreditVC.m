    //
//  LineCreditVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LineCreditVC.h"
#import <QuartzCore/QuartzCore.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>
#import "REFrostedViewController.h"
#import "ServerCall.h"
#import "ConsolidatedEMIVC.h"
#import "ReloadCardVC.h"
#import "REFrostedViewController.h"
#import "ChatScreen.h"
#import "VBPieChart.h"

@interface LineCreditVC ()<LGPlusButtonsViewDelegate>
{
    AppDelegate *appDelegate;
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;
    NSString *strRemainLOC;
    NSDictionary *dictLOCDetail;
    int approvedLOC, usedLOC, remainingLOC, usedValue, remainValue ;
    double pieProgress;
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
@property (weak, nonatomic) IBOutlet UILabel *lblCardNo;
@property (weak, nonatomic) IBOutlet UILabel *lblCardDate;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UIView *viewLower;
@property (weak, nonatomic) IBOutlet UIView *viewOuter;

@property (weak, nonatomic) IBOutlet VBPieChart *viewPieChart;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnsViewLOCdetailTop;

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
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    appDelegate = [AppDelegate sharedDelegate];
    
    [ Utilities setShadowToView:_viewUpper ];
    [ Utilities setShadowToView:_viewLower ];
    
    approvedLOC = 0;
    usedLOC = 0;
    remainingLOC = 0;
    pieProgress = 0;
    
    _viewOuter.hidden = NO;
    [self serverCallForLOCDetails];

}
- (void)viewWillAppear:(BOOL)animated
{
    
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
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
        {
            isStashExpand = NO;
            if ( [appDelegate.loanRequestStatus  isEqual: @"PENDING"])
            {
                [Utilities showAlertWithMessage:@"Can not reload card, last LOC pending"];
            }
            else
            {
                [self navigateToViewControllerWithIdentifier:@"ReloadCardVC"];
            }
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
- (void)serverCallForLOCDetails
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"locDetails" forKey:@"mode"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
                if ([[response valueForKey:@"card_found"] boolValue] == true)
                {
                    dictLOCDetail = [NSDictionary dictionaryWithDictionary:response];
                    [self serverCallForCardOverview];
                }
                else
                {
                    _cnsViewLOCdetailTop.constant = 10;
                }
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
    
    
    }];
}
- (void)serverCallForCardOverview
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"cardOverview" forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
    {
        
        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                [self populateLOCDetails:dictLOCDetail andCardDetail:response];
                
                [self addStashfinButtonView];
                isStashExpand = NO;
                _viewOuter.hidden = YES;
            }
        }
        else
        {
//            [Utilities showAlertWithMessage:response];
        }
        
        [SVProgressHUD dismiss];
    }];
}
- (void)populateLOCDetails:(NSDictionary *)dictLOC andCardDetail:(NSDictionary *)dictCard
{
    _lblApprovedCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"loc_limit"] intValue]];
    
    approvedLOC = [[dictLOC valueForKey:@"loc_limit"] intValue];
    
    _lblUserCredit.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"used_loc"] intValue]];
    usedLOC = [[dictLOC valueForKey:@"used_loc"] intValue];

    strRemainLOC = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"remaining_loc"] intValue]];
    remainingLOC = [[dictLOC valueForKey:@"remaining_loc"] intValue];
    _lblRemainCredit.text = strRemainLOC;
    
    _lblBalance.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"total_balance"] intValue]];
    _lblCash.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"last_loc_request_amount"] intValue]];
    _lblEMIDate.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"next_emi_date"] intValue]];
    _lblEMIAmount.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"next_emi_amount"] intValue]];
    _lblRequestAmount.text = [NSString stringWithFormat:@"%d",[[dictLOC valueForKey:@"last_loc_request_amount"] intValue]];
    appDelegate.loanRequestStatus = [NSString stringWithFormat:@"%@",[dictLOC valueForKey:@"last_loc_request_status"]].uppercaseString;
    _lblRequestStatus.text = appDelegate.loanRequestStatus;
    
    NSDictionary *dict = [Utilities getDayDateYear:[dictLOC valueForKey:@"last_loc_request_date"]];
    
    _lblRequestDate.text = [NSString stringWithFormat:@"%@ %@ %@",[dict valueForKey:@"day"],[dict valueForKey:@"month"],[dict valueForKey:@"year"]];
    
    _lblCardNo.text = [NSString stringWithFormat:@"%@",dictCard[@"card_details"][@"card_no"]];
    _lblCardDate.text = [NSString stringWithFormat:@"%@/%@",dictCard[@"card_details"][@"expiry_month"],dictCard[@"card_details"][@"expiry_year"]];
    
    [self setUpPieChart];
}
- (void)setUpPieChart
{
    usedValue = (usedLOC * 100) / approvedLOC;
    remainValue = (remainingLOC * 100 ) / approvedLOC;
   
    _viewPieChart.startAngle = M_PI+M_PI_2;
    [_viewPieChart setHoleRadiusPrecent:0.5];
    
    
    
    NSArray *chartValues = @[
                         @{@"name":@"Apple", @"value":[NSNumber numberWithInt:usedValue], @"color":[UIColor redColor], @"strokeColor":[UIColor whiteColor]},
                         @{@"name":@"Orange", @"value":[NSNumber numberWithInt:remainValue], @"color":[UIColor greenColor], @"strokeColor":[UIColor whiteColor]}
                         ];

    [_viewPieChart setChartValues:chartValues animation:YES duration:2 options:VBPieChartAnimationDefault];
}
- (IBAction)consolidatedEMIAction:(id)sender
{
    ConsolidatedEMIVC *consolidatedEMIVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"ConsolidatedEMIVC"];
    [self.navigationController pushViewController:consolidatedEMIVC animated:YES];
}
-(IBAction)reloadCardAction:(id)sender
{
    if ([appDelegate.loanRequestStatus isEqualToString:@"PENDING"])
    {
        [Utilities showAlertWithMessage:@"Can not reload card, last LOC pending"];
    }
    else
    {
        ReloadCardVC *reloadCardVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"ReloadCardVC"];
        reloadCardVC.strRemainLOC = strRemainLOC;
        [self.navigationController pushViewController:reloadCardVC animated:YES];
    }
    
    
}
- (IBAction)refreshAction:(id)sender
{
    NSLog(@"refreshAction");
    NSLog(@"refreshAction");
    NSLog(@"refreshAction");
    NSLog(@"consolidatedEMIAction");

}

@end
