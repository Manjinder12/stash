//
//  EmiCalculatorScreen.m
//  Stasheasy
//
//  Created by tushar on 18/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "EmiCalculatorScreen.h"
#import "EmiCell.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"

@interface EmiCalculatorScreen ()

@property (weak, nonatomic) IBOutlet UITableView *emiTableView;
@property (weak, nonatomic) IBOutlet UIView *emiView;

@end

@implementation EmiCalculatorScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"EMI Calculator";
    [CommonFunctions addButton:@"menu" InNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(showMenu)];

    self.emiView.layer.cornerRadius = 5.0f;
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
    return (100.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EmiCell";
    
    EmiCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.emiTableView registerNib:[UINib nibWithNibName:@"EmiCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    int cellrow = (int) indexPath.row;
    [cell setupcellConfig:cellrow];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@""];
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
    
    
    [values addObject:[[PieChartDataEntry alloc] initWithValue:20.0f label:nil data:nil]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue:80.0f label:nil data:nil]];
    
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:nil];
    dataSet.sliceSpace = 0.0;
    dataSet.iconsOffset = CGPointMake(0, 0);
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:0.0f/255.0f  green:200.0f/255.0f blue:83.0f/255.0f alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:255.0f/255.0f  green:171.0f/255.0f blue:0.0f/255.0f alpha:1.0]];
    
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
}

- (void) showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}*/

@end
