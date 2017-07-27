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

@interface LeftScreen () {

    NSArray *leftImages;
    NSArray *leftLabels;
}
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation LeftScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    leftImages = [NSArray arrayWithObjects:@"profile",@"calculator",@"transaction",@"loandetail",@"applicationStatus",@"logout", nil];
    leftLabels = [NSArray arrayWithObjects:@"Profile",@"EMI Calculation",@"My Transactions",@"Loan Details",@"Application Status",@"Logout", nil];
}

-(void)viewWillAppear:(BOOL)animated {
    CGFloat width = _profileImageView.frame.size.width;
    _profileImageView.layer.cornerRadius = width/2;
    _profileImageView.layer.masksToBounds =YES;
   }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return leftLabels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"leftCell";
 
        LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"LeftViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftimg.image = [UIImage imageNamed:[leftImages objectAtIndex:indexPath.row]];
        cell.leftLabel.text = [leftLabels objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1)
    {
        EmiCalculatorScreen *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"EmiCalculatorScreen"];
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[evc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];
    }
    else if(indexPath.row == 5) {
        [CommonFunctions setUserDefault:@"islogin" value:@"0"];
        AppDelegate *appdelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"firstnav"];
        appdelegate.window.rootViewController =  root;
    }
    else if(indexPath.row == 0) {
        ProfileScreen *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileScreen"];
        [self.frostedViewController setContentViewController:pvc];
        [self.frostedViewController hideMenuViewController];

    }
    else if(indexPath.row == 3) {
        LoanDetailsScreen *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoanDetailsScreen"];
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[evc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];

        
    }
    else if(indexPath.row == 2)
    {
        TransactionDetailsViewController *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionDetailsViewController"];
        UINavigationController *nav = [[UINavigationController alloc]init];
        nav.viewControllers = @[evc];
        [self.frostedViewController setContentViewController:nav];
        [self.frostedViewController hideMenuViewController];
    }

}



@end
