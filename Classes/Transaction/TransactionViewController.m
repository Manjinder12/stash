//
//  TransactionViewController.m
//  StashFin
//
//  Created by sachin khard on 13/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionCell.h"
#import "AnalysisCell.h"


@interface TransactionViewController ()

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sliderLabel.backgroundColor = ROSE_PINK_COLOR;
    self.transactionTableView.tableFooterView = [UIView new];
    
    [self.transactionButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [self.analysisButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    
    [self setSearchBarProperties:searchBar];
    [self performSelector:@selector(buttonActions:) withObject:self.transactionButton afterDelay:0.1];
    
    self.sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sortButton.frame = CGRectMake([AppDelegate instance].window.frame.size.width - 55, 0, 45, 45);
    [self.sortButton addTarget:self action:@selector(sortButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortButton setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    self.sortButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"All Transactions";
    
    [self.navigationController.navigationBar addSubview:self.sortButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
    
    [self.sortButton removeFromSuperview];
}

- (void)sortButtonAction:(UIButton *)sender {
    isAscending = !isAscending;
    
    self.searchListArray = [self.searchListArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"amount.doubleValue" ascending:isAscending]]];
    
    [self.transactionTableView reloadData];
}

- (void)setSearchBarProperties:(UISearchBar *)searchBar {
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]      setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                                                                             forState:UIControlStateNormal];
}

- (IBAction)buttonActions:(UIButton *)sender {
    if (sender == self.transactionButton && !sender.selected)
    {
        self.transactionButton.selected = YES;
        self.analysisButton.selected = NO;

        [self slideAnimationWithXCord:0];
        
        if (!self.transactionArray.count) {
            [self getTransactionDetailsFromServer];
        }
        else {
            [self searchBarCancelButtonClicked:searchBar];
        }
    }
    else if (sender == self.analysisButton && !sender.selected)
    {
        self.transactionButton.selected = NO;
        self.analysisButton.selected = YES;
        
        [self slideAnimationWithXCord:self.transactionButton.frame.size.width];

        if (!self.analysisArray.count) {
            [self getCardAnalysisDetailsFromServer];
        }
        else {
            [self searchBarCancelButtonClicked:searchBar];
        }
    }
}

