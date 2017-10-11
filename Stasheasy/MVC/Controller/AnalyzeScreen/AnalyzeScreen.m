//
//  AnalyzeScreen.m
//  Stasheasy
//
//  Created by Tushar  on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "AnalyzeScreen.h"
#import "AnalyzeCell.h"
#import "AppDelegate.h"
#import "VBPieChart.h"

@interface AnalyzeScreen ()
{
    AppDelegate *appDelegate;
    NSMutableArray *marrAnalyze, *marrColor, *marrAmount, *marrTaxCount;
    NSArray *items;
    NSArray *valuesArr;
    int tab ,totalSpent, usedLOC, remainingLOC, usedValue, remainValue ;
    double pieProgress;

}

@property (weak, nonatomic) IBOutlet UILabel *lblTotalSpent;
@property (weak, nonatomic) IBOutlet UIView *swicthView;
@property (weak, nonatomic) IBOutlet UIButton *btnSpending;
@property (weak, nonatomic) IBOutlet UIButton *btnTranscation;
@property (weak, nonatomic) IBOutlet UITableView *analyzeTableView;
@property (weak, nonatomic) IBOutlet VBPieChart *viewPieChart;

- (IBAction)spendingAction:(id)sender;
- (IBAction)transactionAction:(id)sender;

@end

@implementation AnalyzeScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setupView];
    [self customInitialization];
}
- (void)customInitialization
{
    appDelegate = [AppDelegate sharedDelegate];
    marrAnalyze = [[NSMutableArray alloc] init];
    marrColor = [[NSMutableArray alloc] init];
    marrAmount = [[NSMutableArray alloc] init];
    marrTaxCount = [[NSMutableArray alloc] init];

    _swicthView.layer.cornerRadius = 20 ;
    _swicthView.layer.masksToBounds = YES;
    
    [_btnSpending setBackgroundColor:[UIColor redColor]];
    _btnSpending.titleLabel.textColor = [UIColor whiteColor];
    
    [_btnTranscation setBackgroundColor:[UIColor lightGrayColor]];
    _btnTranscation.titleLabel.textColor = [UIColor blackColor];

    tab = 0;
    usedLOC = 50;
    remainingLOC = 60;
    pieProgress = 0;

    self.analyzeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
}
- (void)viewWillAppear:(BOOL)animated
{
//    if ( [appDelegate.dictAnalyze count] == 0 )
//    {
//        [self serverCallForCardAnalyzeSpending];
//    }
//    else
//    {
//        [self populateAnalyzeSpendingData:appDelegate.dictAnalyze];
//    }
    
    
    [self serverCallForCardAnalyzeSpending];

    
}
- (void)setUpPieChart
{
    NSMutableArray *marrChartValue = [ NSMutableArray new ];
    
    int graphValue, amount;
    
    for ( int i = 0 ; i < marrAnalyze.count; i++)
    {
        amount = [ (NSNumber *) [ marrAmount objectAtIndex:i ] intValue];
        graphValue = ( amount * 100 ) / totalSpent;
        [ marrChartValue addObject:@{@"name":@"", @"value":[NSNumber numberWithInt:graphValue], @"color":[marrColor objectAtIndex:i], @"strokeColor":[UIColor whiteColor]}];
    }
    
    _viewPieChart.startAngle = M_PI+M_PI_2;
    [_viewPieChart setHoleRadiusPrecent:0.5];
    
    [_viewPieChart setChartValues:marrChartValue animation:YES duration:0.4 options:VBPieChartAnimationDefault];
}
- (void)populateAnalyzeSpendingData:(NSDictionary *)dict
{
    marrAnalyze = dict[@"spendings"];
    
    for ( NSDictionary *temp in marrAnalyze )
    {
        CGFloat aRedValue = arc4random()%255;
        CGFloat aGreenValue = arc4random()%255;
        CGFloat aBlueValue = arc4random()%255;
        
        UIColor *randomColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        
        [ marrColor addObject:randomColor ];
        [ marrAmount addObject:[temp valueForKey:@"amount"]];
    }
    
    _lblTotalSpent.text = [NSString stringWithFormat:@"₹%@",dict[@"total_spent"]];
    totalSpent = [dict[@"total_spent"] intValue];

    [ _analyzeTableView reloadData ];
    [self setUpPieChart];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrAnalyze count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AnalyzeCell";
    
    AnalyzeCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        [self.analyzeTableView registerNib:[UINib nibWithNibName:@"AnalyzeCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    NSDictionary *dict = [marrAnalyze objectAtIndex:indexPath.row];
    cell.lblCategory.text = [dict valueForKey:@"category"];
    if (tab == 1)
    {
        cell.lblAmountCount.text = [NSString stringWithFormat:@"₹%@",[dict valueForKey:@"amount"]];
    }
    else
    {
        cell.lblAmountCount.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"txn_counts"]];
    }
    
    cell.samllView.backgroundColor = [ marrColor objectAtIndex:indexPath.row ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Instance Methods

-(void)setupView
{
    items = [[NSArray alloc]initWithObjects:@"Fuel",@"Food",@"Misc",@"Entertainment", nil];
    valuesArr = [[NSArray alloc]initWithObjects:@"₹2000",@"₹4766",@"₹252",@"₹1200", nil];

    self.swicthView.layer.cornerRadius = 12.0f;
    self.swicthView.clipsToBounds =YES;
}

#pragma mark Button Action
- (IBAction)spendingAction:(id)sender
{
    tab = 1;
    [ marrAmount removeAllObjects ];
    
    [_btnSpending setBackgroundColor:[UIColor redColor]];
    _btnSpending.titleLabel.textColor = [UIColor whiteColor];
    
    [_btnTranscation setBackgroundColor:[UIColor lightGrayColor]];
    _btnTranscation.titleLabel.textColor = [UIColor blackColor];
    
    [_analyzeTableView reloadData];
}

- (IBAction)transactionAction:(id)sender
{
    tab = 2;
    [ marrAmount removeAllObjects ];
    
    [_btnTranscation setBackgroundColor:[UIColor redColor]];
    _btnTranscation.titleLabel.textColor = [UIColor whiteColor];
    
    [_btnSpending setBackgroundColor:[UIColor lightGrayColor]];
    _btnSpending.titleLabel.textColor = [UIColor blackColor];
    
    [_analyzeTableView reloadData];
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
- (void)serverCallForCardAnalyzeSpending
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"CardAnalyzeSpending" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
                 appDelegate.dictAnalyze = [NSDictionary dictionaryWithDictionary:response];
                 [self populateAnalyzeSpendingData:response];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}
@end
