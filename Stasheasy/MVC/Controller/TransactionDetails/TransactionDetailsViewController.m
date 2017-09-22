//
//  TransactionDetailsViewController.m
//  Stasheasy
//
//  Created by tushar on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "TransactionDetailsViewController.h"
#import "TransactionScreen.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"
#import "TransactionList.h"
#import "AnalyzeScreen.h"
#import "ServerCall.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>
#import "AppDelegate.h"

@interface TransactionDetailsViewController ()<LGPlusButtonsViewDelegate>
{
    AppDelegate *appDelegate;
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;

    NSDictionary *dictResponse;
    int tab;
    UIViewController *currentController;
}

@property (weak, nonatomic) IBOutlet UILabel *perLbl;
@property (weak, nonatomic) IBOutlet UILabel *proLbl;
@property (weak, nonatomic) IBOutlet UILabel *docLbl;

@property (weak, nonatomic) IBOutlet UIButton *btnTransaction;
@property (weak, nonatomic) IBOutlet UIButton *btnOverview;
@property (weak, nonatomic) IBOutlet UIButton *btnAnalyze;

@property (weak, nonatomic) IBOutlet UIView *viewOuter;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TransactionDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBarHidden = YES;

    appDelegate = [AppDelegate sharedDelegate];
    _viewOuter.hidden = NO;
    
    if ([appDelegate.dictOverview count] == 0)
    {
        [self serverCallForCardOverview];
    }
    else
    {
        if (_isOverview == 0 )
            [self overviewAction:_btnOverview];
            
        else
            [self transactionAction:_btnTransaction];
    }
//    [self addStashfinButtonView];
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


#pragma mark Button Action

- (IBAction)overviewAction:(id)sender
{
    tab = 0;
    self.containerView.hidden = NO;

    self.perLbl.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:00.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.btnOverview.titleLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:00.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.btnTransaction.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.btnAnalyze.titleLabel.textColor = [UIColor darkGrayColor];
    
    TransactionScreen *stVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionScreen"];
    [self changeTransitionWithViewController:stVC];

}

- (IBAction)transactionAction:(id)sender
{
    tab = 1;
    self.perLbl.backgroundColor = [UIColor clearColor];
    self.btnOverview.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.btnAnalyze.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.proLbl.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:00.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [self.btnTransaction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnTransaction setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:00.0f/255.0f blue:0.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

    // show transaction list
    TransactionList *tlist = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionList"];
    [self changeTransitionWithViewController:tlist];
    
}

- (IBAction)analyzeAction:(id)sender
{
    tab = 2;

//    self.mainView.hidden =YES;

    self.perLbl.backgroundColor = [UIColor clearColor];
    self.btnOverview.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.btnTransaction.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:00.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [self.btnAnalyze setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAnalyze setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:00.0f/255.0f blue:0.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    AnalyzeScreen *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalyzeScreen"];
    [self changeTransitionWithViewController:avc];

}


#pragma mark - Instance Methods

-(void)addTrasactionListScreen
{
    TransactionList *tlistVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionList"];
    [tlistVC.view setFrame: _containerView.bounds] ;
    [self.containerView addSubview:tlistVC.view];
    [self addChildViewController:tlistVC];
    [tlistVC didMoveToParentViewController:self];
    currentController  = tlistVC;
}
-(void)addTransactionOverviewScreen
{
    TransactionScreen *stVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionScreen"];
    [stVC.view setFrame: _containerView.bounds] ;
    [self.containerView addSubview:stVC.view];
    [self addChildViewController:stVC];
    [stVC didMoveToParentViewController:self];
    currentController  = stVC;
}
-(void)changeTransitionWithViewController:(UIViewController *)NewVC
{
    [self removeOldViewController];
    [self addChildViewController:NewVC];
    [NewVC.view setFrame:self.containerView.bounds] ;
    [self.containerView addSubview:NewVC.view];
    [NewVC didMoveToParentViewController:self];
    currentController  = NewVC;
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

-(void)removeOldViewController
{
    if (currentController)
    {
        [currentController willMoveToParentViewController:nil];
        [currentController.view removeFromSuperview];
        [currentController removeFromParentViewController];
    }
}

- (IBAction)menuAction:(id)sender
{
    [self showMenu];
}

- (void)populateCardDetail:(NSDictionary *)dictCard
{
    
}
#pragma mark Server Call
- (void)serverCallForCardOverview
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"cardOverview" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"%@", response);
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 appDelegate.dictOverview = [NSDictionary dictionaryWithDictionary:response];
               
                 if (_isOverview == 0 )
                     [self overviewAction:_btnOverview];
                 
                 else
                     [self transactionAction:_btnTransaction];

             }
         }
         else
         {
         }
     }];
}
@end
