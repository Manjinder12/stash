//
//  FILeftMenuViewController.m
//  mCollect
//
//  Created by Mac on 10/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "FILeftMenuViewController.h"
#import "FILeftMenuTableViewCell.h"
#import "MenuModel.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"


@interface FILeftMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary* menuDictionary;
@property (nonatomic, strong) NSMutableArray * menuArray;

@end

@implementation FILeftMenuViewController

#define MENU_HOME           @"HOME"
#define MENU_PROFILE        @"PROFILE"
#define MENU_CHAT           @"CHAT"
#define MENU_CALCULATOR     @"CALCULATOR"
#define MENU_MYCARD         @"MYCARD"
#define MENU_REFER          @"REFER"
#define MENU_STATEMENT      @"STATEMENT"
#define MENU_UNIVERSITY     @"UNIVERSITY"
#define MENU_CUSTOMERCARE   @"CUSTOMERCARE"
#define MENU_LOGOUT         @"LOGOUT"


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
        
    _menuDictionary = @{
                        MENU_HOME : [MenuModel initMenuWithTitle:NSLocalizedString(@"Home", nil) menuId:MENU_HOME andImageName:@"Home" andOrder:@1 andVisibility:YES],
                        
                        MENU_PROFILE : [MenuModel initMenuWithTitle:NSLocalizedString(@"Profile", nil) menuId:MENU_PROFILE andImageName:@"Profile" andOrder:@2 andVisibility:YES],
                        
                        MENU_CHAT : [MenuModel initMenuWithTitle:NSLocalizedString(@"Chat", nil) menuId:MENU_CHAT andImageName:@"Chat" andOrder:@3 andVisibility:YES],
                        
                        MENU_CALCULATOR : [MenuModel initMenuWithTitle:NSLocalizedString(@"Loan Calculator", nil) menuId:MENU_CALCULATOR andImageName:@"Loan Calculator" andOrder:@4 andVisibility:YES],
                        
                        MENU_MYCARD : [MenuModel initMenuWithTitle:NSLocalizedString(@"My Card", nil) menuId:MENU_MYCARD andImageName:@"My Card" andOrder:@5 andVisibility:YES],
                        
                        MENU_REFER : [MenuModel initMenuWithTitle:NSLocalizedString(@"Refer & Earn", nil) menuId:MENU_REFER andImageName:@"Refer & Earn" andOrder:@6 andVisibility:YES],
                        
                        MENU_STATEMENT : [MenuModel initMenuWithTitle:NSLocalizedString(@"Loan Statement", nil) menuId:MENU_STATEMENT andImageName:@"Loan Statement" andOrder:@7 andVisibility:YES],
                        
                        MENU_UNIVERSITY : [MenuModel initMenuWithTitle:NSLocalizedString(@"StashFin University", nil) menuId:MENU_UNIVERSITY andImageName:@"StashFin University" andOrder:@8 andVisibility:YES],
                        
                        MENU_CUSTOMERCARE: [MenuModel initMenuWithTitle:NSLocalizedString(@"Customer Care", nil) menuId:MENU_CUSTOMERCARE andImageName:@"Customer Care" andOrder:@9 andVisibility:YES],
                        
                        MENU_LOGOUT : [MenuModel initMenuWithTitle:NSLocalizedString(@"Logout", nil) menuId:MENU_LOGOUT andImageName:@"Logout" andOrder:@10 andVisibility:YES]
                        };
    
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
    [[AppDelegate instance] getLoginData];
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
    self.dateLabel.text = [ApplicationUtils getRespectiveDateString:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"dob"]] withOutputFormat:@"dd-MMM-yyyy"];
    
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.layer.masksToBounds = YES;
    self.picImageView.layer.cornerRadius = 200*0.48/2;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"profile_pic"]]]];

    [self.nameLabel setFont:[ApplicationUtils GETFONT_BOLD:20]];
    [self.dateLabel setFont:[ApplicationUtils GETFONT_REGULAR:15]];
    
    //Present View accroding to Order
    [self selectMenuAction:[_menuArray objectAtIndex:0]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectMenuAction:_menuArray[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FILeftMenuTableViewCell *cell = (FILeftMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"fiLeftMenuTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MenuModel * menu = _menuArray[indexPath.row];
    cell.menuImageLogo.image = [UIImage imageNamed:menu.imageName];
    cell.menuLabelText.text = menu.title;
    [cell.menuLabelText setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuArray count];
}

#pragma mark - Menu Selection

- (void)selectMenuAction:(MenuModel *)menu {
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


    self.view.userInteractionEnabled = YES;
}

@end
