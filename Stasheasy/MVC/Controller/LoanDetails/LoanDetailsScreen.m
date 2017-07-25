//
//  LoanDetailsScreen.m
//  Stasheasy
//
//  Created by tushar on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LoanDetailsScreen.h"
#import "LoanDetailCell.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"

@interface LoanDetailsScreen ()
@property (weak, nonatomic) IBOutlet UITableView *loandetailTableView;

@end

@implementation LoanDetailsScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Loan Details";
    [CommonFunctions addButton:@"menu" InNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(showMenu)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (30.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    UILabel *sectionLbl  = [headerView viewWithTag:20];
    if (section ==0) {
        sectionLbl.text = @"On-going Loans";

    } else {
        sectionLbl.text = @"Closed Loans";
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LoanDetailCell";
    
    LoanDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.loandetailTableView registerNib:[UINib nibWithNibName:@"LoanDetailCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row % 2 == 0) {
        cell.contentview.backgroundColor = [UIColor clearColor];
    }
    else {
        cell.contentview.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    }
    if (indexPath.section == 1) {
        cell.statusLbl.text =@"Completed";
        cell.statusLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:200.0f/255.0f blue:83.0f/255.0f alpha:1.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


@end
