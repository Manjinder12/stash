//
//  PaymentPageViewController.h
//  StashFin
//
//  Created by sachin khard on 15/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface PaymentPageViewController : UIViewController

@property (nonatomic, strong)NSDictionary *paymentInfoDic;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WKWebView *popupWebView;

@end
