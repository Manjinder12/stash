//
//  CommonFunctions.h
//  Bella_iOS
//
//  Created by Duke  on 20/12/16.
//  Copyright © 2016 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CommonFunctions : NSObject


+ (void)addButton:(NSString*)type InNavigationItem:(UINavigationItem*) navigationItem forNavigationController:(UINavigationController*) navigationController
       withTarget:(id) target
      andSelector:(SEL) selector ;

+ (void) showAlertWithTitle:(NSString*) alertTitle message:(NSString*) message cancelTitle:(NSString*) cancelTitle otherTitle:(NSString*) otherTitle tag:(NSInteger) tag delegate:(id) delegate withDelay:(float) delay onViewController:(UIViewController *)vc;

+(void)setUserDefault:(NSString *)key value:(id)value;

+(id)getUserDefaultValue:(NSString *)key;

+ (void)removeAllDefaults;

+ (BOOL) validateEmail: (NSString *) email;

+(BOOL)validateBellaPassword:(NSString *)password;
+(NSMutableArray *)createYearList;

+(BOOL) reachabiltyCheck;
+(void) showHUDWithLabel:(NSString *)messageLabel ForNavigationController:(UINavigationController*) navController;
+(void)removeActivityIndicator ;
+(void)removeActivityIndicatorFromViewController:(UIViewController *)controller;
+(void)showActivityIndicatorOnViewController:(UIViewController *)controller ;
+(void)showActivityIndicatorWithText:(NSString *)text ;

@end
