//
//  DashboardScreen.m
//  Stasheasy
//
//  Created by Duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "DashboardScreen.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"
#import "StatusScreen.h"
#import "TransactionScreen.h"
#import "Status2Screen.h"
#import "ChatScreen.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>

@interface DashboardScreen ()<LGPlusButtonsViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;
}
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation DashboardScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
   

}
- (void)customInitialization
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"Dashboard";
    [CommonFunctions addButton:@"menu" InNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(showMenu)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showThirdStep) name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addLineOfCreditScreen) name:@"change3" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatBtnTapped) name:@"chat" object:nil];
    
    [self addLineOfCreditScreen];
    [self addStashFinButtonView];
    isStashExpand = NO;
}
#pragma mark LGPlusButtonsView
- (void)addStashFinButtonView
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

-(void)addLineOfCreditScreen
{
    UIView *viewToRemove = [self.view viewWithTag:18];
    if (viewToRemove)
    {
        [viewToRemove removeFromSuperview];
    }
    
    _lineCreditVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"LineCreditVC"];
    [_lineCreditVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _lineCreditVC.view.tag = 17;


    _scrollView.contentSize = CGSizeMake(_lineCreditVC.view.frame.size.width, 750);
    _scrollView.autoresizingMask = YES;
    [_scrollView addSubview:_lineCreditVC.view];
//    _status2ScreenVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"Status2Screen"];
//    [_status2ScreenVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
//    _status2ScreenVC.view.tag = 17;
    
//    [_viewContainer addSubview:_lineCreditVC.view];
}

-(void)showThirdStep
{
    
//    [_status2ScreenVC willMoveToParentViewController:nil];
    //[_status2ScreenVC.view removeFromSuperview];
//    [_status2ScreenVC removeFromParentViewController];
    UIView *viewToRemove = [self.view viewWithTag:17];
    [viewToRemove removeFromSuperview];
    
    _statusScreenVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusScreen"];
//    [self addChildViewController:_statusScreenVC];
    [_statusScreenVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _statusScreenVC.view.tag = 18;

    [self.view addSubview:_statusScreenVC.view];
//    [_statusScreenVC didMoveToParentViewController:self];
//    [_statusScreenVC.view bringSubviewToFront:self.view];

}

-(void)chatBtnTapped
{
        ChatScreen *chvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatScreen"];
        [self.navigationController pushViewController:chvc animated:YES];
}
- (IBAction)menuAction:(id)sender
{
    [self showMenu];
}
@end
