//
//  StatusVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 10/08/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "StatusVC.h"
#import "Utilities.h"
#import "REFrostedViewController.h"

@interface StatusVC ()
{
    AppDelegate *appDelegate;
    UIImage *firstActive, *secondActive, *thirdActive, *fourthActive, *firstDective, *secondDeactive, *thirdDeactive, *fourthDeactive , *greenImage;
    NSDictionary *dictLoan;
    NSString *appStatus;
}
@property (weak, nonatomic) IBOutlet UIButton *btnFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnThird;
@property (weak, nonatomic) IBOutlet UIButton *btnFourth;

@property (weak, nonatomic) IBOutlet UIView *viewFirst;
@property (weak, nonatomic) IBOutlet UIView *viewSecond;
@property (weak, nonatomic) IBOutlet UIView *viewThird;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UILabel *lblStart;
@property (weak, nonatomic) IBOutlet UILabel *lblApproved;
@property (weak, nonatomic) IBOutlet UILabel *lblDoc;
@property (weak, nonatomic) IBOutlet UILabel *lblDone;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end

@implementation StatusVC
@synthesize dictLoandetail;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
   
    appDelegate = [ AppDelegate sharedDelegate ];
    appDelegate.currentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusVC"];;

    
    [self setAllImages];
    
    dictLoan = appDelegate.dictCustomer[@"latest_loan_details"];
    appStatus = @"start";
    
    //appDelegate.dictCustomer[@"latest_loan_details"][@"current_status"];
    
    _lblDate.text = [NSString stringWithFormat:@"%@",appDelegate.dictCustomer[@"latest_loan_details"][@"loan_creation_date"]];
    

    if ( [appStatus  isEqual: @"start"] )
    {
        [self viewForAppStatusStart];
    }
    else if ( [appStatus  isEqual: @"approved"] )
    {
        [self viewForAppStatusApproved];
    }
    else if ( [appStatus  isEqual: @"docpick"] )
    {
        [self viewForAppStatusDocument];
    }
    else if ( [appStatus  isEqual: @"dockpickdone"] )
    {
        [self viewForAppStatusDone];
    }
    else
    {
//        _viewContainer.hidden = NO;
    }
}

- (void)setAllImages
{
    firstActive = [UIImage imageNamed:@"one"];
    secondActive = [UIImage imageNamed:@"two"];
    thirdActive = [UIImage imageNamed:@"three"];
    fourthActive = [UIImage imageNamed:@"four"];
    
    secondDeactive = [UIImage imageNamed:@"twoun"];
    thirdDeactive = [UIImage imageNamed:@"threeun"];
    fourthDeactive = [UIImage imageNamed:@"fourun"];
    
    greenImage = [UIImage imageNamed:@"greenBtn"];
}
- (void)viewForAppStatusStart
{
    [ _btnFirst setBackgroundImage:firstActive forState:UIControlStateNormal ];
    [ _btnSecond setBackgroundImage:secondDeactive forState:UIControlStateNormal ];
    [ _btnThird setBackgroundImage:thirdDeactive forState:UIControlStateNormal ];
    [ _btnFourth setBackgroundImage:fourthDeactive forState:UIControlStateNormal ];
    
    [ _viewFirst setBackgroundColor:[Utilities getColorFromHexString:@"#CFCFCF"] ];
    [ _viewSecond setBackgroundColor:[Utilities getColorFromHexString:@"#CFCFCF"] ];
    [ _viewThird setBackgroundColor:[Utilities getColorFromHexString:@"#CFCFCF"] ];

    _lblStart.textColor = [UIColor yellowColor];
    _lblApproved.textColor = [UIColor lightGrayColor];
    _lblDoc.textColor = [UIColor lightGrayColor];
    _lblDone.textColor = [UIColor lightGrayColor];
    _lblStatus.text = @"Application Started";
    
}
- (void)viewForAppStatusApproved
{
    [ _btnFirst setBackgroundImage:greenImage forState:UIControlStateNormal ];
    [ _btnSecond setBackgroundImage:secondActive forState:UIControlStateNormal ];
    [ _btnThird setBackgroundImage:thirdDeactive forState:UIControlStateNormal ];
    [ _btnFourth setBackgroundImage:fourthDeactive forState:UIControlStateNormal ];
    
    [ _viewFirst setBackgroundColor:[Utilities getColorFromHexString:@"#5DCF5C"] ];
    [ _viewSecond setBackgroundColor:[Utilities getColorFromHexString:@"#CFCFCF"] ];
    [ _viewThird setBackgroundColor:[Utilities getColorFromHexString:@"#CFCFCF"] ];
    
    _lblStart.textColor = [Utilities getColorFromHexString:@"#5DCF5C"];
    _lblApproved.textColor = [UIColor yellowColor];
    _lblDoc.textColor = [UIColor lightGrayColor];
    _lblDone.textColor = [UIColor lightGrayColor];
    _lblStatus.text = @"Approved";

}
- (void)viewForAppStatusDocument
{
    [ _btnFirst setBackgroundImage:greenImage forState:UIControlStateNormal ];
    [ _btnSecond setBackgroundImage:greenImage forState:UIControlStateNormal ];
    [ _btnThird setBackgroundImage:thirdActive forState:UIControlStateNormal ];
    [ _btnFourth setBackgroundImage:fourthDeactive forState:UIControlStateNormal ];
    
    [ _viewFirst setBackgroundColor:[Utilities getColorFromHexString:@"#5DCF5C"] ];
    [ _viewSecond setBackgroundColor:[Utilities getColorFromHexString:@"#5DCF5C"] ];
    [ _viewThird setBackgroundColor:[Utilities getColorFromHexString:@"#CFCFCF"] ];
    
    _lblStart.textColor = [Utilities getColorFromHexString:@"#5DCF5C"];
    _lblApproved.textColor = [Utilities getColorFromHexString:@"#5DCF5C"];
    _lblDoc.textColor = [UIColor yellowColor];
    _lblDone.textColor = [UIColor lightGrayColor];
    _lblStatus.text = @"Document Pickup";
}
- (void)viewForAppStatusDone
{
    [ _btnFirst setBackgroundImage:greenImage forState:UIControlStateNormal ];
    [ _btnSecond setBackgroundImage:greenImage forState:UIControlStateNormal ];
    [ _btnThird setBackgroundImage:greenImage forState:UIControlStateNormal ];
    [ _btnFourth setBackgroundImage:fourthActive forState:UIControlStateNormal ];
    
    [ _viewFirst setBackgroundColor:[Utilities getColorFromHexString:@"#5DCF5C"] ];
    [ _viewSecond setBackgroundColor:[Utilities getColorFromHexString:@"#5DCF5C"] ];
    [ _viewThird setBackgroundColor:[Utilities getColorFromHexString:@"#5DCF5C"] ];
    
    _lblStart.textColor = [Utilities getColorFromHexString:@"#5DCF5C"];
    _lblApproved.textColor = [Utilities getColorFromHexString:@"#5DCF5C"];
    _lblDoc.textColor = [Utilities getColorFromHexString:@"#5DCF5C"];
    _lblDone.textColor = [UIColor yellowColor];
    _lblStatus.text = @"Pending for Disbursal";

}
- (IBAction)meneuAction:(id)sender
{
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
