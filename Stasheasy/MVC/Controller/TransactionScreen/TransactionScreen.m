//
//  TransactionScreen.m
//  Stasheasy
//
//  Created by Duke on 07/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "TransactionScreen.h"
#import "TransactionCell.h"

@interface TransactionScreen () {
    ActionView *actionView;
    NSArray *parties;
    NSArray *valueArr;
}
@property (weak, nonatomic) IBOutlet UIView *chartOuterView;
@property (weak, nonatomic) IBOutlet UITableView *transactionTableview;

@end

@implementation TransactionScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    valueArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:47],[NSNumber numberWithInt:47], nil];
    // Do any additional setup after loading the view.
    _chartOuterView.layer.cornerRadius = 5.0f;
    _chartOuterView.layer.masksToBounds =YES;
//    [self setupPieChartView:self.chartView];
//    [self setDataCount:2 range:5];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (60.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TransactionCell";
    
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.transactionTableview registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2 != 0) {
        cell.tView.backgroundColor = [UIColor clearColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark  - IBActions Methods

- (IBAction)actionTapped:(id)sender {
    actionView = [[[NSBundle mainBundle] loadNibNamed:@"ActionView" owner:self options:nil] objectAtIndex:0];
    actionView.frame =CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
    UIButton *crossBtn = [actionView viewWithTag:5];
    [crossBtn addTarget:self action:@selector(crossbuttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:actionView];
}

- (void)crossbuttonTapped {
    [actionView removeFromSuperview];
}

#pragma mark - Instance Methods

/*- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.chartDescription.enabled = NO;
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"50K"];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
                                NSForegroundColorAttributeName: UIColor.blackColor
                                } range:NSMakeRange(0, centerText.length)];

    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = NO;
    chartView.highlightPerTapEnabled = NO;
    chartView.legend.enabled = NO;
    
}

- (void)setDataCount:(int)count range:(double)range
{
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    

        [values addObject:[[PieChartDataEntry alloc] initWithValue:3.0f label:nil data:nil]];
        [values addObject:[[PieChartDataEntry alloc] initWithValue:47.0f label:nil data:nil]];

    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:nil];
    dataSet.sliceSpace = 0.0;
    dataSet.iconsOffset = CGPointMake(0, 0);
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:0.0f/255.0f  green:200.0f/255.0f blue:83.0f/255.0f alpha:1.0]];
    [colors addObject:[UIColor redColor]];

    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueTextColor:[UIColor blackColor]];
    
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}*/


@end
