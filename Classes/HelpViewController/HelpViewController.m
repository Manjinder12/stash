//
//  HelpViewController.m
//  StashFin
//
//  Created by sachin khard on 13/10/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "HelpViewController.h"
#import "FILeftMenuTableViewCell.h"
#import "WebViewController.h"
#import "CustomerCareViewController.h"


@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Help";
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FILeftMenuTableViewCell *cell = (FILeftMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"fiLeftMenuTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.menuLabelText setFont:[ApplicationUtils GETFONT_MEDIUM:19]];

    switch (indexPath.row) {
        case 0:
            cell.menuLabelText.text = @"Chat";
            cell.menuImageLogo.image = [UIImage imageNamed:@"ichat"];
            break;
        
        case 1:
            cell.menuLabelText.text = @"Customer Care";
            cell.menuImageLogo.image = [UIImage imageNamed:@"customer_care"];
            break;
            
        case 2:
            cell.menuLabelText.text = @"FAQs";
            cell.menuImageLogo.image = [UIImage imageNamed:@"faq"];
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
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            WebViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            [newVC setUrl:@"https://tawk.to/chat/5b20baa307752b51e61462c2/default/?$_tawk_popout=true"];
            [newVC setTitle:@"Chat"];
            [ApplicationUtils pushVCWithFadeAnimation:newVC andNavigationController:self.navigationController];
        }
            break;
            
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            CustomerCareViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"CustomerCareViewController"];
            [newVC setTitle:@"Customer Care"];
            [ApplicationUtils pushVCWithFadeAnimation:newVC andNavigationController:self.navigationController];
        }
            break;
            
        case 2:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
            WebViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            [newVC setUrl:@"https://www.stashfin.com/index.php/faq"];
            [newVC setTitle:@"FAQ"];
            [ApplicationUtils pushVCWithFadeAnimation:newVC andNavigationController:self.navigationController];
        }
            break;
            
        default:
            break;
    }
}


@end
