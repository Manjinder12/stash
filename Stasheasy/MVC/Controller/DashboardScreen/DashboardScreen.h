//
//  DashboardScreen.h
//  Stasheasy
//
//  Created by Duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusScreen.h"
#import "Status2Screen.h"
#import "LineCreditVC.h"

@interface DashboardScreen : UIViewController
@property (nonatomic, strong) Status2Screen *status2ScreenVC ;
@property (nonatomic, strong) StatusScreen *statusScreenVC ;
@property (nonatomic, strong) LineCreditVC *lineCreditVC ;

@end
