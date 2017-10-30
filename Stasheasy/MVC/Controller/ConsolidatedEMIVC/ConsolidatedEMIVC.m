//
//  ConsolidatedEMIVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 27/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ConsolidatedEMIVC.h"
#import "ServerCall.h"
#import "LoanCell.h"
#import "Utilities.h"
#import "LoanPayableCell.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>

@interface ConsolidatedEMIVC ()<UITableViewDelegate,UITableViewDataSource,LGPlusButtonsViewDelegate,UIAlertViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    NSMutableArray *marrLoans, *marrTotalEMI;
    NSDictionary *dictResponse;
    BOOL isStashExpand;
    int totalCellCount;

}

@property (weak, nonatomic) IBOutlet UILabel *lblFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstDate;

@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondDate;

@property (weak, nonatomic) IBOutlet UILabel *lblThird;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdDate;

@property (weak, nonatomic) IBOutlet UILabel *lblFourth;
@property (weak, nonatomic) IBOutlet UILabel *lblFourthDate;

@property (weak, nonatomic) IBOutlet UILabel *lblFifth;
@property (weak, nonatomic) IBOutlet UILabel *lblFifthDate;

@property (weak, nonatomic) IBOutlet UILabel *lblSixth;
@property (weak, nonatomic) IBOutlet UILabel *lblSixthDate;

@property (weak, nonatomic) IBOutlet UITableView *tblLoans;
@property (weak, nonatomic) IBOutlet UIView *viewEMIPayable;
@property (weak, nonatomic) IBOutlet UIView *viewOuter;
@property (weak, nonatomic) IBOutlet UIView *viewInner;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end

@implementation ConsolidatedEMIVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    marrLoans = [[NSMutableArray alloc] init];
    marrTotalEMI = [[NSMutableArray alloc] init];
    dictResponse = [ NSDictionary dictionary ];
    
    _viewEMIPayable.layer.shadowOffset = CGSizeMake(1, 1);
    _viewEMIPayable.layer.shadowRadius = 4;
    _viewEMIPayable.layer.shadowOpacity = 0.5;
    _viewEMIPayable.layer.cornerRadius = 8.0f;
    _viewEMIPayable.layer.masksToBounds = YES;
    _viewEMIPayable.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    totalCellCount = 0;
    
    _tblLoans.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tblLoans.estimatedRowHeight = 100;
    _tblLoans.rowHeight = UITableViewAutomaticDimension;
    
    _viewOuter.hidden = NO;
    _viewEMIPayable.hidden = YES;
    
    
    
    float shadowSize = 10.0f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(_viewInner.frame.origin.x - shadowSize /2,_viewInner.frame.origin.y - shadowSize / 2,_viewInner.frame.size.width + shadowSize, _viewInner.frame.size.height + shadowSize)];
    _viewInner.layer.masksToBounds = NO;
    _viewInner.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewInner.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _viewInner.layer.shadowOpacity = 0.8f;
    _viewInner.layer.shadowPath = shadowPath.CGPath;
    
    
    [self serverCallForConsolidatedEMIDetails];
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

