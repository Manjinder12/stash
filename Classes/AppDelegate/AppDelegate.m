//
//  AppDelegate.m
//  StashFin
//
//  Created by Mac on 19/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SignupViewController.h"


@interface AppDelegate ()

@end

//Google------------------------------------------>>>>>>>>>>>>>>>>>>>>>>>>>>>
static NSString * const kClientID = @"442977242723-r19ab8bkrour713tacqifvruj2jo41nv.apps.googleusercontent.com";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] ignoreSnapshotOnNextApplicationLaunch];
    [self intializeKeyboardManager];
    self.socialLoginCredential = [[NSMutableDictionary alloc] init];
    
    // Set app's client ID for |GIDSignIn|.
    [GIDSignIn sharedInstance].clientID = kClientID;

    // CLLocationManager - Get User Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 5000.0; // Will notify the LocationManager every 5 kilo-meters
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    self.appInBackgroundDateTime = [NSDate date];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.appInBackgroundDateTime = [NSDate date];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    [self.imageView setImage:[UIImage imageNamed:@"LaunchImage"]];
    [UIApplication.sharedApplication.keyWindow.subviews.lastObject addSubview:self.imageView];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self.imageView removeFromSuperview];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];

    // If user is not using the app for more than xx minutes invalidate session
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.appInBackgroundDateTime]/60;
    NSUInteger timeoutvalue = kApplicationTimeoutInMinutes;
    
    if (interval >= timeoutvalue) {
        if ([[ApplicationUtils getValue:@"islogin"] intValue] == 1)
        {
            [self showSessionExpiredAlertAndlogout];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    self.locationManager = nil;
    [self.session close];
}

+ (AppDelegate *)instance {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark - Notification Button

-(void)addNotificationButton
{
    if (!self.notificationView) {
        self.notificationView = [[UIView alloc] initWithFrame:CGRectMake(self.window.frame.size.width - 55, 20, 45, 45)];
        [self.notificationView setBackgroundColor:[UIColor clearColor]];
        
        self.notifcationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.notifcationButton.frame = CGRectMake(0, 0, 45, 45);
        [self.notifcationButton addTarget:self action:@selector(notificationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.notifcationButton setImage:[UIImage imageNamed:@"notification"] forState:UIControlStateNormal];
        [self.notifcationButton setImage:[UIImage imageNamed:@"notificationwhite"] forState:UIControlStateHighlighted];

        self.lblNotificationBadge = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, 18, 18)];
        [self.lblNotificationBadge setHidden:YES];
        [self.lblNotificationBadge setTextColor:[UIColor whiteColor]];
        [self.lblNotificationBadge setFont:[ApplicationUtils GETFONT_BOLD:9]];
        [self.lblNotificationBadge setTextAlignment:NSTextAlignmentCenter];
        [self.notificationView addSubview:self.notifcationButton];
        [self.notificationView addSubview:self.lblNotificationBadge];
    }
}

- (void)notificationButtonAction:(id)sender {
    
}

- (void)showSessionExpiredAlertAndlogout {
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", nil) message:NSLocalizedString(@"Sorry! your session is timeout. Please login again.", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                              {
                                  [self logoutUpdateUI];
                              }];
    
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController *)intializeViewController:(NSString *)viewControllerIdentifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"    bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
}

#pragma mark - Logout Action

