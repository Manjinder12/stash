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
    NSMutableArray *marrLoans;
    NSDictionary *dictResponse;
    BOOL isStashExpand;

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
    
    _viewEMIPayable.layer.shadowOffset = CGSizeMake(1, 1);
    _viewEMIPayable.layer.shadowRadius = 4;
    _viewEMIPayable.layer.shadowOpacity = 0.5;
    _viewEMIPayable.layer.cornerRadius = 8.0f;
    _viewEMIPayable.layer.masksToBounds = YES;
    _viewEMIPayable.layer.shadowColor = [UIColor lightGrayColor].CGColor;

    _tblLoans.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _viewOuter.hidden = NO;
//    [self addStashfinButtonView];
//    isStashExpand = NO;
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrLoans count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tblLoans.separatorColor = [UIColor clearColor];
    
    if ( indexPath.row < [marrLoans count] )
    {
        LoanCell *loanCell = [tableView dequeueReusableCellWithIdentifier:@"LoanCell"];
        
        NSDictionary *dict = [marrLoans objectAtIndex:indexPath.row];
        
        [[dict valueForKey:@"approved_rate"] intValue];
        [dict valueForKey:@""];
        
        NSString *strLoanAmount = [NSString stringWithFormat:@"Loan%ld:₹%d",indexPath.row+1 ,[[dict valueForKey:@"approved_amount"] intValue]];
        
        NSString *strRate = [NSString stringWithFormat:@" @%d%@",[[dict valueForKey:@"approved_rate"] intValue],@"%PM"];
        
        NSString *strTenure = [NSString stringWithFormat:@" For %d Months",[[dict valueForKey:@"approved_tenure"] intValue]];
        
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",strLoanAmount,strRate,strTenure]];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [strLoanAmount length])];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange([strLoanAmount length], [strRate length])];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange([strRate length], [strTenure length])];
        
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
        
        cell.lblFirst.text = [NSString stringWithFormat:@"EMI ₹%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"first"] valueForKey:@"amount"]];
        cell.lblFirstDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"first"] valueForKey:@"date"]]];
        
        cell.lblSecond.text = [NSString stringWithFormat:@"EMI ₹%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"second"] valueForKey:@"amount"]];
        cell.lblSecondDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"second"] valueForKey:@"date"]]];
        
        cell.lblThird.text = [NSString stringWithFormat:@"EMI ₹%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"third"] valueForKey:@"amount"]];
        cell.lblThirdDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"third"] valueForKey:@"date"]]];
        
        cell.lblFourth.text = [NSString stringWithFormat:@"EMI ₹%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"fourth"] valueForKey:@"amount"]];
        cell.lblFourthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"fourth"] valueForKey:@"date"]]];
        
        cell.lblFifth.text = [NSString stringWithFormat:@"EMI ₹%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"fifth"] valueForKey:@"amount"]];
        cell.lblFifthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"fifth"] valueForKey:@"date"]]];
        
        cell.lblSixth.text = [NSString stringWithFormat:@"EMI ₹%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"sixth"] valueForKey:@"amount"]];
        cell.lblSixthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[dictResponse valueForKey:@"total"] valueForKey:@"sixth"] valueForKey:@"date"]]];

        return cell;
    }
    
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
            dictResponse = response;
            [Utilities showAlertWithMessage:response];
        }
        
        
    }];
}
- (void)populateEMIDetails:(id)response
{
    marrLoans = [response valueForKey:@"loans"];
    
    _lblFirst.text = [NSString stringWithFormat:@"EMI ₹%@",[[[response valueForKey:@"total"] valueForKey:@"first"] valueForKey:@"amount"]];
    _lblFirstDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"total"] valueForKey:@"first"] valueForKey:@"date"]]];
    
    _lblSecond.text = [NSString stringWithFormat:@"EMI ₹%@",[[[response valueForKey:@"total"] valueForKey:@"second"] valueForKey:@"amount"]];
    _lblSecondDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"total"] valueForKey:@"second"] valueForKey:@"date"]]];
    
    _lblThird.text = [NSString stringWithFormat:@"EMI ₹%@",[[[response valueForKey:@"total"] valueForKey:@"third"] valueForKey:@"amount"]];
    _lblThirdDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"total"] valueForKey:@"third"] valueForKey:@"date"]]];
    
    _lblFourth.text = [NSString stringWithFormat:@"EMI ₹%@",[[[response valueForKey:@"total"] valueForKey:@"fourth"] valueForKey:@"amount"]];
    _lblFourthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"total"] valueForKey:@"fourth"] valueForKey:@"date"]]];
    
    _lblFifth.text = [NSString stringWithFormat:@"EMI ₹%@",[[[response valueForKey:@"total"] valueForKey:@"fifth"] valueForKey:@"amount"]];
    _lblFifthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"total"] valueForKey:@"fifth"] valueForKey:@"date"]]];
    
    _lblSixth.text = [NSString stringWithFormat:@"EMI ₹%@",[[[response valueForKey:@"total"] valueForKey:@"sixth"] valueForKey:@"amount"]];
    _lblSixthDate.text = [Utilities formateDateToDMY:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"total"] valueForKey:@"sixth"] valueForKey:@"date"]]];
    
    [_tblLoans reloadData];

    [Utilities setBorderAndColor:_viewEMIPayable];
    [Utilities setCornerRadius:_viewEMIPayable];
   
}
#pragma mark LGPlusButtonsView
- (void)addStashfinButtonView
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
@end
