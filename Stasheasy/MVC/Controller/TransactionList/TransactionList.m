//
//  TransactionList.m
//  Stasheasy
//
//  Created by Tushar  on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "TransactionList.h"
#import "TransactionListCell.h"
#import "TransactionCell.h"
#import "AppDelegate.h"

@interface TransactionList ()
{
    AppDelegate *appDelegate;
    NSMutableArray *marrTransaction;
    NSArray *headerArr;
    NSArray *valueArr;
}

@property (weak, nonatomic) IBOutlet UITableView *transactionListTableView;

@end

@implementation TransactionList

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headerArr = [[NSArray alloc]initWithObjects:@"Date",@"Time",@"Amount",@"Merchant",@"Spend Category", nil];
    valueArr = [[NSArray alloc]initWithObjects:@"12-04-17",@"02:16 PM",@"2000",@"Indian Oil Corporation",@"Fuel", nil];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBarHidden = YES;
    appDelegate = [AppDelegate sharedDelegate];
    
    marrTransaction = [[NSMutableArray alloc] init];
    marrTransaction =  appDelegate.dictOverview[@"recent_transactions"];
    self.transactionListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrTransaction count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return (44.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TransactionCell";
    
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.transactionListTableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dictRecent = [marrTransaction objectAtIndex:indexPath.row];
    
    cell.lblPartyName.text = dictRecent[@"otherPartyName"];
    cell.lblAmount.text = [NSString stringWithFormat:@"₹%@",dictRecent[@"amount"]];
    cell.lblDate.text = dictRecent[@"date"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
