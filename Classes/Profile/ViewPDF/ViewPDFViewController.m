//
//  ViewPDFViewController.m
//  StashFin
//
//  Created by Mac on 25/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "ViewPDFViewController.h"

@interface ViewPDFViewController ()

@end

@implementation ViewPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.pdfWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:self.pdfURL]]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Turn off network activity indicator upon failure to load web view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // Turn off network activity indicator upon finishing web view load
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
