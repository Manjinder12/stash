//
//  ViewPDFViewController.h
//  StashFin
//
//  Created by Mac on 25/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPDFViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (strong, nonatomic) NSString* pdfURL;

@end