- (void)logoutUpdateUI {
    
    NSArray *viewContrlls = [[AppDelegate instance].homeNavigationControler viewControllers];
    
    for (UIViewController *objVC in viewContrlls) {
        if ([[objVC class] isEqual:[ViewController class]]) {
            //Send to login/signup screen
            [ApplicationUtils popToVCWithFadeAnimation:objVC andNavigationController:[AppDelegate instance].homeNavigationControler];
            [ApplicationUtils save:[NSNumber numberWithBool:NO] :LOGIN_STATUS];
            break;
        }
    }
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *altitude = @"";
    if(newLocation.verticalAccuracy > 0)
    {
        altitude = [NSString stringWithFormat:@"%f",newLocation.altitude];
    }
    
    NSString *speed = @"";
    if (newLocation.speed > 0) {
        speed = [NSString stringWithFormat:@"%f",newLocation.speed];
    }
    
    NSString *accuracy = @"";
    if (newLocation.altitude > 0) {
        accuracy = [NSString stringWithFormat:@"%f",newLocation.horizontalAccuracy];
    }
    
    NSString *timeStamp = @"";
    if (newLocation.timestamp > 0) {
        timeStamp = [NSString stringWithFormat:@"%lld",[@(floor([newLocation.timestamp timeIntervalSince1970])) longLongValue]];
    }
    
    self.gpsDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude],[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude],altitude, speed, accuracy, timeStamp, nil] forKeys:[NSArray arrayWithObjects:@"Latitude",@"Longitude",@"Altitude",@"Speed",@"Accuracy",@"TimeStamp", nil]];
    
    if ([[ApplicationUtils getValue:@"islogin"] intValue] == 1 && [ApplicationUtils getValue:@"auth_token"] != nil)
    {
        [self serverCallForUpdatingLocationOnServer];
    }
}

-(NSString *)getLatitude {
    if (self.gpsDictionary && [[self.gpsDictionary allKeys] count] > 0) {
        return [self.gpsDictionary objectForKey:@"Latitude"];
    }
    else {
        return @"";
    }
}

-(NSString *)getLongitude {
    if (self.gpsDictionary && [[self.gpsDictionary allKeys] count] > 0) {
        return [self.gpsDictionary objectForKey:@"Longitude"];
    }
    else {
        return @"";
    }
}

#pragma mark - service call to update location
- (void)serverCallForUpdatingLocationOnServer
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"customerPosition" forKey:@"mode"];
    
    NSArray *positions = [[NSArray alloc] initWithObjects:@{@"lati":[self getLatitude],@"longi":[self getLongitude],@"created_date":[ApplicationUtils getDateStringFromDate:[NSDate date] withOutputFormat:@"YYYY-MM-dd hh:mm:ss"]}, nil];
    [dictParam setValue:positions forKey:@"positions"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:self.window withCompletion:^(id response) {

    }];
}

#pragma mark - Handle Navigation After Login

- (void)navigateToCorrespondingScreenAfterLoginWithResponse:(id)response withController:(UIViewController *)vc {
    [ApplicationUtils save:[ApplicationUtils validateStringData:response[@"auth_token"]] :@"auth_token"];
    
    NSString *landingPage = [[ApplicationUtils validateStringData:response[@"landing_page"]] lowercaseString];
    NSString *loanStatus = [[ApplicationUtils validateStringData:response[@"latest_loan_details"][@"current_status"]] lowercaseString];
    
    if ([landingPage isEqualToString:@"basic"]) {
        [self navigateToSignUpScreenStep:1 withController:vc];
    }
    else if ([landingPage isEqualToString:@"professional"]) {
        [self navigateToSignUpScreenStep:2 withController:vc];
    }
    else if ([landingPage isEqualToString:@"bank"]) {
        [self navigateToSignUpScreenStep:3 withController:vc];
    }
    else if ([landingPage isEqualToString:@"document"]) {
        [self navigateToSignUpScreenStep:4 withController:vc];
    }
    else if ([landingPage isEqualToString:@"rejected"] || [loanStatus isEqualToString:@"rejected"]) {
        [self navigateToSignUpScreenStep:5 withController:vc];
    }
    else {
        [self navigateToHomeVC:response];
    }
}

- (void)navigateToSignUpScreenStep:(NSInteger)step withController:(UIViewController *)vc {
    SignupViewController *obj = [[SignupViewController alloc] init];
    [obj setLandingPage:step];
    [vc.navigationController popViewControllerAnimated:NO];
    [ApplicationUtils pushVCWithFadeAnimation:obj andNavigationController:[AppDelegate instance].homeNavigationControler];
}

