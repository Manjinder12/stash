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

@interface LeftScreen ()
{
    NSArray *leftImages;
    NSArray *leftLabels;
}

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation LeftScreen

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    
    leftImages = [NSArray arrayWithObjects:@"profile",@"profile",@"calculator",@"transaction",@"applicationStatus",@"logout", nil];
    leftLabels = [NSArray arrayWithObjects:@"Dashboard",@"Profile",@"EMI Calculation",@"My Transactions",@"Card Overview",@"Logout", nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    CGFloat width = _profileImageView.frame.size.width;
    _profileImageView.layer.cornerRadius = width/2;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

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
        ProfileScreen *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[pvc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];
        
    }
    else if (indexPath.row == 2)
    {
        EmiCalculatorScreen *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"EmiCalculatorScreen"];
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[evc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];
    }
    else if(indexPath.row == 3)
    {
        TransactionDetailsViewController *tdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionDetailsViewController"];
        tdvc.isOverview = 0;
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[tdvc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];
    }
    
    else if(indexPath.row == 4)
    {
        TransactionDetailsViewController *tdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionDetailsViewController"];
        tdvc.isOverview = 1;
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[tdvc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];
    }
    
    else if(indexPath.row == 5)
    {
        [CommonFunctions setUserDefault:@"islogin" value:@"0"];
        AppDelegate *appdelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        LandingVC *vc = (LandingVC *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingVC"] ;
        UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
        navigationController.viewControllers = @[vc];
        navigationController.navigationBar.hidden = YES;
        appdelegate.window.rootViewController = navigationController;
    }
}
@end
