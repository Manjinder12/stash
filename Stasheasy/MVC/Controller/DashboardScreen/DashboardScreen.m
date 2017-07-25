//
//  DashboardScreen.m
//  Stasheasy
//
//  Created by Duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "DashboardScreen.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"
#import "StatusScreen.h"
#import "TransactionScreen.h"
#import "Status2Screen.h"
#import "ChatScreen.h"

@interface DashboardScreen ()

@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation DashboardScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"Dashboard";
    [CommonFunctions addButton:@"menu" InNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(showMenu)];
    [self addStatusScreen];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showThirdStep) name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStatusScreen) name:@"change3" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatBtnTapped) name:@"chat" object:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

-(void)addStatusScreen
{
    UIView *viewToRemove = [self.view viewWithTag:18];
    if (viewToRemove)
    {
        [viewToRemove removeFromSuperview];
    }
    
    _lineCreditVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"LineCreditVC"];
    [_lineCreditVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _lineCreditVC.view.tag = 17;

//    _status2ScreenVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"Status2Screen"];
//    [_status2ScreenVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
//    _status2ScreenVC.view.tag = 17;
    
    [_viewContainer addSubview:_lineCreditVC.view];
}

-(void)showThirdStep
{
    
//    [_status2ScreenVC willMoveToParentViewController:nil];
    //[_status2ScreenVC.view removeFromSuperview];
//    [_status2ScreenVC removeFromParentViewController];
    UIView *viewToRemove = [self.view viewWithTag:17];
    [viewToRemove removeFromSuperview];
    
    _statusScreenVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusScreen"];
//    [self addChildViewController:_statusScreenVC];
    [_statusScreenVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _statusScreenVC.view.tag = 18;

    [self.view addSubview:_statusScreenVC.view];
//    [_statusScreenVC didMoveToParentViewController:self];
//    [_statusScreenVC.view bringSubviewToFront:self.view];

}

-(void)chatBtnTapped
{
        ChatScreen *chvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatScreen"];
        [self.navigationController pushViewController:chvc animated:YES];
}
- (IBAction)menuAction:(id)sender
{
    [self showMenu];
}
@end