- (void)slideAnimationWithXCord:(float)xCord {
    
    [UIView transitionWithView:self.sliderLabel
                      duration:0.4
                       options:0
                    animations:^{
                        CGRect frame = self.sliderLabel.frame;
                        frame.origin.x = xCord;
                        self.sliderLabel.frame = frame;
                    }
                    completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -  Tableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.transactionButton.selected)
    {
        TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.companyLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
        [cell.dateLabel setFont:[ApplicationUtils GETFONT_REGULAR:14]];
        [cell.transactionIDLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
        [cell.typeLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
        [cell.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
        
        NSDictionary *tempDic = self.searchListArray[indexPath.row];
        
        [cell.companyLabel setText:[ApplicationUtils validateStringData:tempDic[@"otherPartyName"]]];
        [cell.dateLabel setText:[ApplicationUtils validateStringData:tempDic[@"date"]]];
        [cell.transactionIDLabel setText:[NSString stringWithFormat:@"Transaction ID: %@",[ApplicationUtils validateStringData:tempDic[@"txRef"]]]];
        [cell.typeLabel setText:[ApplicationUtils validateStringData:tempDic[@"type"]]];
        [cell.amountLabel setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"amount"]]]];
        
        if ([[[ApplicationUtils validateStringData:tempDic[@"type"]] uppercaseString] isEqualToString:@"CREDIT"]) {
            [cell.amountLabel setTextColor:[UIColor greenColor]];
            [cell.typeLabel setTextColor:[UIColor greenColor]];
        }
        else {
            [cell.amountLabel setTextColor:ROSE_PINK_COLOR];
            [cell.typeLabel setTextColor:ROSE_PINK_COLOR];
        }

        return cell;
    }
    else {
        AnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnalysisCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.countLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
        [cell.analysisLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
        [cell.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
        
        [cell.amountLabel setTextColor:ROSE_PINK_COLOR];
        
        NSDictionary *tempDic = self.searchListArray[indexPath.row];

        [cell.analysisLabel setText:[ApplicationUtils validateStringData:tempDic[@"category"]]];
        [cell.countLabel setText:[NSString stringWithFormat:@"Count: %@",[ApplicationUtils validateStringData:tempDic[@"txn_counts"]]]];
        [cell.amountLabel setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"amount"]]]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

#pragma mark - UISearch Bar Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [self handleSearch:nil];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    if ([searchBar.text length] > 0) {
        
        if (self.transactionButton.selected) {
            NSIndexSet *indexes = [self.transactionArray indexesOfObjectsPassingTest:^BOOL(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
                
                if (([[dic[@"txRef"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) || ([[dic[@"otherPartyName"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) || ([[dic[@"amount"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) || ([[dic[@"type"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) || ([[dic[@"date"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound))
                    return YES;
                return NO;
            }];
            self.searchListArray = [self.transactionArray objectsAtIndexes:indexes];
        }
        else {
            NSIndexSet *indexes = [self.analysisArray indexesOfObjectsPassingTest:^BOOL(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
                
                if (([[dic[@"category"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) || ([[dic[@"amount"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) || ([[dic[@"txn_counts"] lowercaseString] rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound))
                    return YES;
                return NO;
            }];
            self.searchListArray = [self.analysisArray objectsAtIndexes:indexes];
        }
    }
    else {
        if (self.transactionButton.selected) {
            self.searchListArray = self.transactionArray;
        }
        else {
            self.searchListArray = self.analysisArray;
        }
    }
    
    [UIView animateWithDuration:0.0 delay:0.0 options:0 animations:^{
        self.transactionTableView.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        [self.transactionTableView reloadData];
    }];
}

#pragma mark - service

- (void)getTransactionDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"cardTransactions"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:[AppDelegate instance].window withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            self.transactionArray = [NSArray arrayWithArray:response];
            [self searchBarCancelButtonClicked:searchBar];
        }
    }];
}

- (void)getCardAnalysisDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"CardAnalyzeSpending"     forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:[AppDelegate instance].window withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            self.analysisArray = [NSArray arrayWithArray:response[@"spendings"]];
            [self searchBarCancelButtonClicked:searchBar];
        }
    }];
}

/*
 mode=cardTransactions
 
 
 [{"txRef":"595929633","otherPartyName":"STASHFIN  ","amount":"500.0","place":"","type":"CREDIT","date":"13-Aug-2018 09:17 PM"},{"txRef":"485105517","otherPartyName":"STASHFIN  ","amount":"500.0","place":"","type":"CREDIT","date":"13-Sep-2018 09:11 PM"},{"txRef":"894634503","otherPartyName":"STASHFIN  ","amount":"500.0","place":"","type":"CREDIT","date":"12-Sep-2018 11:57 AM"},{"txRef":"899207276","otherPartyName":"STASHFIN  ","amount":"500.0","place":"","type":"CREDIT","date":"11-Sep-2018 10:35 AM"},{"txRef":"765256941","otherPartyName":"STASHFIN  ","amount":"500.0","place":"","type":"CREDIT","date":"10-Sep-2018 02:05 PM"},{"txRef":"522510014","otherPartyName":"+CORP SATBARI RD DEL   NE","amount":"10000.0","place":"","type":"DEBIT","date":"07-Sep-2018 08:25 PM"},{"txRef":"725476909","otherPartyName":"DHINGRA SERVICE","amount":"514.75","place":"","type":"DEBIT","date":"07-Sep-2018 07:44 PM"},{"txRef":"569904752","otherPartyName":"KONCEPT AUTOMOBILES","amount":"2089.0","place":"","type":"DEBIT","date":"07-Sep-2018 06:46 PM"},{"txRef":"465038385","otherPartyName":"KONCEPT AUTOMOBILES","amount":"2089.0","place":"","type":"DEBIT","date":"07-Sep-2018 06:44 PM"},{"txRef":"487777057","otherPartyName":"STASHFIN  ","amount":"7500.0","place":"","type":"CREDIT","date":"07-Sep-2018 02:57 PM"},{"txRef":"655451852","otherPartyName":"BHARAT PETROLEUM","amount":"1029.5","place":"","type":"DEBIT","date":"07-Sep-2018 01:02 AM"},{"txRef":"529706390","otherPartyName":"BARISTA COFFEE.","amount":"130.0","place":"","type":"DEBIT","date":"05-Sep-2018 08:53 AM"}]
 
 mode=CardAnalyzeSpending
 
 {"total_spent":359964.3,"spendings":[{"category":"TRAVEL\/TRANSPORTATION\/GAS AND FUEL SERVICES","amount":"580","txn_counts":"1"},{"category":"ELECTRONIC AND TECHNICAL SERVICES","amount":"6672","txn_counts":"4"},{"category":"HEALTHCARE\/CHILDCARE SERVICES","amount":"300","txn_counts":"1"},{"category":"CLOTHING\/SHOES\/ACCESSORIES\/UNIFORMS\/RETAIL STORES\/BUYING AND SELLING SERVICES","amount":"3995","txn_counts":"1"},{"category":"CLOTHING\/SHOES\/ACCESSORIES\/UNIFORMS\/RETAIL STORES\/BUYING AND SELLING SERVICES","amount":"9115.8","txn_counts":"15"},{"category":"CLOTHING\/SHOES\/ACCESSORIES\/UNIFORMS\/RETAIL STORES\/BUYING AND SELLING SERVICES","amount":"3880.4","txn_counts":"4"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"1470","txn_counts":"3"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"1115","txn_counts":"5"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"804","txn_counts":"3"},{"category":"ASSOCIATIONS\/ORGANIZATIONS","amount":"23566","txn_counts":"3"},{"category":"TRAVEL\/TRANSPORTATION\/GAS AND FUEL SERVICES","amount":"38091.5","txn_counts":"20"},{"category":"CLOTHING\/SHOES\/ACCESSORIES\/UNIFORMS\/RETAIL STORES\/BUYING AND SELLING SERVICES","amount":"2487","txn_counts":"1"},{"category":"FURNISHINGS\/APPLIANCES\/MAINTENANCE\/HOME","amount":"584","txn_counts":"3"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"12065.16","txn_counts":"10"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"3039","txn_counts":"13"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"2150","txn_counts":"12"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"8330.42","txn_counts":"9"},{"category":"GROCERY STORES\/PHARMACIES\/FOOD SERVICES\/RESTAURANTS","amount":"3840","txn_counts":"2"},{"category":"CLOTHING\/SHOES\/ACCESSORIES\/UNIFORMS\/RETAIL STORES\/BUYING AND SELLING SERVICES","amount":"1350","txn_counts":"1"},{"category":"CLOTHING\/SHOES\/ACCESSORIES\/UNIFORMS\/RETAIL STORES\/BUYING AND SELLING SERVICES","amount":"2600","txn_counts":"1"},{"category":"FINANCIAL SERVICES","amount":"192500","txn_counts":"40"},{"category":"FINANCIAL SERVICES","amount":"2500","txn_counts":"1"},{"category":"Miscellaneous","amount":"1481.02","txn_counts":"2"},{"category":"LODGING \u2014 HOTELS, MOTELS, RESORTS","amount":"796","txn_counts":"1"},{"category":"BUSINESS\/PROFESSIONAL\/MISCELLANEOUS SERVICES","amount":"220","txn_counts":"1"},{"category":"BUSINESS\/PROFESSIONAL\/MISCELLANEOUS SERVICES","amount":"1416","txn_counts":"3"},{"category":"ENTERTAINMENT\/THEATER\/DANCE STUDIOS","amount":"1920","txn_counts":"2"},{"category":"ENTERTAINMENT\/THEATER\/DANCE STUDIOS","amount":"4240","txn_counts":"2"},{"category":"HEALTHCARE\/CHILDCARE SERVICES","amount":"2400","txn_counts":"3"},{"category":"ASSOCIATIONS\/ORGANIZATIONS","amount":"1200","txn_counts":"1"},{"category":"ASSOCIATIONS\/ORGANIZATIONS","amount":"300","txn_counts":"1"},{"category":"Miscellaneous","amount":"24956","txn_counts":"17"}]}
 
 
 
 */
@end
