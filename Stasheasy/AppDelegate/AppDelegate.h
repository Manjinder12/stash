//
//  AppDelegate.h
//  Stasheasy
//
//  Created by Duke on 31/05/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pickers.h"
#import "ServerCall.h"
#import "Utilities.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *stateid;
@property (strong,nonatomic) NSString *cityId;
@property (strong,nonatomic) NSString *stateName;
@property (strong,nonatomic) NSString *cityName;
@property (strong,nonatomic) NSString *residencePin;

@property NSDictionary *dictOverview, *dictTransaction,*dictAnalyze;

@end

