//
//  GetCardViewController.m
//  StashFin
//
//  Created by sachin khard on 20/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "GetCardViewController.h"

@interface GetCardViewController ()

@end

@implementation GetCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.getCardLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.staticTextLabel setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.getCardButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Get Stashfin Card";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server Call

- (IBAction)getCardButtonAction:(id)sender {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"requestForCardExistingCustomer"                                                   forKey:@"mode"];
    [dictParam setValue:[ApplicationUtils validateStringData:[AppDelegate instance].loginData[@"phone"]]    forKey:@"phone_no"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:[ApplicationUtils validateStringData:response[@"msg"]] cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
                
                [[AppDelegate instance].leftMenuReferenceVC selectMenuActionWithIndex:0];
                
            }] otherButtonItems: nil];
            [[AlertViewManager sharedManager].alertView show];
        }
        else {
            [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"We have received your request, we will contact you shortly." cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
                
                [[AppDelegate instance].leftMenuReferenceVC selectMenuActionWithIndex:0];
                
            }] otherButtonItems: nil];
            [[AlertViewManager sharedManager].alertView show];
        }
    }];
}

@end
