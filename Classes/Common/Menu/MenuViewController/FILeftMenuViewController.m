//
//  FILeftMenuViewController.m
//  StashFin
//
//  Created by Mac on 10/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "FILeftMenuViewController.h"
#import "FILeftMenuTableViewCell.h"
#import "MenuModel.h"
#import "HomeViewController.h"
#import "CardPinViewController.h"
#import "LoanCalViewController.h"
#import "BlockCardViewController.h"
#import "AppStatusViewController.h"
#import "ActivateCardViewController.h"
#import "GetCardViewController.h"
#import "HelpViewController.h"
#import "PaybackViewController.h"
#import "StashFin-Swift.h"


@interface FILeftMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary* menuDictionary;
@property (nonatomic, strong) NSMutableArray * menuArray;

@end

@implementation FILeftMenuViewController

#define MENU_HOME               @"HOME"
#define MENU_PROFILE            @"PROFILE"
#define MENU_HELP               @"HELP"
#define MENU_BLOCK_CARD         @"BLOCK_CARD"
#define MENU_CALCULATOR         @"CALCULATOR"
#define MENU_CARD_PIN           @"CARD_PIN"
#define MENU_APPLICATION_STATUS @"APPLICATION_STATUS"
#define MENU_LOGOUT             @"LOGOUT"
#define MENU_GET_CARD           @"GET_CARD"
#define MENU_ACTIVATE_CARD      @"ACTIVATE_CARD"
#define MENU_PAYBACK            @"PAYBACK"


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    _menuDictionary = [NSMutableDictionary dictionary];
    
    NSString *loanStatus = [[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"latest_loan_details"][@"current_status"]] lowercaseString];
    
    if ([loanStatus isEqualToString:@"disbursed"] || [loanStatus isEqualToString:@"closed"])
    {
        //if error or 201 don't show Dashboard
        
        if ([AppDelegate instance].locData) {
            [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Home", nil) menuId:MENU_HOME andImageName:@"home" andOrder:@1 andVisibility:YES] forKey:MENU_HOME];
        }
    }
    else {
        [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Application Status", nil) menuId:MENU_APPLICATION_STATUS andImageName:@"home" andOrder:@1 andVisibility:YES] forKey:MENU_APPLICATION_STATUS];
    }
    
    if ([AppDelegate instance].cardData) {
        NSDictionary *cardStatus = [AppDelegate instance].cardData[@"card_status"];
        
        if (![cardStatus[@"card_found"] boolValue]) {
            [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Get Stashfin Card", nil) menuId:MENU_GET_CARD andImageName:@"home" andOrder:@2 andVisibility:YES] forKey:MENU_GET_CARD];
        }
        else {
            if ([cardStatus[@"card_registered"] boolValue]) {
                [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Change Card Pin", nil) menuId:MENU_CARD_PIN andImageName:@"card_pin" andOrder:@2 andVisibility:YES] forKey:MENU_CARD_PIN];
                
                [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Block Card", nil) menuId:MENU_BLOCK_CARD andImageName:@"card_block" andOrder:@3 andVisibility:YES] forKey:MENU_BLOCK_CARD];
            }
            else {
                [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Activate Card", nil) menuId:MENU_ACTIVATE_CARD andImageName:@"home" andOrder:@2 andVisibility:YES] forKey:MENU_ACTIVATE_CARD];
            }
        }
    }

    
    [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Profile", nil) menuId:MENU_PROFILE andImageName:@"profile" andOrder:@5 andVisibility:YES] forKey:MENU_PROFILE];
    
    [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Loan Calculator", nil) menuId:MENU_CALCULATOR andImageName:@"loan_calc" andOrder:@6 andVisibility:YES] forKey:MENU_CALCULATOR];
    
    NSString *paybackStatus = [ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"paybackStatus"]];
    
    if ([paybackStatus boolValue]) {
        [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Payback", nil) menuId:MENU_PAYBACK andImageName:@"payback_logo" andOrder:@7 andVisibility:YES] forKey:MENU_PAYBACK];
    }

    [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Help", nil) menuId:MENU_HELP andImageName:@"help" andOrder:@8 andVisibility:YES] forKey:MENU_HELP];
    
    [_menuDictionary setObject:[MenuModel initMenuWithTitle:NSLocalizedString(@"Logout", nil) menuId:MENU_LOGOUT andImageName:@"logout" andOrder:@9 andVisibility:YES] forKey:MENU_LOGOUT];
    
    _menuArray = [[NSMutableArray alloc] init];
    
    NSArray *keys = _menuDictionary.allKeys;
    for (NSString *key in keys) {
        [_menuArray addObject:[_menuDictionary objectForKey:key]];
    }
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    _menuArray = [[_menuArray sortedArrayUsingDescriptors:descriptors] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppDelegate instance] addNotificationButton];
    
    //TableView SetUp
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.bounces = YES;
    self.tableView.scrollsToTop = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.nameLabel.text = [[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"customer_name"]] uppercaseString];
    self.dateLabel.text = [ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"dob"]] withOutputFormat:DATE_FORMATTER];
    
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.layer.masksToBounds = YES;
    self.picImageView.layer.cornerRadius = 200*0.48/2;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"profile_pic"]]]];

    [self.nameLabel setFont:[ApplicationUtils GETFONT_BOLD:20]];
    [self.dateLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    
    //Present View accroding to Order
    [self selectMenuActionWithIndex:0];
    [ApplicationUtils save:[NSNumber numberWithBool:YES] :LOGIN_STATUS];
    [ApplicationUtils setNavigationTitleAndButtonColorWithNavigationBar:self.navigationController.navigationBar withHeaderColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View DataSource Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectMenuActionWithIndex:indexPath.row];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FILeftMenuTableViewCell *cell = (FILeftMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"fiLeftMenuTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MenuModel * menu = _menuArray[indexPath.row];
    cell.menuLabelText.text = menu.title;
    [cell.menuLabelText setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    
    if (selectedRow == indexPath.row && !([menu.menuID isEqualToString:MENU_LOGOUT])) {
        cell.menuLabelText.textColor = ROSE_PINK_COLOR;
        cell.menuImageLogo.image = [UIImage imageNamed:menu.imageName];
    }
    else {
        cell.menuLabelText.textColor = [UIColor darkGrayColor];
        cell.menuImageLogo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_dark",menu.imageName]];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuArray count];
}

#pragma mark - Menu Selection

- (void)selectMenuActionWithIndex:(NSInteger)index {
    
    self.view.userInteractionEnabled = NO;
    selectedRow = index;
    [self.tableView reloadData];

    MenuModel *menu = _menuArray[index];
    
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;

    if([menu.menuID isEqualToString:MENU_LOGOUT])
    {
        [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:NSLocalizedString(@"Are you sure you want to logout?", nil) cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
            
            [[AppDelegate instance] logoutUpdateUI];
            [self.sideMenuViewController hideMenuViewController];
            
        }] otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", nil)], nil];
        [[AlertViewManager sharedManager].alertView show];
    }
    else if([menu.menuID isEqualToString:MENU_HOME])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        HomeViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_PROFILE])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        ProfileViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_CARD_PIN])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        CardPinViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"CardPinViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_CALCULATOR])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        LoanCalViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"LoanCalViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_PAYBACK])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        PaybackViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"PaybackViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_BLOCK_CARD])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        BlockCardViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"BlockCardViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_APPLICATION_STATUS])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        AppStatusViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"AppStatusViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_ACTIVATE_CARD])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        ActivateCardViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivateCardViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_GET_CARD])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        GetCardViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"GetCardViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if([menu.menuID isEqualToString:MENU_HELP])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
        HelpViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        navigationController.viewControllers = @[newVC];
        [self.sideMenuViewController hideMenuViewController];
    }
    self.view.userInteractionEnabled = YES;
}

@end
