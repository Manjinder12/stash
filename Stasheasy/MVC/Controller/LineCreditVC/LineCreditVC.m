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
#import "PNChart.h"
#import "RequestCardVC.h"

@interface LineCreditVC ()<LGPlusButtonsViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    AppDelegate *appDelegate;
    LGPlusButtonsView *stashfinButton;
    PNPieChart *pieChart;
    BOOL isStashExpand;
    NSString *strRemainLOC;
    NSArray *arrImages;
    int approvedLOC, usedLOC, remainingLOC, usedValue, remainValue ;
    double pieProgress;
}
@property (weak, nonatomic) IBOutlet UILabel *lblApprovedCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblUserCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCardNo;
@property (weak, nonatomic) IBOutlet UILabel *lblCardDate;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewUpper;
@property (weak, nonatomic) IBOutlet UIView *viewLower;
@property (weak, nonatomic) IBOutlet UIView *viewOuter;
@property (weak, nonatomic) IBOutlet UIView *viewCollection;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UIView *viewPieChart;

@property (weak, nonatomic) IBOutlet UIButton *btnRequestLoan;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;

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
    appDelegate.currentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LineCreditVC"];;
    

    if (appDelegate.isCardFound == YES )
    {
        _viewCard.hidden = NO;
        _viewCollection.hidden = YES;
    }
    else
    {
        _viewCard.hidden = YES;
        _viewCollection.hidden = NO;
    }
    
    arrImages = [[ NSArray alloc] initWithObjects:@"Card1",@"Card2",@"Card3",@"Card4",@"Card5", nil];

    [ Utilities setCornerRadius:_viewUpper ];
    [ Utilities setCornerRadius:_viewLower ];

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

#pragma mark Collectionview Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = collectionView.frame.size.height;
    CGFloat width  = collectionView.frame.size.width;
    return CGSizeMake( width * 1.0, height * 1.0);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *image  = [cell viewWithTag:100];
    image.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [[Utilities getUserDefaultValueFromKey:@"cardRequested"] intValue] == 0 )
    {
        RequestCardVC *requestCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestCardVC"];
        requestCardVC.isFromMenu = NO;
        [ self.navigationController pushViewController:requestCardVC animated:YES ];
    }
    else
    {
        [ Utilities showAlertWithMessage:@"You Have Already requested for a Card" ];
    }
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
                appDelegate.dictLOCDetail = [NSDictionary dictionaryWithDictionary:response];

                if ([[response valueForKey:@"card_found"] boolValue] == true)
                {
                    appDelegate.isCardFound = YES;
                    _btnRequestLoan.hidden = NO;
                    [self serverCallForCardOverview];
                }
                else
                {
                    appDelegate.isCardFound = NO;
                    _btnRequestLoan.hidden = YES;
                    [self populateLOCDetails:appDelegate.dictLOCDetail andCardDetail:nil];

                    [SVProgressHUD dismiss];
                }
                

            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
        
        [SVProgressHUD dismiss];
    
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
                appDelegate.dictCard = response[@"card_details"];
                
                [self populateLOCDetails:appDelegate.dictLOCDetail andCardDetail:appDelegate.dictCard];
                
//                [self addStashFinButtonView];
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
- (void)serverCallToRequestCard
{
    NSDictionary *param = [ NSDictionary dictionaryWithObjectsAndKeys:@"requestForCardExistingCustomer",@"mode",appDelegate.dictCustomer[@"phone"],@"phone_no", nil ];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
     {
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 
             }
             else
             {
                 [ Utilities showAlertWithMessage:response[@"msg"]];
             }
         }
         else
         {
             [ Utilities showAlertWithMessage:response ];
         }
         
     }];
}
- (void)populateLOCDetails:(NSDictionary *)dictLOC andCardDetail:(NSDictionary *)dictCard
{
    _lblApprovedCredit.text = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"loc_limit"] floatValue]];
    
    approvedLOC = [[dictLOC valueForKey:@"loc_limit"] intValue];
    
    _lblUserCredit.text = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"used_loc"] floatValue]];
    usedLOC = [[dictLOC valueForKey:@"used_loc"] intValue];

    
    strRemainLOC = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"remaining_loc"] floatValue]];

    
    remainingLOC = [[dictLOC valueForKey:@"remaining_loc"] intValue];
    _lblRemainCredit.text = strRemainLOC;
    
    if ( [[dictLOC valueForKey:@"balance_on_card"] intValue] == 0 )
    {
        _lblBalance.text = @"-";
    }
    else
    {
        _lblBalance.text = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"balance_on_card"] floatValue]];
    }
    
    if ( [[dictLOC valueForKey:@"total_balance"] intValue] == 0 )
    {
        _lblTotalBalance.text = @"-";
    }
    else
    {
        _lblTotalBalance.text = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"total_balance"] floatValue]];
    }
    
    if ( [[dictLOC valueForKey:@"next_emi_found"] intValue] == 0)
    {
        _lblEMIDate.text = @"-";
        _lblEMIAmount.text = @"-";
    }
    else
    {
        _lblEMIDate.text = [NSString stringWithFormat:@"%@",[dictLOC valueForKey:@"next_emi_date"]];
        _lblEMIAmount.text = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"next_emi_amount"] floatValue]];
    }
    
    _lblRequestAmount.text = [NSString stringWithFormat:@"₹ %.02f",[[dictLOC valueForKey:@"last_loc_request_amount"] floatValue]];
    appDelegate.loanRequestStatus = [NSString stringWithFormat:@"%@",[dictLOC valueForKey:@"last_loc_request_status"]].uppercaseString;
    _lblRequestStatus.text = appDelegate.loanRequestStatus;
    
    
    _lblRequestDate.text = [dictLOC valueForKey:@"last_loc_request_date"];
    
    _lblCardNo.text = [NSString stringWithFormat:@"%@",dictCard[@"card_no"]];
    _lblCardDate.text = [NSString stringWithFormat:@"%@/%@",dictCard[@"expiry_month"],dictCard[@"expiry_year"]];
    _lblName.text = [NSString stringWithFormat:@"%@",dictCard[@"name"]].uppercaseString;
    [self setUpPieChart];
}
- (void)setUpPieChart
{
    usedValue = (usedLOC * 100) / approvedLOC;
    remainValue = (remainingLOC * 100 ) / approvedLOC;
   
    NSArray *items = @[
                       [PNPieChartDataItem dataItemWithValue:usedValue color:[UIColor redColor] description:@""],
                       [PNPieChartDataItem dataItemWithValue:remainValue color:[UIColor greenColor] description:@""],
                       ];
    
    
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, 80, 80) items:items];
    [self.viewPieChart addSubview:pieChart];

    
    
//    _viewPieChart.startAngle = M_PI+M_PI_2;
//    [_viewPieChart setHoleRadiusPrecent:0.5];
//    
//    
//    
//    NSArray *chartValues = @[
//                         @{@"name":@"Apple", @"value":[NSNumber numberWithInt:usedValue], @"color":[UIColor redColor], @"strokeColor":[UIColor whiteColor]},
//                         @{@"name":@"Orange", @"value":[NSNumber numberWithInt:remainValue], @"color":[UIColor greenColor], @"strokeColor":[UIColor whiteColor]}
//                         ];
//
//    [_viewPieChart setChartValues:chartValues animation:YES duration:2 options:VBPieChartAnimationDefault];
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
    [ self serverCallForLOCDetails ];
}

@end
