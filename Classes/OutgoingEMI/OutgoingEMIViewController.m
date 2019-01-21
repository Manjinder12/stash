//
//  OutgoingEMIViewController.m
//  StashFin
//
//  Created by Mac on 12/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "OutgoingEMIViewController.h"
#import "OutgoingEMICell.h"


@interface OutgoingEMIViewController ()

@end

@implementation OutgoingEMIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.emiArray = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Outgoing EMIs";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark -  Tableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
//    return self.emiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutgoingEMICell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutgoingEMICell"];
    
    if (!cell)
    {
        [self.tableView registerNib:[UINib nibWithNibName:@"OutgoingEMICell" bundle:nil] forCellReuseIdentifier:@"OutgoingEMICell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"OutgoingEMICell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    cell.bgView.layer.shadowOpacity = 0.2f;
    cell.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.bgView.layer.shadowRadius = 5;
    cell.bgView.layer.cornerRadius = 5.0;
    cell.bgView.layer.masksToBounds = NO;

    [cell.loanLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];
    [cell.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
    [cell.roiLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [cell.emiAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [cell.emiAmountValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [cell.startDateLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [cell.startDateValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [cell.closeDateLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [cell.closeDateValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];

    [cell.loanLabel setText:[NSString stringWithFormat:@"Loan %d",indexPath.row+1]];
    [cell.amountLabel setText:@"28,500"];
    [cell.roiLabel setText:@"Rate of Interest : 2%"];
    [cell.emiAmountValueLabel setText:@"17,500"];
    [cell.startDateValueLabel setText:@"24-JAN-2018"];
    [cell.closeDateValueLabel setText:@"24-DEC-2018"];

    [cell.roiLabel setTextColor:ROSE_PINK_COLOR];
    [cell.emiAmountLabel setTextColor:ROSE_PINK_COLOR];
    [cell.startDateLabel setTextColor:ROSE_PINK_COLOR];
    [cell.closeDateLabel setTextColor:ROSE_PINK_COLOR];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

@end
