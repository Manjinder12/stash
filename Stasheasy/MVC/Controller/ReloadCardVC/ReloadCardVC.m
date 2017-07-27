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

@interface ReloadCardVC ()<LGPlusButtonsViewDelegate,UITextFieldDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand, isButtonChecked;
    NSString *strTenure;
    UIImage *check, *uncheck;
    NSInteger buttonTag;

}
@property (weak, nonatomic) IBOutlet UILabel *lblRemainLOC;
@property (weak, nonatomic) IBOutlet UITextField *txtRequestAmount;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;


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
    check = [UIImage imageNamed:@"radioChecked"];
    uncheck = [UIImage imageNamed:@"radioUncheck"];
    
    _lblRemainLOC.text = strRemainLOC;
    
    isButtonChecked = NO;
    buttonTag = 0;
    
    _btn1.tag = 1;
    _btn2.tag = 2;
    _btn3.tag = 3;
    _btn4.tag = 4;
    _btn5.tag = 5;
    _btn6.tag = 6;
    
    
    [self addStashfinButtonView];
    isStashExpand = NO;
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

-(IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];

}
- (IBAction)radioButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([btn backgroundImageForState:UIControlStateNormal] == uncheck
        )
    {
        isButtonChecked = YES;
        [btn setBackgroundImage:check forState:UIControlStateNormal];
        switch (btn.tag)
        {
            case 1:
                strTenure = @"3";
                buttonTag = btn.tag;
                break;
                
            case 2:
                strTenure = @"6";
                buttonTag = btn.tag;
                break;
                
            case 3:
                strTenure = @"9";
                buttonTag = btn.tag;
                break;
                
            case 4:
                strTenure = @"12";
                buttonTag = btn.tag;
                break;
                
            case 5:
                strTenure = @"15";
                buttonTag = btn.tag;
                break;
                
            case 6:
                strTenure = @"18";
                buttonTag = btn.tag;
                break;
                
            default:
                break;
        }
    }
    else
    {
        isButtonChecked = NO;
        [btn setBackgroundImage:uncheck forState:UIControlStateNormal];
        strTenure = @"";
    }
}
- (IBAction)requestReloadAction:(id)sender
{
    if (isButtonChecked)
    {
        [self serverCallForRequestReload];
    }
    else
    {
        [Utilities showAlertWithMessage:@"Please select tenure"];
    }
}
- (void)serverCallForRequestReload
{
    NSDictionary *param = [ NSDictionary dictionaryWithObjectsAndKeys:@"locWithdrawalRequest",@"mode",_txtRequestAmount.text,@"amount",strTenure,@"tenure", nil];
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        
        NSLog(@"response == %@", response);
        NSLog(@"response == %@", response);
        
    }];
}
@end
