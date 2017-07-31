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

@interface ReloadCardVC ()<LGPlusButtonsViewDelegate,UITextFieldDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand, isButtonChecked;
    NSString *strTenure;
    UIImage *check, *uncheck;
    NSDictionary *param;

}
@property (weak, nonatomic) IBOutlet UILabel *lblRemainLOC;
@property (weak, nonatomic) IBOutlet UITextField *txtRequestAmount;
@property (weak, nonatomic) IBOutlet UIImageView *imageError;

@property (nonatomic, strong) IBOutlet RadioButton* radioButton;


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
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
    check = [UIImage imageNamed:@"radioChecked"];
    uncheck = [UIImage imageNamed:@"radioUncheck"];
    
    [Utilities setCornerRadius:_viewContainer];
//    _lblRemainLOC.text = strRemainLOC;
    
    _imageError.hidden = YES;
    isButtonChecked = NO;
    
    _btn1.tag = 1;
    _btn2.tag = 2;
    _btn3.tag = 3;
    _btn4.tag = 4;
    _btn5.tag = 5;
    _btn6.tag = 6;
    
    
    [self addStashfinButtonView];
    isStashExpand = NO;
    
    [self serverCallForWithdrawalRerquestForm];
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

#pragma mark Buton Action
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)requestReloadAction:(id)sender
{
    if ( [self performValidation] )
    {
        [self serverCallForRequestReload];
    }
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
- (void)serverCallForRequestReload
{
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
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
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 param = [NSDictionary dictionary];
                 _lblRemainLOC.text = [NSString stringWithFormat:@"%.2f",[[response valueForKey:@"remaining_loc"] doubleValue]];
                 if ([response valueForKey:@"false"])
                 {
                     [Utilities showAlertWithMessage:@""];
                     _btnRequestReload.userInteractionEnabled = NO;
                 }
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
     }];
}
- (void)navigateToLOCWithdrawalVC:(NSDictionary *)response
{
    LOCWithdrawalVC *locWithdrawalVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"LOCWithdrawalVC"];
    locWithdrawalVC.dictResponce = response;
    [self.navigationController pushViewController:locWithdrawalVC animated:YES];
    
}
@end