#pragma mark Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return [ marrLoans count ];
    }
    else
    {
        return totalCellCount;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tblLoans.separatorColor = [UIColor clearColor];
    
    if ( indexPath.section == 0 )
    {
        LoanCell *loanCell = [tableView dequeueReusableCellWithIdentifier:@"LoanCell"];
        
        NSDictionary *dict = [marrLoans objectAtIndex:indexPath.row];
        
        [[dict valueForKey:@"approved_rate"] intValue];
        
        NSString *strLoanAmount = [NSString stringWithFormat:@"Loan%ld:₹ %.01f ",indexPath.row+1 ,[[dict valueForKey:@"approved_amount"] floatValue]];
        
        NSString *strRate = [NSString stringWithFormat:@"@%d%@ ",[[dict valueForKey:@"approved_rate"] intValue],@"%PM"];
        
        NSString *strTenure = [NSString stringWithFormat:@"For %d Months",[[dict valueForKey:@"approved_tenure"] intValue]];
        
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",strLoanAmount,strRate,strTenure]];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [strLoanAmount length])];

        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([strLoanAmount length], [strRate length])];

        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(( [strLoanAmount length] + [strRate length]), [strTenure length])];
        
        loanCell.lblLoanDetail.attributedText = attString;
        
        loanCell.lblStartDate.text = [NSString stringWithFormat:@"Start Date : %@",[Utilities formateDateToDMY:[dict valueForKey:@"emi_start_date"]]];
        
        loanCell.lblEndDate.text = [NSString stringWithFormat:@"End date : %@",[Utilities formateDateToDMY:[dict valueForKey:@"emi_end_date"]]];
        
        NSString *strEMI = [[[dict valueForKey:@"emis"] firstObject] valueForKey:@"amount"];
        
        loanCell.lblEMI.text = [NSString stringWithFormat:@"EMI ₹%@",strEMI];
        
        [Utilities setBorderAndColor:loanCell.viewConatiner];
        [Utilities setCornerRadius:loanCell.viewConatiner];
        
        //    loanCell.viewConatiner.layer.borderColor = [ UIColor lightGrayColor ].CGColor;
        //    loanCell.viewConatiner.layer.borderWidth = 0.5;
        //    loanCell.viewConatiner.layer.cornerRadius = 8.0;
        //    loanCell.viewConatiner.layer.masksToBounds = NO;
        //    loanCell.viewConatiner.layer.shadowColor = [ UIColor lightGrayColor ].CGColor;
        //    loanCell.viewConatiner.layer.shadowRadius = 5.0;
        //    loanCell.viewConatiner.layer.shadowOffset = CGSizeMake(2, 2);
        //    loanCell.viewConatiner.layer.shadowOpacity = 1;
        //    loanCell.viewConatiner.layer.shadowRadius = 0.5;
        
        return loanCell;
    }
    else
    {
        LoanPayableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoanPayableCell"];
        
        cell.lblFirst.text = [NSString stringWithFormat:@"EMI ₹%d", [dictResponse[@"first"][@"amount"] intValue]];
        cell.lblFirstDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",dictResponse[@"first"][@"date"] ]];
        
        cell.lblSecond.text = [NSString stringWithFormat:@"EMI ₹%d", [dictResponse[@"second"][@"amount"] intValue]];
        cell.lblSecondDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",dictResponse[@"second"][@"date"] ]];
        
        cell.lblThird.text = [NSString stringWithFormat:@"EMI ₹%d", [dictResponse[@"third"][@"amount"] intValue]];
        cell.lblThirdDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",dictResponse[@"third"][@"date"] ]];
        
        cell.lblFourth.text = [NSString stringWithFormat:@"EMI ₹%d", [dictResponse[@"fourth"][@"amount"] intValue]];
        cell.lblFourthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",dictResponse[@"fourth"][@"date"] ]];
        
        cell.lblFifth.text = [NSString stringWithFormat:@"EMI ₹%d", [dictResponse[@"fifth"][@"amount"] intValue]];
        cell.lblFifthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",dictResponse[@"fifth"][@"date"] ]];
        
        cell.lblSixth.text = [NSString stringWithFormat:@"EMI ₹%d", [dictResponse[@"sixth"][@"amount"] intValue]];
        cell.lblSixthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",dictResponse[@"sixth"][@"date"] ]];

        [Utilities setCornerRadius:cell.viewContainer];
        [Utilities setBorderAndColor:cell.viewContainer];

        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ self populateEMIs:[marrLoans objectAtIndex:indexPath.row][@"emis"] atIndex:indexPath.row];
}

