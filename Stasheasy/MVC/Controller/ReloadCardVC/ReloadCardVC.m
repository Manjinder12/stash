//
//  ReloadCardVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 27/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ReloadCardVC.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>
#import "ServerCall.h"
#import "Utilities.h"
#import "REFrostedViewController.h"
#import "RadioButton.h"
#import "LOCWithdrawalVC.h"
#import "JMMarkSlider.h"

@interface ReloadCardVC ()<LGPlusButtonsViewDelegate,UITextFieldDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand, isButtonChecked , isCreditSlider;
    NSString *strTenure;
    UIImage *check, *uncheck;
    NSDictionary *param;
    double principal;

    int installmentsNo, maxTenure, minTenure , minCredit, maxCredit;
    float rate;

}
@property (weak, nonatomic) IBOutlet UILabel *lblRemainLOC;
@property (weak, nonatomic) IBOutlet UILabel *lblTenure;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblMinCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxTenure;
@property (weak, nonatomic) IBOutlet UILabel *lblMinTenure;
@property (weak, nonatomic) IBOutlet UILabel *lblCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblEMI;

@property (weak, nonatomic) IBOutlet JMMarkSlider *tenureSlider;
@property (weak, nonatomic) IBOutlet JMMarkSlider *creditSlider;

@property (weak, nonatomic) IBOutlet UITextField *txtRequestAmount;
@property (weak, nonatomic) IBOutlet UIImageView *imageError;

@property (nonatomic, strong) IBOutlet RadioButton* radioButton;

@property (weak, nonatomic) IBOutlet UIButton *btnRequestReload;


@property (weak, nonatomic) IBOutlet UIView *viewContainer;


@end

@implementation ReloadCardVC
@synthesize strRemainLOC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    check = [UIImage imageNamed:@"radioChecked"];
    uncheck = [UIImage imageNamed:@"radioUncheck"];
    
    isCreditSlider = NO;
    _imageError.hidden = YES;

    installmentsNo = 3;

//    [self addStashFinButtonView];
    isStashExpand = NO;
    
    [ self setAllSlider ];
    
    [self serverCallForWithdrawalRerquestForm];
}

- (void)setAllSlider
{
    _creditSlider.markColor = [UIColor colorWithWhite:1 alpha:0.5];
    _creditSlider.markPositions = @[@0];
    _creditSlider.markWidth = 1.0;
    _creditSlider.selectedBarColor = [UIColor greenColor];
    _creditSlider.unselectedBarColor = [UIColor lightGrayColor];
    _creditSlider.handlerImage = [UIImage imageNamed:@"silderbtn"];
    
    _tenureSlider.markColor = [UIColor colorWithWhite:1 alpha:0.5];
    _tenureSlider.markPositions = @[@0];
    _tenureSlider.markWidth = 1.0;
    _tenureSlider.selectedBarColor = [UIColor greenColor];
    _tenureSlider.unselectedBarColor = [UIColor lightGrayColor];
    _tenureSlider.handlerImage = [UIImage imageNamed:@"silderbtn"];
}

#pragma mark LGPlusButtonsView
- (void)addStashFinButtonView
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Buton Action
-(IBAction)backAction:(id)sender
{
    [Utilities navigateToLOCDashboard:self.navigationController];
}
- (IBAction)tenureSliderValueChanged:(id)sender
{
    isCreditSlider = NO;

    float number = [_tenureSlider value];
    float value = (float)(number * maxTenure) ;
    if (value == 0)
    {
        installmentsNo = minTenure;
        _lblTenure.text = [NSString stringWithFormat:@"%d Months",installmentsNo];
    }
    else
    {
        installmentsNo = value + minTenure;
        _lblTenure.text = [NSString stringWithFormat:@"%d Months",installmentsNo];
    }
    
}
- (IBAction)creditSliderValueChanged:(id)sender
{
    isCreditSlider = YES;
    
    NSString *strValue = [ NSString stringWithFormat:@"%.02f",[_creditSlider value]];
    float number = [strValue floatValue];
    int value = (int)(number * maxCredit);
    principal = value;

    if (value == 0)
    {
        principal = minCredit;
        _lblCredit.text = [NSString stringWithFormat:@"%.0f",principal];
    }
    else
    {
        _lblCredit.text = [NSString stringWithFormat:@"%.0f",principal];
    }
}
- (IBAction)allsliderAction:(id)sender
{
    [ _tenureSlider setContinuous:YES ];
    [ _creditSlider setContinuous:YES ];
    
    if ( isCreditSlider )
    {
        [ self serverCallToGetTenure ];
    }
    else
    {
        [ self calculateEMI ];
    }
}
-(IBAction)radioButtonAction:(RadioButton*)sender
{
    RadioButton *btn = (RadioButton *)sender;
    isButtonChecked = YES;
    _imageError.hidden = YES;
    
    switch (btn.tag)
    {
        case 1:
            strTenure = @"3";
            break;
            
        case 2:
            strTenure = @"6";
            break;
            
        case 3:
            strTenure = @"9";
            break;
            
        case 4:
            strTenure = @"12";
            break;
            
        case 5:
            strTenure = @"15";
            break;
            
        case 6:
            strTenure = @"18";
            break;
            
        default:
            break;
    }
    
}
- (void)calculateEMI
{
    float r = rate / (12.0f * 100.0f);
    double compo = pow((1 + r), installmentsNo);
    double devo = compo - 1;
    
    double EMI =  (principal * r * compo) / devo;;
    
    NSLog(@"EMI ===== %.0f", EMI);
    
    _lblEMI.text = [NSString stringWithFormat:@"EMI ₹ %.0f",EMI];
    
}
- (IBAction)requestReloadAction:(id)sender
{
    [self serverCallForRequestReload];

}

