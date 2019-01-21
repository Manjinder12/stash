//
//  HomeViewController.m
//  StashFin
//
//  Created by Mac on 09/05/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "HomeViewController.h"
#import "ButtonCell.h"
#import "LoadMyCardViewController.h"
#import "AmountDueDateViewController.h"
#import "OutgoingEMIViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

#define BlueColor [UIColor colorWithRed:0.f green:185.f/255.f blue:242.f/255.f alpha:1]
#define PurpleColor [UIColor colorWithRed:151.f/255.f green:88.f/255.f blue:254.f/255.f alpha:1]
#define YellowColor [UIColor colorWithRed:1.f green:234.f/255.f blue:57.f/255.f alpha:1]
#define GreenColor [UIColor colorWithRed:32.f/255.f green:218.f/255.f blue:145.f/255.f alpha:1]
#define AnimationDuration 1.0


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ApplicationUtils save:[NSNumber numberWithBool:YES] :LOGIN_STATUS];
    [self getCardAndLoanDetailsFromServer];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.approvedLimitLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.approvedLimitValue setFont:[ApplicationUtils GETFONT_MEDIUM:15]];

    [self.usedLimitLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.usedLimitValue setFont:[ApplicationUtils GETFONT_MEDIUM:15]];

    [self.availableLimitLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.availableLimitValue setFont:[ApplicationUtils GETFONT_MEDIUM:15]];

    [self.monthYearLabel setFont:[ApplicationUtils GETFONT_MEDIUM:10]];
    [self.cardNameLabel setFont:[ApplicationUtils GETFONT_MEDIUM:14]];
    [self.cardNumberLabel setFont:[ApplicationUtils GETFONT_BOLD:16]];

    [self.pictureView setLineWidth:10];
    self.pictureView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    
    self.trasparentImageView.backgroundColor = [UIColor clearColor];
    self.userImageView.backgroundColor = [UIColor clearColor];
    
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.clipsToBounds = YES;
    self.trasparentImageView.clipsToBounds = YES;
    self.pictureView.clipsToBounds = YES;

    float width = ([AppDelegate instance].window.frame.size.width - ([AppDelegate instance].window.frame.size.width*0.58+10))*0.58;
    self.pictureView.layer.cornerRadius = width/2;
    self.trasparentImageView.layer.cornerRadius = width/2;
    self.userImageView.layer.cornerRadius = (width-15)/2;

    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"profile_pic"]]]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Dashboard";
    
    [self.navigationController.view addSubview:[AppDelegate instance].notificationView];
    [ApplicationUtils setNavigationTitleAndButtonColorWithNavigationBar:self.navigationController.navigationBar withHeaderColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pictureView setProgress:0.0];
    [self.pictureView setStartColor:ROSE_PINK_COLOR];
    [self.pictureView setEndColor:ORANGE_BG_COLOR];
    
    [self.pictureView setProgress:0.8 animateWithDuration:AnimationDuration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - service

- (void)getCardAndLoanDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"cardOverview"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            self.cardOverviewDic = response;
            self.cardNameLabel.text = [ApplicationUtils validateStringData:response[@"card_details"][@"name"]];
            self.cardNumberLabel.text = [ApplicationUtils validateStringData:response[@"card_details"][@"card_no"]];
            self.monthYearLabel.text = [NSString stringWithFormat:@"%@/%@",[ApplicationUtils validateStringData:response[@"card_details"][@"expiry_month"]],[ApplicationUtils validateStringData:response[@"card_details"][@"expiry_year"]]];
        }
    }];
    
    dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"locDetails"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            self.locDetailDic = response;
            self.approvedLimitValue.text = [ApplicationUtils validateStringData:response[@"loc_limit"]];
            self.usedLimitValue.text = [ApplicationUtils validateStringData:response[@"used_loc"]];
            self.availableLimitValue.text = [ApplicationUtils validateStringData:response[@"remaining_loc"]];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonCell *cell = (ButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:@"ButtonCell"];
        cell = (ButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    cell.bgView.layer.cornerRadius = 5;
    cell.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.bgView.layer.borderWidth = 0.5;
    
    [cell.button.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    [cell.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cell.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [cell.button setUserInteractionEnabled:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            [cell.button setImage:[UIImage imageNamed:@"load_my_Card"] forState:UIControlStateNormal];
            [cell.button setTitle:@"Load My Card" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [cell.button setImage:[UIImage imageNamed:@"view_tnx"] forState:UIControlStateNormal];
            [cell.button setTitle:@"View all Transaction" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [cell.button setImage:[UIImage imageNamed:@"EMI_amount"] forState:UIControlStateNormal];
            [cell.button setTitle:@"Bill Amount Due Date" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [cell.button setImage:[UIImage imageNamed:@"outgoing_emi"] forState:UIControlStateNormal];
            [cell.button setTitle:@"Outgoing EMI" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            LoadMyCardViewController *vc = [[LoadMyCardViewController alloc] initWithNibName:@"LoadMyCardViewController" bundle:nil];
            [vc setCardOverviewDic:self.cardOverviewDic];
            [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            AmountDueDateViewController *vc = [[AmountDueDateViewController alloc] initWithNibName:@"AmountDueDateViewController" bundle:nil];
            [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
        }
            break;
        case 3:
        {
            OutgoingEMIViewController *vc = [[OutgoingEMIViewController alloc] initWithNibName:@"OutgoingEMIViewController" bundle:nil];
            [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
        }
            break;
        default:
            break;
    }
}


@end