- (void)navigateToHomeVC:(id)response
{
    if (response) {
        [self updateLoginData:response];
    }
    else {
        //Auto Login
        [self getLoginData];
    }
    [self getCardDetailsFromServer];
}

- (void)getCardDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"cardOverview"     forKey:@"mode"];
    
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.homeNavigationControler.view animated:YES];
    overlayView.titleLabelText = @"Please wait while we are refreshing your profile";

    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:nil withCompletion:^(id response) {
        if (![[response class] isSubclassOfClass:[NSString class]]) {
            [self updateCardData:response];
        }
        else {
            [self updateCardData:nil];
        }
        
        [self getLOCDetailsFromServer];
    }];
}

- (void)getLOCDetailsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"locDetails"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:nil withCompletion:^(id response) {
        if (![[response class] isSubclassOfClass:[NSString class]]) {
            [self updateLOCData:response];
        }
        else {
            [self updateLOCData:nil];
        }
        
        [MRProgressOverlayView dismissOverlayForView:self.homeNavigationControler.view animated:YES];

        [ApplicationUtils pushVCWithFadeAnimation:[[AppDelegate instance] intializeViewController:@"FIRootViewController"] andNavigationController:self.homeNavigationControler];
    }];
}

#pragma mark - IQKeyboardManager

- (void) intializeKeyboardManager {
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:25];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:NO];
}

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application            openURL:(NSURL *)url  sourceApplication:(NSString *)sourceApplication         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    if (self.socialTag == GOOGLE_TAG) {
        return [[GIDSignIn sharedInstance] handleURL:url    sourceApplication:sourceApplication     annotation:annotation];
    }
    else {
        return [FBAppCall handleOpenURL:url     sourceApplication:sourceApplication    withSession:self.session];
    }
}

-(void)clearFBSession{
    //Clear session
    [self.session closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
}

- (void) getFacebookInfo {
    if (!self.session.isOpen) {
        // create a fresh session object
        NSArray *permissionArray = [NSArray arrayWithObjects:@"email", @"user_birthday",@"user_photos", nil];
        self.session = [[FBSession alloc] initWithPermissions:permissionArray];
        [self.session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent
                     completionHandler:^(FBSession *session,
                                         FBSessionState state,
                                         NSError *error) {
                         // this handler is called back whether the login succeeds or fails; in the
                         // success case it will also be called back upon each state transition between
                         // session-open and session-close
                         
                         if (error) {
                             [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Sorry! Facebook server could not fulfill this access request"];
                             [[NSNotificationCenter defaultCenter] postNotificationName:FB_LOGIN_NOTIFICATION object:[NSDictionary dictionaryWithObject:@"NO" forKey:@"isSuccess"]];
                             return;
                         }
                         [self getFacebookUserDetails];
                     }];
    }
    else {
        [self getFacebookUserDetails];
    }
}

- (void) getFacebookUserDetails {
    FBRequest *me = [[FBRequest alloc] initWithSession:self.session
                                             graphPath:@"me" parameters:@{@"fields" : @"email,name,gender,birthday,first_name,last_name,picture"} HTTPMethod:@"GET"];
    
    [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                     NSDictionary<FBGraphUser> *user,
                                     NSError *error) {
        // because we have a cached copy of the connection, we can check
        // to see if this is the connection we care about; a prematurely
        // cancelled connection will short-circuit here
        
        // we interpret an error in the initial fetch as a reason to
        // fail the user switch, and leave the application without an
        // active user (similar to initial state)
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FB_LOGIN_NOTIFICATION object:[NSDictionary dictionaryWithObject:@"NO" forKey:@"isSuccess"]];
            return;
        }
        [self setFacebookLoginCredential:user];
    }];
}

