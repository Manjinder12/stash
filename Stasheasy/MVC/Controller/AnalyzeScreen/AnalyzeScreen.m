//
//  AnalyzeScreen.m
//  Stasheasy
//
//  Created by Tushar  on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "AnalyzeScreen.h"
#import "AnalyzeCell.h"

@interface AnalyzeScreen (){
    NSArray *items;
    NSArray *valuesArr;
}


@property (weak, nonatomic) IBOutlet UIView *swicthView;
@property (weak, nonatomic) IBOutlet UIButton *SPENDINGBTN;
@property (weak, nonatomic) IBOutlet UIButton *transcationBtn;
@property (weak, nonatomic) IBOutlet UITableView *analyzeTableView;

- (IBAction)spendingTaped:(id)sender;
- (IBAction)transactionTapped:(id)sender;

@end

@implementation AnalyzeScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AnalyzeCell";
    
    AnalyzeCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.analyzeTableView registerNib:[UINib nibWithNibName:@"AnalyzeCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    cell.headLbl.text = [items objectAtIndex:indexPath.row];
    cell.valLbl.text = [valuesArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row % 2 == 0) {
        cell.mainview.backgroundColor = [UIColor clearColor];
    }
    else {
        cell.mainview.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    }
    
    if (indexPath.row == 0) {
        cell.samllView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f  green:200.0f/255.0f blue:83.0f/255.0f alpha:1.0];
    }
    else if (indexPath.row == 1) {
        cell.samllView.backgroundColor = [UIColor redColor];
    }else if (indexPath.row == 2) {
        cell.samllView.backgroundColor = [UIColor yellowColor];
    }else if (indexPath.row == 3) {
        cell.samllView.backgroundColor = [UIColor colorWithRed:126.0f/255.0f  green:88.0f/255.0f blue:194.0f/255.0f alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Instance Methods

-(void)setupView {
    items = [[NSArray alloc]initWithObjects:@"Fuel",@"Food",@"Misc",@"Entertainment", nil];
    valuesArr = [[NSArray alloc]initWithObjects:@"₹2000",@"₹4766",@"₹252",@"₹1200", nil];
//    [self setupPieChartView:self.chartView];
//    [self setDataCount:2 range:5];

    self.swicthView.layer.cornerRadius = 12.0f;
    self.swicthView.clipsToBounds =YES;
}

- (IBAction)spendingTaped:(id)sender {
}

- (IBAction)transactionTapped:(id)sender {
}


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
    
    
    [values addObject:[[PieChartDataEntry alloc] initWithValue:2000.0f label:nil data:nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:4766.0f label:nil data:nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:252.0f label:nil data:nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:1200.0f label:nil data:nil]];

    
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:nil];
    dataSet.sliceSpace = 0.0;
    dataSet.iconsOffset = CGPointMake(0, 0);
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:0.0f/255.0f  green:200.0f/255.0f blue:83.0f/255.0f alpha:1.0]];
    [colors addObject:[UIColor redColor]];
    [colors addObject:[UIColor yellowColor]];
    [colors addObject:[UIColor colorWithRed:126.0f/255.0f  green:88.0f/255.0f blue:194.0f/255.0f alpha:1.0]];

    
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
