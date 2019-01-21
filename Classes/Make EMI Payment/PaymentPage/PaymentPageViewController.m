//
//  PaymentPageViewController.m
//  StashFin
//
//  Created by sachin khard on 15/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "PaymentPageViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "HomeViewController.h"


@interface PaymentPageViewController ()<WKNavigationDelegate, WKUIDelegate>

@end

@implementation PaymentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptEnabled = TRUE;
    preferences.javaScriptCanOpenWindowsAutomatically = TRUE;

    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.preferences = preferences;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [AppDelegate instance].window.frame.size.width, [AppDelegate instance].window.frame.size.height) configuration:configuration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"razorPay"                                                                                 forKey:@"mode"];
    [dictParam setValue:[ApplicationUtils validateStringData:[AppDelegate instance].locData[@"next_emi_amount"]]    forKey:@"amount"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:[AppDelegate instance].window withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            // Turn on network activity indicator upon starting web view load
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:response[@"url"]]]]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Payment";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Back Button Handller

- (BOOL)navigationShouldPopOnBackButton
{
    [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Your payment is under process. Do you want to go back?" cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"Yes", nil) action:^{
        
        [self navigateToHome];

    }] otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"No", nil) action:nil], nil];
    [[AlertViewManager sharedManager].alertView show];
    
    return NO;
}

- (void)navigateToHome {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HomeViewController class]]) {
            [(HomeViewController *)obj getLOCDetailsFromServer];
            [self.navigationController popToViewController:obj animated:NO];
        }
    }];
}

#pragma mark - WKUIDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    self.popupWebView = [[WKWebView alloc] initWithFrame:self.webView.frame configuration:configuration];
    self.popupWebView.UIDelegate = self;
    self.popupWebView.navigationDelegate = self;
    [self.view addSubview:self.popupWebView];

    return self.popupWebView;
}

- (void)webViewDidClose:(WKWebView *)webView {
    if (webView == self.popupWebView) {
        [self.popupWebView removeFromSuperview];
        self.popupWebView = nil;
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    if(navigationAction.navigationType == WKNavigationTypeOther)
    {
        NSString *url = [[navigationAction.request URL] absoluteString];

        //prevent loading URL if it is the redirectURL
        BOOL handlingRedirectURL = [url hasSuffix:[ApplicationUtils validateStringData:self.paymentInfoDic[@"return_url"]]];
        
        if (handlingRedirectURL) {
            [self navigateToHome];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // Turn off network activity indicator upon failure to load web view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
