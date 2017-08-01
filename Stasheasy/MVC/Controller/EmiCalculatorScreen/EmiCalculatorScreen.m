//
//  EmiCalculatorScreen.m
//  Stasheasy
//
//  Created by tushar on 18/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "EmiCalculatorScreen.h"
#import "EmiCell.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>

@interface EmiCalculatorScreen ()<LGPlusButtonsViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;
    int principal,rate,installmentsNo;
}
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTenure;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblInterest;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;


@property (weak, nonatomic) IBOutlet UITableView *emiTableView;
@property (weak, nonatomic) IBOutlet UIView *emiView;

@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UISlider *tenureSlider;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;

@end

@implementation EmiCalculatorScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBarHidden = YES;
    principal = 100000;
    installmentsNo = 3;
    rate = 12;
    
    _lblAmount.text = [NSString stringWithFormat:@"₹%d",principal];
    _lblTenure.text = [NSString stringWithFormat:@"%d Months",installmentsNo];
    _lblRate.text = [NSString stringWithFormat:@"%d",rate];

    [self calculateEMI];
    [self addStashfinButtonView];
    isStashExpand = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark LGPlusButtonsView
- (void)addStashfinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:5 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    //stashfinButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    stashfinButton.plusButtonAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndPop;
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

#pragma mark Button Action
- (IBAction)amountSliderValueChanged:(id)sender
{
    float number = [_amountSlider value];
    int value = (int)(number * 20);
    
    if (value == 0)
    {
        principal = 10000;
        _lblAmount.text = [NSString stringWithFormat:@"₹%d",principal];
    }
    else
    {
        principal = value * 10000;
        _lblAmount.text = [NSString stringWithFormat:@"₹%d", principal];
    }
    [self calculateEMI];
}
- (IBAction)tenureSliderValueChanged:(id)sender
{
    float number = [_tenureSlider value];
    int value = (int)(number * 15) + 3;
    if (value == 0)
    {
        installmentsNo = 3;
        _lblTenure.text = [NSString stringWithFormat:@"%d Months",installmentsNo];
    }
    else
    {
        installmentsNo = value;
        _lblTenure.text = [NSString stringWithFormat:@"%d Months",installmentsNo];
    }
    [self calculateEMI];
}
- (IBAction)rateSliderValueChanged:(id)sender
{
    float number = [_rateSlider value];
    int value = (int)(number * 60);
    if (value == 0)
    {
        rate = 1;
        _lblRate.text = [NSString stringWithFormat:@"%d",rate];
    }
    else
    {
        rate = value;
        _lblRate.text = [NSString stringWithFormat:@"%d",rate];
    }
    [self calculateEMI];
}
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];

}
- (void)calculateEMI
{
    float r = rate / (12.0f * 100.0f);
    double compo = pow((1 + r), installmentsNo);
    double devo = compo - 1;
    
    int EMI = (principal * r * compo) / devo;
    NSLog(@"EMI ===== %d", EMI);
    
    _lblEMIAmount.text = [NSString stringWithFormat:@"₹%d",EMI];
    _lblInterest.text = [NSString stringWithFormat:@"₹%d",(EMI * installmentsNo)  - principal];
    _lblTotal.text = [NSString stringWithFormat:@"₹%d",(EMI * installmentsNo)];
}

@end
