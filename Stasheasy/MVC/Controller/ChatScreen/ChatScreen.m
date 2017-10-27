//
//  ChatScreen.m
//  Stasheasy
//
//  Created by Tushar  on 21/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ChatScreen.h"
#import "ChatLeftCell.h"
#import "RightChatCell.h"
#import "CommonFunctions.h"
#import "REFrostedViewController.h"
#import <LGPlusButtonsView/LGPlusButtonsView.h>
#import "AppDelegate.h"

@interface ChatScreen ()<LGPlusButtonsViewDelegate>
{
    LGPlusButtonsView *stashfinButton;
    BOOL isStashExpand;
}
@property (weak, nonatomic) IBOutlet UITableView *tblChat;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;


@end

@implementation ChatScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
    
    self.navigationItem.title = @"Chat";
    
    UIImage *backImage = [UIImage imageNamed:@"back_arrow"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,50, 44)];
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // backButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *barButtonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20.f;

    UIImageView *leftBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"sampleimg"]];
    leftBtn.layer.cornerRadius = 20;
    leftBtn.clipsToBounds =YES;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,barButtonBack,leftBtnItem,nil]];

}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    
    _tblChat.hidden = YES;
    _lblMessage.hidden = NO;
    
//    [self addStashFinButtonView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark LGPlusButtonsView
- (void)addStashFinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:5 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    //stashfinButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    stashfinButton.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    stashfinButton.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    
    [stashfinButton setDescriptionsTexts:@[@"", @"Lost/Stolan Card", @"Change Pin", @"Reload Card",@"Chat"]];
    
    [stashfinButton setButtonsImages:@[[UIImage imageNamed:@"actionBtn"], [UIImage imageNamed:@"lostCardBtn"], [UIImage imageNamed:@"pinBtn"], [UIImage imageNamed:@"topupcardBtn"] ,[UIImage imageNamed:@"chatBtn"]]
                            forState:UIControlStateNormal
                      forOrientation:LGPlusButtonsViewOrientationAll];
    if ([[self.storyboard valueForKey:@"name"] isEqual:@"iPhone"])
    {
        [stashfinButton setButtonsSize:CGSizeMake(60.f, 60.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:60.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:16] forOrientation:LGPlusButtonsViewOrientationAll];
    }
    else
    {
        [stashfinButton setButtonsSize:CGSizeMake(90.f, 90.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:90.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:26.0] forOrientation:LGPlusButtonsViewOrientationAll];
    }
    
    [stashfinButton setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    // [stashfinButton setButtonsLayerShadowColor:[UIColor whiteColor]];
    [stashfinButton setButtonsLayerShadowOpacity:0.5];
    [stashfinButton setButtonsLayerShadowRadius:3.f];
    [stashfinButton setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    
    [stashfinButton setDescriptionsTextColor:[UIColor whiteColor]];
    [stashfinButton setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [stashfinButton setDescriptionsLayerShadowOpacity:0.25];
    [stashfinButton setDescriptionsLayerShadowRadius:1.f];
    [stashfinButton setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [stashfinButton setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    //[stashfinButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [stashfinButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) forOrientation:LGPlusButtonsViewOrientationAll];
    
    [self.view addSubview:stashfinButton];
}
#pragma mark LGPlusButtonsView Delegate
- (void)plusButtonsViewDidHideButtons:(LGPlusButtonsView *)plusButtonsView
{
    isStashExpand = NO;
}
- (void)plusButtonsView:(LGPlusButtonsView *)plusButtonsView buttonPressedWithTitle:(NSString *)title description:(NSString *)description index:(NSUInteger)index
{
    if (index == 0)
    {
        //        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
        //         {
        //             isStashExpand = NO;
        //         }];
    }
    else if (index == 1)
    {
        // Lost Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"LostStolenVC"];
         }];
    }
    else if (index == 2)
    {
        // Reload Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"ChangePinVC"];
         }];
    }
    else if (index == 3)
    {
        // Change Pin
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            [self navigateToViewControllerWithIdentifier:@"ReloadCardVC"];
        }];
    }
    else
    {
        //Chat
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"ChatScreen"];
         }];
    }
}
- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *vc = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ChatLeftCell";
    if (indexPath.row ==0) {
        ChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            [self.tblChat registerNib:[UINib nibWithNibName:@"ChatLeftCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }
    else {
        static NSString *simpleTableIdentifier = @"RightChatCell";

        RightChatCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            [self.tblChat registerNib:[UINib nibWithNibName:@"RightChatCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
