//
//  LeftScreen.m
//  Stasheasy
//
//  Created by Duke on 04/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LeftScreen.h"
#import "LeftViewCell.h"
#import "REFrostedViewController.h"
#import "EmiCalculatorScreen.h"
#import "AppDelegate.h"
#import "CommonFunctions.h"
#import "ProfileScreen.h"
#import "LoanDetailsScreen.h"
#import "TransactionDetailsViewController.h"
#import "LineCreditVC.h"
#import "LandingVC.h"
#import "ChangePinVC.h"
#import "LostStolenVC.h"
#import "ChatScreen.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "StatusVC.h"
#import "RequestCardVC.h"

@interface LeftScreen ()<UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    NSArray *leftImages;
    NSArray *leftLabels;
}

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblSupportEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblUserEmail;

@end

@implementation LeftScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [AppDelegate sharedDelegate];
    
    self.navigationController.navigationBarHidden = NO;
    
    if ( [appDelegate.dictCustomer [@"landing_page"] isEqualToString:@"profile"] && [appDelegate.dictCustomer [@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] )
    {
        if ( appDelegate.isCardFound == YES )
        {
            leftImages = [NSArray arrayWithObjects:@"left_dashboard",@"left_card_overview",@"left_transaction",@"left_change_pin",@"left_block_card",@"calculator",@"left_profile",@"logout", nil];
            leftLabels = [NSArray arrayWithObjects:@"Dashboard",@"Card Overview",@"My Transactions",@"Change Pin",@"Block Card",@"EMI Calculation",@"Profile",@"Logout", nil];
        }
        else
        {
            leftImages = [NSArray arrayWithObjects:@"left_dashboard",@"left_getCard",@"calculator",@"left_profile",@"logout", nil];
            leftLabels = [NSArray arrayWithObjects:@"Dashboard",@"Get StashFin Card",@"EMI Calculation",@"Profile",@"Logout", nil];
        }
    }
    else
    {
        leftImages = [NSArray arrayWithObjects:@"left_dashboard",@"left_getCard",@"left_profile",@"logout", nil];
        leftLabels = [NSArray arrayWithObjects:@"Dashboard",@"Get StashFin Card",@"Profile",@"Logout", nil];

    }
    
        _lblUserEmail.text  = appDelegate.dictCustomer[@"email"];
    
    [_profileImageView setImageWithURL:[Utilities getFormattedImageURLFromString:[NSString stringWithFormat:@"%@",appDelegate.dictCustomer[@"profile_pic"]]] placeholderImage:[UIImage imageNamed:@"profile"]];
}


