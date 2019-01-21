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
#import "PaymentPageViewController.h"
//#import "AmountDueDateViewController.h"
#import "OutgoingEMIViewController.h"
#import "TransactionViewController.h"


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
    
    self.remainingAmountValue.textColor = ROSE_PINK_COLOR;
    self.nextEMIDateValue.textColor = ROSE_PINK_COLOR;
    self.nextEMIAmountValue.textColor = ROSE_PINK_COLOR;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.approvedLimitLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.approvedLimitValue setFont:[ApplicationUtils GETFONT_MEDIUM:15]];

    [self.usedLimitLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.usedLimitValue setFont:[ApplicationUtils GETFONT_MEDIUM:15]];

    [self.availableLimitLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    [self.availableLimitValue setFont:[ApplicationUtils GETFONT_MEDIUM:15]];
    
    [self.remainingAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [self.remainingAmountValue setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    
    [self.nextEMIDateLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [self.nextEMIDateValue setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    
    [self.nextEMIAmountLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [self.nextEMIAmountValue setFont:[ApplicationUtils GETFONT_MEDIUM:17]];

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

    self.topBGView.layer.cornerRadius = 5;

//    self.bg1View.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    self.bg1View.layer.shadowOpacity = 0.2f;
//    self.bg1View.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bg1View.layer.shadowRadius = 5;
//    self.bg1View.layer.borderWidth = 0.5;
//    self.bg1View.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg1View.layer.masksToBounds = NO;
    self.bg1View.layer.cornerRadius = 5.0;

//    self.bg2View.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    self.bg2View.layer.shadowOpacity = 0.2f;
//    self.bg2View.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bg2View.layer.shadowRadius = 5;
//    self.bg2View.layer.borderWidth = 0.5;
//    self.bg2View.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg2View.layer.masksToBounds = NO;
    self.bg2View.layer.cornerRadius = 5.0;

//    self.bg3View.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    self.bg3View.layer.shadowOpacity = 0.2f;
//    self.bg3View.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bg3View.layer.shadowRadius = 5;
//    self.bg3View.layer.borderWidth = 0.5;
//    self.bg3View.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg3View.layer.masksToBounds = NO;
    self.bg3View.layer.cornerRadius = 5.0;

    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"profile_pic"]]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Dashboard";
    
    //SK Change
//    [self.navigationController.view addSubview:[AppDelegate instance].notificationView];
    
    if ([AppDelegate instance].cardData && ![[AppDelegate instance].cardData allKeys].count) {
        [self getCardDetailsFromServer];
    }
    else {
        [self setCardDisplayData];
    }
    
    if ([AppDelegate instance].locData && ![[AppDelegate instance].locData allKeys].count) {
        [self getLOCDetailsFromServer];
    }
    else {
        [self setLOCDisplayData];
    }
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

- (void)getCardDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"cardOverview"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            [[AppDelegate instance] updateCardData:response];
            [self setCardDisplayData];
        }
    }];
}

- (void)getLOCDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"locDetails"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            [[AppDelegate instance] updateLOCData:response];
            [self setLOCDisplayData];
        }
    }];
}

- (void)setCardDisplayData {
    self.cardNameLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"name"]];
    self.cardNumberLabel.text = [ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"card_no"]];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@/%@",[ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"expiry_month"]],[ApplicationUtils validateStringData:[AppDelegate instance].cardData[@"card_details"][@"expiry_year"]]];
}

- (void)setLOCDisplayData {
    self.approvedLimitValue.text = [CURRENCY_SYMBOL stringByAppendingString:[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"loc_limit"]]];
    self.usedLimitValue.text = [CURRENCY_SYMBOL stringByAppendingString:[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"used_loc"]]];
    self.availableLimitValue.text = [CURRENCY_SYMBOL stringByAppendingString:[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"remaining_loc"]]];
    
    self.remainingAmountValue.text = [CURRENCY_SYMBOL stringByAppendingString:[NSString stringWithFormat:@"%0.2f",[[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"total_balance"]] floatValue]]];
    self.nextEMIDateValue.text = [ApplicationUtils validateStringData:[AppDelegate instance].locData[@"next_emi_date"]];
    self.nextEMIAmountValue.text = [CURRENCY_SYMBOL stringByAppendingString:[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"next_emi_amount"]]];
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
            [cell.button setTitle:@"Pay EMI" forState:UIControlStateNormal];
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
            [ApplicationUtils pushVCWithFadeAnimation:vc andNavigationController:self.navigationController];
        }
            break;
        case 1:
        {
            [self performSegueWithIdentifier:@"TransactionViewController" sender:nil];
        }
            break;
        case 2:
        {
            PaymentPageViewController *vc = [[PaymentPageViewController alloc] initWithNibName:@"PaymentPageViewController" bundle:nil];
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



/*
 4. Load My Card - load card API + next screen
 1. Change card pin - Next screen for pin change design + API
 2. Block card API
 3. Profile complete
 7. outgoin EMI info icon only

 5. View all transaction complete
 6. Bill Amount Due date complete
 
 "last_loc_request_status" = disbursed;
 "loc_limit" = 300000;
 "next_emi_amount" = 41172;
 "next_emi_date" = "06 Oct 2018";
 "next_emi_found" = 1;
 "remaining_loc" = 162258;
 "total_balance" = "203.74";
 "total_overdue_amount" = "<null>";
 "used_loc" = 137742;

 

 */


@end
