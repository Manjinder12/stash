//
//  OutgoingEMIViewController.m
//  StashFin
//
//  Created by Mac on 12/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "OutgoingEMIViewController.h"
#import "OutgoingEMICell.h"
#import "EMIDistributionCell.h"


@interface OutgoingEMIViewController ()

@end

@implementation OutgoingEMIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.emiArray = [NSMutableArray array];
    [self performSelector:@selector(getOutgoingEMIDetailsFromServer) withObject:nil afterDelay:0.1];
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
    return self.emiArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            EMIDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EMIDistributionCell"];
            
            if (!cell)
            {
                [self.tableView registerNib:[UINib nibWithNibName:@"EMIDistributionCell" bundle:nil] forCellReuseIdentifier:@"EMIDistributionCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"EMIDistributionCell"];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
//            cell.bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//            cell.bgView.layer.shadowOpacity = 0.2f;
//            cell.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//            cell.bgView.layer.shadowRadius = 5;
//            cell.bgView.layer.masksToBounds = NO;
            cell.bgView.layer.cornerRadius = 5.0;

            [cell.emiDistributionLabel setFont:[ApplicationUtils GETFONT_MEDIUM:21]];
            [cell.amount1Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
            [cell.amount2Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
            [cell.amount3Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
            [cell.amount4Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
            [cell.amount5Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
            [cell.amount6Label setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
            [cell.date1Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.date2Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.date3Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.date4Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.date5Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.date6Label setFont:[ApplicationUtils GETFONT_REGULAR:16]];

            NSDictionary *tempDic = self.emiDic[@"total"];
            
            [cell.emiDistributionLabel setText:@"EMI Distribution:"];
            [cell.amount1Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"first"][@"amount"]]]];
            [cell.amount2Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"second"][@"amount"]]]];
            [cell.amount3Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"third"][@"amount"]]]];
            [cell.amount4Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"fourth"][@"amount"]]]];
            [cell.amount5Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"fifth"][@"amount"]]]];
            [cell.amount6Label setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"sixth"][@"amount"]]]];

            [cell.date1Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"first"][@"date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.date2Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"second"][@"date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.date3Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"third"][@"date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.date4Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"fourth"][@"date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.date5Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"fifth"][@"date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.date6Label setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"sixth"][@"date"]] withOutputFormat:DATE_FORMATTER]];
            
            return cell;
        }
            break;
            
        default:
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
            
//            cell.bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//            cell.bgView.layer.shadowOpacity = 0.2f;
//            cell.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//            cell.bgView.layer.shadowRadius = 5;
//            cell.bgView.layer.masksToBounds = NO;
            cell.bgView.layer.cornerRadius = 5.0;

            [cell.loanLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];
            [cell.amountLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
            [cell.roiLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.emiAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.emiAmountValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
            [cell.startDateLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.startDateValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
            [cell.closeDateLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
            [cell.closeDateValueLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
            
            cell.infoBtn.tag = self.emiArray.count-(indexPath.row);
            [cell.infoBtn addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            NSDictionary *tempDic = self.emiArray[self.emiArray.count-(indexPath.row)];
            NSDictionary *tDic = [tempDic[@"emis"] firstObject];

            [cell.loanLabel setText:[NSString stringWithFormat:@"Loan %ld",(long)(self.emiArray.count-(indexPath.row-1))]];
            
            [cell.amountLabel setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tempDic[@"approved_amount"]]]];
            
            [cell.roiLabel setText:[[NSString stringWithFormat:@"Rate of Interest : %@",[ApplicationUtils validateStringData:tempDic[@"approved_rate"]]] stringByAppendingString:@"% PM"]];
            
            [cell.emiAmountValueLabel setText:[NSString stringWithFormat:@"%@%@",CURRENCY_SYMBOL,[ApplicationUtils validateStringData:tDic[@"amount"]]]];
            
            [cell.startDateValueLabel setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"emi_start_date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.closeDateValueLabel setText:[ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:tempDic[@"emi_end_date"]] withOutputFormat:DATE_FORMATTER]];
            
            [cell.roiLabel setTextColor:ROSE_PINK_COLOR];
            [cell.emiAmountLabel setTextColor:ROSE_PINK_COLOR];
            [cell.startDateLabel setTextColor:ROSE_PINK_COLOR];
            [cell.closeDateLabel setTextColor:ROSE_PINK_COLOR];
            
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void)infoButtonAction:(UIButton *)sender {
    if (!self.popupView) {
        self.popupView = [[EMIPopupView alloc] initWithFrame:self.view.frame];
        self.popupView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.popupView];
    }
    
    self.popupView.alpha = 0.0;
    [self.popupView setData:self.emiArray[sender.tag]];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.popupView];
}

#pragma mark - service

- (void)getOutgoingEMIDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"consolidatedEmisDetails"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            self.emiDic = response;
            self.emiArray = self.emiDic[@"loans"];
            [self.tableView reloadData];
        }
    }];
}

@end
