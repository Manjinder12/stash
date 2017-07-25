//
//  TransactionDetailsViewController.m
//  Stasheasy
//
//  Created by tushar on 20/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "TransactionDetailsViewController.h"
#import "TransactionScreen.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"
#import "TransactionList.h"
#import "AnalyzeScreen.h"

@interface TransactionDetailsViewController () {
    int tab;
    UIViewController *currentController;
}

@property (weak, nonatomic) IBOutlet UILabel *perLbl;
@property (weak, nonatomic) IBOutlet UILabel *proLbl;
@property (weak, nonatomic) IBOutlet UILabel *docLbl;

@property (weak, nonatomic) IBOutlet UIButton *professionalBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation TransactionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Account Overview";
    [CommonFunctions addButton:@"menu" InNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(showMenu)];
    // show account Overview
    [self addTrasactionScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction Methods

- (IBAction)personalTapped:(id)sender {
    tab =0;
    self.mainView.hidden =NO;

    self.perLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.personalBtn.titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.professionalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.docBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    TransactionScreen *stVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionScreen"];
    [self changeTransitionWithViewController:stVC];

}

- (IBAction)professionalTapped:(id)sender {
    tab =1;
    self.perLbl.backgroundColor = [UIColor clearColor];
    self.personalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.docBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.proLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    [self.professionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.professionalBtn setTitleColor:[UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

    // show transaction list
    TransactionList *tlist = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionList"];
    [self changeTransitionWithViewController:tlist];
    
}

- (IBAction)documenttapped:(id)sender {
    tab =2;

//    self.mainView.hidden =YES;

    self.perLbl.backgroundColor = [UIColor clearColor];
    self.personalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.professionalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    [self.docBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.docBtn setTitleColor:[UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    AnalyzeScreen *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalyzeScreen"];
    [self changeTransitionWithViewController:avc];

}


#pragma mark - Instance Methods

-(void)addTrasactionScreen {
        TransactionScreen *stVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionScreen"];
        [self addChildViewController:stVC];
        [stVC.view setFrame:CGRectMake(0,0,CGRectGetWidth(self.mainView.frame),CGRectGetHeight(self.mainView.frame))] ;
        [self.mainView addSubview:stVC.view];
        [stVC didMoveToParentViewController:self];
        currentController  = stVC;
}

-(void)changeTransitionWithViewController:(UIViewController *)NewVC  {
    [self removeOldViewController];
    [self addChildViewController:NewVC];
    [NewVC.view setFrame:CGRectMake(0,0,CGRectGetWidth(self.mainView.frame),CGRectGetHeight(self.mainView.frame))] ;
    [self.mainView addSubview:NewVC.view];
    [NewVC didMoveToParentViewController:self];
    currentController  = NewVC;
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

-(void)removeOldViewController {
    if (currentController) {
        [currentController willMoveToParentViewController:nil];
        [currentController.view removeFromSuperview];
        [currentController removeFromParentViewController];
    }
}

- (IBAction)menuAction:(id)sender
{
    [self showMenu];
}
@end