#pragma mark Server Call
- (void)serverCallForConsolidatedEMIDetails
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"consolidatedEmisDetails" forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"response === %@", response);

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle:@"StashFin" message:errorStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
                [ alert show ];
                
            }
            else
            {
                [self populateEMIDetails:response];
                _viewOuter.hidden = YES;
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
        
        
    }];
}
- (void)populateEMIDetails:(id)response
{
    marrLoans = response [@"loans"];
    dictResponse = response[@"total"];
    
    totalCellCount = 1 ;
    
    [_tblLoans reloadData];

    [Utilities setBorderAndColor:_viewEMIPayable];
    [Utilities setCornerRadius:_viewEMIPayable];
   
}
#pragma mark LGPlusButtonsView
- (void)addStashFinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:1 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    
    [stashfinButton setDescriptionsTexts:@[@""]];
    
    [stashfinButton setButtonsImages:@[[UIImage imageNamed:@"crossBtn"]]
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
        [plusButtonsView hideAnimated:YES completionHandler:^{
            
            isStashExpand = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [ self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Helper Method
- (void)showPopupView:(UIView *)popupView onViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [overlayView setTag:786];
    [popupView setHidden:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnOverlay:)];
    [overlayView addGestureRecognizer:tapGesture];
    
    [viewcontroller.view addSubview:overlayView];
    [viewcontroller.view bringSubviewToFront:popupView];
    popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        popupView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
     {
         
     }];
    
}
- (void)tappedOnOverlay:(UIGestureRecognizer *)gesture
{
    [ self hidePopupView:_viewEMIPayable fromViewController:self ];

}
- (void)hidePopupView:(UIView *)popupView fromViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [viewcontroller.view viewWithTag:786];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
     }
                     completion:^(BOOL finished)
     {
         [popupView setHidden:YES];
         
     }];
    
    
    [overlayView removeFromSuperview];
}
- (void)populateEMIs:(NSArray *)arr atIndex:(NSInteger)index
{
    NSDictionary *dict = [marrLoans objectAtIndex:index];
    
    NSString *strLoanAmount = [NSString stringWithFormat:@"Amount ₹ %.01f ",[[dict valueForKey:@"approved_amount"] floatValue]];
    
    NSString *strRate = [NSString stringWithFormat:@"@%d%@ ",[[dict valueForKey:@"approved_rate"] intValue],@"%PM"];
    
    NSString *strTenure = [NSString stringWithFormat:@"For %d Months",[[dict valueForKey:@"approved_tenure"] intValue]];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",strLoanAmount,strRate,strTenure]];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [strLoanAmount length])];
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([strLoanAmount length], [strRate length])];
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(( [strLoanAmount length] + [strRate length]), [strTenure length])];
    
    _lblDesc.attributedText = attString;
    
    _lblFirst.text = [NSString stringWithFormat:@"EMI ₹%@",[arr objectAtIndex:0][@"amount"] ];
    _lblFirstDate.text = [Utilities formateDateToDMYWithSubstring:[arr objectAtIndex:0][@"emi_date"]];
    
    _lblSecond.text = [NSString stringWithFormat:@"EMI ₹%@",[arr objectAtIndex:1][@"amount"] ];
    _lblSecondDate.text = [Utilities formateDateToDMYWithSubstring:[arr objectAtIndex:1][@"emi_date"]];
    
    _lblThird.text = [NSString stringWithFormat:@"EMI ₹%@",[arr objectAtIndex:2][@"amount"] ];
    _lblThirdDate.text = [Utilities formateDateToDMYWithSubstring:[arr objectAtIndex:2][@"emi_date"]];
    
    _lblFourth.text = [NSString stringWithFormat:@"EMI ₹%@",[arr objectAtIndex:3][@"amount"] ];
    _lblFourthDate.text = [Utilities formateDateToDMYWithSubstring:[arr objectAtIndex:3][@"emi_date"]];
    
    _lblFifth.text = [NSString stringWithFormat:@"EMI ₹%@",[arr objectAtIndex:4][@"amount"] ];
    _lblFifthDate.text = [Utilities formateDateToDMYWithSubstring:[arr objectAtIndex:4][@"emi_date"]];
    
    _lblSixth.text = [NSString stringWithFormat:@"EMI ₹%@",[arr objectAtIndex:5][@"amount"] ];
    _lblSixthDate.text = [Utilities formateDateToDMYWithSubstring:[arr objectAtIndex:5][@"emi_date"]];
    
    [ self showPopupView:_viewEMIPayable onViewController:self ];
}
@end
