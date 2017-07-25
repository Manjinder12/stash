//
//  TransactionList.m
//  Stasheasy
//
//  Created by Tushar  on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "TransactionList.h"
#import "TransactionListCell.h"

@interface TransactionList () {
    NSArray *headerArr;
    NSArray *valueArr;
}

@property (weak, nonatomic) IBOutlet UITableView *transactionListTableView;

@end

@implementation TransactionList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headerArr = [[NSArray alloc]initWithObjects:@"Date",@"Time",@"Amount",@"Merchant",@"Spend Category", nil];
    valueArr = [[NSArray alloc]initWithObjects:@"12-04-17",@"02:16 PM",@"2000",@"Indian Oil Corporation",@"Fuel", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (44.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TransactionList";
    
    TransactionListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.transactionListTableView registerNib:[UINib nibWithNibName:@"TransactionListCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.mainview.backgroundColor = [UIColor clearColor];
    }
    else {
        cell.mainview.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    }
    
    cell.headerLbl.text = [headerArr objectAtIndex:indexPath.row];
    cell.valLbl.text = [valueArr objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
