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

@interface DashboardScreen : UIViewController
@property(nonatomic,strong)  Status2Screen *stVC ;
@property(nonatomic,strong) StatusScreen *sVC ;

@end