#pragma mark Server Call
- (void)serverCallForRequestReload
{
    NSMutableDictionary *mdictParam = [NSMutableDictionary new];
    [ mdictParam setValue:@"locWithdrawalRequest" forKey:@"mode"];
    [ mdictParam setValue:_lblCredit.text forKey:@"amount"];
    [ mdictParam setValue:_lblTenure.text forKey:@"tenure"];
    
    [ServerCall getServerResponseWithParameters:mdictParam withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"locWithdrawalRequest response == %@", response);
        
        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                [self navigateToLOCWithdrawalVC:response];
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
        
    }];
}
- (void)serverCallForWithdrawalRerquestForm
{
    param = [ NSDictionary dictionaryWithObjectsAndKeys:@"locWithdrawalRequestform",@"mode", nil];

    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 _viewContainer.hidden = YES;
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [self populateWithrawalRequestForm:response];
                
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
     }];
}
- (void)serverCallToGetTenure
{
   NSDictionary *dictParam = [ NSDictionary dictionaryWithObjectsAndKeys:@"locWithdrawalRequestform",@"mode",_lblCredit.text,@"amount", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [ self populateTenureDetail:response ];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
     }];
}

#pragma mark Helper Method
- (void)populateTenureDetail:(NSDictionary *)response
{
    rate = [[response valueForKey:@"rate_of_interest"] floatValue];
    
    minTenure = [[response valueForKey:@"min_tenure"] intValue];
    maxTenure = [[response valueForKey:@"max_tenure"] intValue];
    
    _lblMinTenure.text = [NSString stringWithFormat:@"%d Months",minTenure];
    _lblMaxTenure.text = [NSString stringWithFormat:@"%d Months",maxTenure];
    
    maxTenure = maxTenure - minTenure;

    [ self calculateEMI ];
}
- (void)populateWithrawalRequestForm:(NSDictionary *)response
{
    param = [NSDictionary dictionary];
    
    _lblRemainLOC.text = [NSString stringWithFormat:@"%d",[[response valueForKey:@"remaining_loc"] intValue]];
    
    _lblCredit.text = [NSString stringWithFormat:@"%d",[[response valueForKey:@"minimum_request_amount"] intValue]];
    
    _lblMinCredit.text = [NSString stringWithFormat:@"%d",[[response valueForKey:@"minimum_request_amount"] intValue]];
    
    _lblMaxCredit.text = [NSString stringWithFormat:@"%d",[[response valueForKey:@"remaining_loc"] intValue]];
    
    minCredit = [[response valueForKey:@"minimum_request_amount"] intValue];
    maxCredit = [[response valueForKey:@"remaining_loc"] intValue];
    principal = minCredit;
    
    rate = [[response valueForKey:@"rate_of_interest"] floatValue];
    
    minTenure = [[response valueForKey:@"min_tenure"] intValue];
    maxTenure = [[response valueForKey:@"max_tenure"] intValue];
    
    _lblMinTenure.text = [NSString stringWithFormat:@"%d Months",minTenure];
    _lblMaxTenure.text = [NSString stringWithFormat:@"%d Months",maxTenure];
    
    maxTenure = maxTenure - minTenure;
    
    [ self calculateEMI ];
    
    _viewContainer.hidden = NO;
    
}
- (void)navigateToLOCWithdrawalVC:(NSDictionary *)response
{
    LOCWithdrawalVC *locWithdrawalVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"LOCWithdrawalVC"];
    locWithdrawalVC.dictResponce = response;
    [self.navigationController pushViewController:locWithdrawalVC animated:YES];
    
}
- (BOOL)performValidation
{
    if ([_txtRequestAmount.text isEqualToString:@""])
    {
        [Utilities showAlertWithMessage:@"Please enter Request Amount"];
    }
    else if ( !isButtonChecked )
    {
        _imageError.hidden = NO;
    }
    else if ([_txtRequestAmount.text intValue] > [strRemainLOC intValue])
    {
        [Utilities showAlertWithMessage:[NSString stringWithFormat:@"You have limit of ₹%@",strRemainLOC]];
    }
    else
    {
        param = [ NSDictionary dictionaryWithObjectsAndKeys:@"locWithdrawalRequest",@"mode",_txtRequestAmount.text,@"amount",strTenure,@"tenure", nil];
        return YES;
    }
    return NO;
    
}
@end
