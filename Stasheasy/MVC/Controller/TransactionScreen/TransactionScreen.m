//
//  TransactionScreen.m
//  Stasheasy
//
//  Created by Duke on 07/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "TransactionScreen.h"
#import "TransactionCell.h"
#import "ServerCall.h"
#import "AppDelegate.h"
#import "VBPieChart.h"

@interface TransactionScreen ()<UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *appDelegate;
    NSMutableArray *marrRecentTransaction;
    
    ActionView *actionView;
    NSArray *parties;
    NSArray *valueArr;
}

@property (weak, nonatomic) IBOutlet UILabel *lblCardNo;
@property (weak, nonatomic) IBOutlet UILabel *lblCardDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLimit;
@property (weak, nonatomic) IBOutlet UILabel *lblUsed;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lblDisbursedAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblEMIDate;

@property (weak, nonatomic) IBOutlet UIView *viewBalance;
@property (weak, nonatomic) IBOutlet VBPieChart *viewPieChart;

@property (weak, nonatomic) IBOutlet UITableView *tblRecentTransaction;

@end

@implementation TransactionScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
    
}
- (void)customInitialization
{
    self.navigationController.navigationBarHidden = YES;
    
    appDelegate = [AppDelegate sharedDelegate];
    
    marrRecentTransaction = [[NSMutableArray alloc] init];
    
    _tblRecentTransaction.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [Utilities setCornerRadius:_viewBalance];
    
    [self setUpPieChart];
    [self populateCardAndBalanceDetail];
}
- (void)setUpPieChart
{
    int usedValue = (50 * 100) / 100;
    int remainValue = (40 * 100 ) / 100;
    
    _viewPieChart.startAngle = M_PI+M_PI_2;
    [_viewPieChart setHoleRadiusPrecent:0.5];
    
    
    
    NSArray *chartValues = @[
                             @{@"name":@"Apple", @"value":[NSNumber numberWithInt:usedValue], @"color":[UIColor redColor], @"strokeColor":[UIColor whiteColor]},
                             @{@"name":@"Orange", @"value":[NSNumber numberWithInt:remainValue], @"color":[UIColor greenColor], @"strokeColor":[UIColor whiteColor]}
                             ];
    
    [_viewPieChart setChartValues:chartValues animation:YES duration:2 options:VBPieChartAnimationDefault];
}
- (void)populateCardAndBalanceDetail
{
    _lblCardNo.text = [NSString stringWithFormat:@"%@",appDelegate.dictOverview[@"card_details"][@"card_no"]];
    _lblCardDate.text = [NSString stringWithFormat:@"%@/%@",appDelegate.dictOverview[@"card_details"][@"expiry_month"],appDelegate.dictOverview[@"card_details"][@"expiry_year"]];
   
    _lblLimit.text = [NSString stringWithFormat:@"₹%@",appDelegate.dictOverview[@"balance_details"][@"limit"]];
    
    _lblUsed.text = [NSString stringWithFormat:@"₹%@",appDelegate.dictOverview[@"balance_details"][@"used"]];
    
    _lblAvailable.text = [NSString stringWithFormat:@"₹%@",appDelegate.dictOverview[@"balance_details"][@"available"]];
    
    _lblDisbursedAmount.text = [NSString stringWithFormat:@"₹%@",appDelegate.dictOverview[@"balance_details"][@"disbured_amount"]];
    
    _lblEMIDate.text = [NSString stringWithFormat:@"%@",appDelegate.dictOverview[@"balance_details"][@"next_emi_date"]];

    marrRecentTransaction = appDelegate.dictOverview[@"recent_transactions"];
    [_tblRecentTransaction reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrRecentTransaction count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TransactionCell";
    
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        [self.tblRecentTransaction registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dictRecent = [marrRecentTransaction objectAtIndex:indexPath.row];
    
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
