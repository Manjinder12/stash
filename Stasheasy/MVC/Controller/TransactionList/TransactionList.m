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
#import "ServerCall.h"

@interface TransactionList ()
{
    AppDelegate *appDelegate;
    NSMutableArray *marrTransaction;
}

@property (weak, nonatomic) IBOutlet UITableView *transactionListTableView;

@end

@implementation TransactionList

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBarHidden = YES;
    appDelegate = [AppDelegate sharedDelegate];
    
    marrTransaction = [[NSMutableArray alloc] init];

    self.transactionListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    if ([appDelegate.dictTransaction count] == 0)
//    {
//        [self serverCallForCardTransactionDetails];
//    }
    marrTransaction =  appDelegate.dictOverview[@"recent_transactions"];
    [ _transactionListTableView reloadData ];

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
- (void)serverCallForCardTransactionDetails
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"CardTransactionDetails" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"%@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 appDelegate.dictTransaction = [NSDictionary dictionaryWithDictionary:response];
                 marrTransaction =  response[@"recent_transactions"];
                 [ _transactionListTableView reloadData ];
             }
         }
         else
         {
             
         }
     }];
}

@end
