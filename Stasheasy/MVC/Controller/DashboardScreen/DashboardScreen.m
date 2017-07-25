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

@interface DashboardScreen ()  {
   }

@end

@implementation DashboardScreen

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Dashboard";
    [CommonFunctions addButton:@"menu" InNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(showMenu)];
    [self addStatusScreen];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showThirdStep) name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStatusScreen) name:@"change3" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatBtnTapped) name:@"chat" object:nil];

}

//-(void)viewWillDisappear:(BOOL)animated {
//
//}

-(void)dealloc {
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

-(void)addStatusScreen {
    UIView *viewToRemove = [self.view viewWithTag:18];
    if (viewToRemove) {
        [viewToRemove removeFromSuperview];

    }

    _stVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"Status2Screen"];
//    [self addChildViewController:_stVC];
    [_stVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _stVC.view.tag = 17;
    [self.view addSubview:_stVC.view];
//    [_stVC didMoveToParentViewController:self];
//    TransactionScreen *stVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionScreen"];
//    [self addChildViewController:stVC];
//    [stVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:stVC.view];
//    [stVC didMoveToParentViewController:self];

}

-(void)showThirdStep {
    
//    [_stVC willMoveToParentViewController:nil];
    //[_stVC.view removeFromSuperview];
//    [_stVC removeFromParentViewController];
    UIView *viewToRemove = [self.view viewWithTag:17];
    [viewToRemove removeFromSuperview];
    
    _sVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusScreen"];
//    [self addChildViewController:_sVC];
    [_sVC.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _sVC.view.tag = 18;

    [self.view addSubview:_sVC.view];
//    [_sVC didMoveToParentViewController:self];
//    [_sVC.view bringSubviewToFront:self.view];

}

-(void)chatBtnTapped {
        ChatScreen *chvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatScreen"];
        [self.navigationController pushViewController:chvc animated:YES];
}
@end
