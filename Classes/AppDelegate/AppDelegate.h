//
//  AppDelegate.h
//  StashFin
//
//  Created by Mac on 19/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TIMERUIApplication.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "FILeftMenuViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id loginData;
@property (strong, nonatomic) id locData;
@property (strong, nonatomic) id cardData;
@property (strong, nonatomic) UIView *notificationView;
@property (strong, nonatomic) UILabel *lblNotificationBadge;
@property (strong, nonatomic) UIButton *notifcationButton;
@property (strong, nonatomic) FILeftMenuViewController *leftMenuReferenceVC;

+ (AppDelegate *)instance;
- (NSString *)getLatitude;
- (NSString *)getLongitude;
- (void)logoutUpdateUI;
- (void)navigateToHomeVC:(id)response;
- (void)showSessionExpiredAlertAndlogout;
- (void)updateLoginData:(id)responseObject;
-(void)updateCardData:(id)responseObject;
-(void)updateLOCData:(id)responseObject;
- (void)addNotificationButton;
- (UIViewController *)intializeViewController:(NSString *)viewControllerIdentifier;
- (void)navigateToCorrespondingScreenAfterLoginWithResponse:(id)response withController:(UIViewController *)vc;

@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) NSDate *appInBackgroundDateTime;
@property (nonatomic, strong) UINavigationController *homeNavigationControler;

#pragma mark - SocialTag for different social media
@property (nonatomic, readwrite) NSInteger socialTag;

#pragma mark - Facebook
@property (nonatomic, strong) NSMutableDictionary *socialLoginCredential;
@property (nonatomic, strong) FBSession *session;
- (void)getFacebookInfo;
- (void)clearFBSession;


#pragma mark - CLLocationManager
@property (nonatomic, strong) NSDictionary *gpsDictionary;
@property (nonatomic, strong) CLLocationManager *locationManager;


@end