- (void) setFacebookLoginCredential:(NSDictionary *) user {
    //  NSLog(@"user = %@",user);
    
    if (user != nil) {
        [self.socialLoginCredential removeAllObjects];
        
        [self.socialLoginCredential setObject:@"facebook" forKey:SOCIAL_SOURCE];

        if (self.session.accessTokenData != nil) {
            [self.socialLoginCredential setObject:self.session.accessTokenData forKey:ACCESS_TOKEN];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:ACCESS_TOKEN];
        }
        
        if ([user objectForKey:@"email"] != nil) {
            [self.socialLoginCredential setObject:[user objectForKey:@"email"] forKey:EMAIL_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:EMAIL_KEY];
        }
        
        if ([user objectForKey:@"id"] != nil) {
            [self.socialLoginCredential setObject:[user objectForKey:@"id"] forKey:SOCIAL_ID];
            [self.socialLoginCredential setObject:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[user objectForKey:@"id"]] forKey:PROFILE_IMAGE_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:SOCIAL_ID];
            [self.socialLoginCredential setObject:@"" forKey:PROFILE_IMAGE_KEY];
        }
        
        if ([user objectForKey:@"first_name"] != nil) {
            [self.socialLoginCredential setObject:[user objectForKey:@"first_name"] forKey:FIRST_NAME_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:FIRST_NAME_KEY];
        }
        
        if ([user objectForKey:@"last_name"] != nil) {
            [self.socialLoginCredential setObject:[user objectForKey:@"last_name"] forKey:LAST_NAME_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:LAST_NAME_KEY];
        }
        
        if ([user objectForKey:@"name"] != nil) {
            [self.socialLoginCredential setObject:[user objectForKey:@"name"] forKey:USERNAME_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:USERNAME_KEY];
        }
        
        if ([user objectForKey:@"gender"] != nil) {
            [self.socialLoginCredential setObject:[user objectForKey:@"gender"] forKey:GENDER_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:GENDER_KEY];
        }
        
        if ([user objectForKey:@"birthday"] != nil) {
            NSString *dateStr = [ApplicationUtils getRespectiveDateString:[user objectForKey:@"birthday"] withOutputFormat:DATE_FORMAT_DOB];
            [self.socialLoginCredential setObject:dateStr forKey:DOB_KEY];
        }
        else {
            [self.socialLoginCredential setObject:@"" forKey:DOB_KEY];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FB_LOGIN_NOTIFICATION object:[NSDictionary dictionaryWithObject:@"YES" forKey:@"isSuccess"]];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FB_LOGIN_NOTIFICATION object:[NSDictionary dictionaryWithObject:@"NO" forKey:@"isSuccess"]];
    }
}


-(void)updateCardData:(id)responseObject {
    if (responseObject && [[responseObject class] isSubclassOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        id responseData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
        
        [ApplicationUtils save:responseData :CARD_DATA];
        self.cardData = responseObject;
    }
    else {
        self.cardData = nil;
        [ApplicationUtils save:nil :CARD_DATA];
    }
}

-(void)updateLOCData:(id)responseObject {
    if (responseObject && [[responseObject class] isSubclassOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        id responseData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
        
        [ApplicationUtils save:responseData :LOC_DATA];
        self.locData = responseObject;
    }
    else {
        self.locData = nil;
        [ApplicationUtils save:nil :LOC_DATA];
    }
}

-(void)updateLoginData:(id)responseObject {
    if (responseObject && [[responseObject class] isSubclassOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        id responseData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
        
        [ApplicationUtils save:responseData :LOGIN_DATA];
        self.loginData = responseObject;
    }
    else {
        self.loginData = nil;
        [ApplicationUtils save:nil :LOGIN_DATA];
    }
}

- (void)getLoginData {
    id responseObject = [ApplicationUtils getValue:LOGIN_DATA];
    
    if (responseObject && [[responseObject class] isSubclassOfClass:[NSData class]]) {
        NSError *error = nil;
        self.loginData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    }
}

@end