-(void)viewWillAppear:(BOOL)animated
{
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width/2;
    _profileImageView.layer.masksToBounds =YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return leftLabels.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"leftCell";
 
        LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"LeftViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftimg.image = [UIImage imageNamed:[leftImages objectAtIndex:indexPath.row]];
        cell.leftLabel.text = [leftLabels objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( [appDelegate.dictCustomer [@"landing_page"] isEqualToString:@"profile"] && [appDelegate.dictCustomer [@"latest_loan_details"][@"current_status"] isEqualToString:@"disbursed"] )
    {
        if ( appDelegate.isCardFound == YES )
        {
            if(indexPath.row == 0)
            {
                LineCreditVC *lineCreditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LineCreditVC"];
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[lineCreditVC];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
                
            }
            else if(indexPath.row == 1)
            {
                TransactionDetailsViewController *tdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionDetailsViewController"];
                tdvc.isOverview = 0;
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[tdvc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
                
            }
            else if (indexPath.row == 2)
            {
                TransactionDetailsViewController *tdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionDetailsViewController"];
                tdvc.isOverview = 1;
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[tdvc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            else if(indexPath.row == 3)
            {
                ChangePinVC *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePinVC"];
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[pvc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            
            else if(indexPath.row == 4)
            {
                LostStolenVC *lsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LostStolenVC"];
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[lsvc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
                
            }
            else if(indexPath.row == 5)
            {
                EmiCalculatorScreen *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"EmiCalculatorScreen"];
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[evc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            else if(indexPath.row == 6)
            {
                ProfileScreen *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[pvc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            else if(indexPath.row == 7)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"StathFin" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [ alert show];
                [self.frostedViewController hideMenuViewController];
            }
        }
        
        else
        {
            if(indexPath.row == 0)
            {
                LineCreditVC *lineCreditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LineCreditVC"];
                appDelegate.currentVC = lineCreditVC;
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[lineCreditVC];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
                
            }
            else if(indexPath.row == 1)
            {
                if ( [[Utilities getUserDefaultValueFromKey:@"cardRequested"] intValue] == 0)
                {
                    RequestCardVC *requestCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestCardVC"];
                    UINavigationController *nav =[[UINavigationController alloc]init];
                    nav.viewControllers = @[appDelegate.currentVC, requestCardVC];
                    [self.frostedViewController setContentViewController:nav];
                    [self.frostedViewController hideMenuViewController];
                }
                else
                {
                    [self.frostedViewController hideMenuViewController];
                    [ Utilities showAlertWithMessage:@"You Have Already requested for a Card" ];
                }
            }
            else if (indexPath.row == 2)
            {
                EmiCalculatorScreen *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"EmiCalculatorScreen"];
                appDelegate.currentVC = evc;
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[evc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            
            else if(indexPath.row == 3)
            {
                ProfileScreen *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
                appDelegate.currentVC = pvc;
                UINavigationController *nav = [[UINavigationController alloc]init];
                nav.viewControllers = @[pvc];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            else if(indexPath.row == 4)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"StathFin" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [ alert show];
                [self.frostedViewController hideMenuViewController];
            }
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            StatusVC *statusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusVC"];
            UINavigationController *nav = [[UINavigationController alloc]init];
            nav.viewControllers = @[statusVC];
            [self.frostedViewController setContentViewController:nav];
            [self.frostedViewController hideMenuViewController];
            
        }
        else if(indexPath.row == 1)
        {
            if ( [[Utilities getUserDefaultValueFromKey:@"cardRequested"] intValue] == 0)
            {
                RequestCardVC *requestCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestCardVC"];
                UINavigationController *nav =[[UINavigationController alloc]init];
                nav.viewControllers = @[appDelegate.currentVC, requestCardVC];
                [self.frostedViewController setContentViewController:nav];
                [self.frostedViewController hideMenuViewController];
            }
            else
            {
                [self.frostedViewController hideMenuViewController];
                [ Utilities showAlertWithMessage:@"You Have Already requested for a Card" ];
            }
        }
        
        else if(indexPath.row == 2)
        {
            ProfileScreen *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
            appDelegate.currentVC = pvc;
            UINavigationController *nav = [[UINavigationController alloc]init];
            nav.viewControllers = @[pvc];
            [self.frostedViewController setContentViewController:nav];
            [self.frostedViewController hideMenuViewController];
        }
        else if(indexPath.row == 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"StathFin" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [ alert show];
            [self.frostedViewController hideMenuViewController];
        }
    }
    

    
}

#pragma mark Button Action
- (IBAction)chatAction:(id)sender
{
    ChatScreen *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatScreen"];
    UINavigationController *nav = [[UINavigationController alloc]init];
    nav.viewControllers = @[pvc];
    [self.frostedViewController setContentViewController:nav];
    [self.frostedViewController hideMenuViewController];
}
- (IBAction)numberAction:(id)sender
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:_lblPhoneNumber.text];
    [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:phoneNumber]];
}
- (IBAction)emailAction:(id)sender
{
    if ( [ MFMailComposeViewController canSendMail ])
    {
        MFMailComposeViewController *mfMailVC = [[ MFMailComposeViewController alloc ] initWithNibName:nil bundle:nil];
        [ mfMailVC setMailComposeDelegate:self ];
        [ mfMailVC setToRecipients:@[ _lblSupportEmail.text]];
        [ mfMailVC setSubject:@"Support Stashfin" ];
        [ self presentViewController:mfMailVC animated:YES completion:nil ];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [ self dismissViewControllerAnimated:YES completion:nil ];
}

#pragma mark Server Call
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

#pragma marl UIAlertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1)
    {
        [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];
        [Utilities setUserDefaultWithObject:@"0" andKey:@"isLoanDisbursed"];
        [Utilities setUserDefaultWithObject:nil andKey:@"auth_token"];
        [Utilities setUserDefaultWithObject:@"1" andKey:@"signupStep"];

        AppDelegate *appdelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        LandingVC *vc = (LandingVC *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingVC"] ;
        UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
        navigationController.viewControllers = @[vc];
        navigationController.navigationBar.hidden = YES;
        appdelegate.window.rootViewController = navigationController;

    }
}
@end
