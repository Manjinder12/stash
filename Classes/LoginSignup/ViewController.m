//
//  ViewController.m
//  StashFin
//
//  Created by Mac on 19/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ViewController.h"
#import "ReferralCodeViewController.h"
#import "UIViewController+PopupViewController.h"
#import "EmailLoginViewController.h"
#import "LoginViaOTP.h"
#import "PreApprovedCardViewController.h"


@interface ViewController () <ReferralCodeVCDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [AppDelegate instance].homeNavigationControler = self.navigationController;
    
    if ([[ApplicationUtils getValue:LOGIN_STATUS] boolValue]) {
        [[AppDelegate instance] navigateToHomeVC:nil];
    }
    
    [self.signupLabel setFont:[ApplicationUtils GETFONT_BOLD:26]];
    [self.static1Label setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.static2Label setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [self.referralCodeButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    [self.cardButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:16]];
    [self.fbButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];
    [self.googleButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];
    [self.signupwithemailButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];
    [self.signinButton.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"Already registered with StashFin! " attributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    NSAttributedString *b = [[NSAttributedString alloc] initWithString:@"Sign In" attributes:@{
                                                                                               NSForegroundColorAttributeName : [UIColor blueColor],
                                                                                               NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                                                                               }];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] init];
    [mutableString appendAttributedString:a];
    [mutableString appendAttributedString:b];
    [self.signinButton setAttributedTitle:mutableString forState:UIControlStateNormal];

    [[GIDSignIn sharedInstance] signOut];
    [[AppDelegate instance] clearFBSession];
    
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.scopes = @[@"profile", @"email"];
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)referralCodeButtonAction:(id)sender {
    self.referralCodeButton.selected = !self.referralCodeButton.selected;
    self.cardButton.selected = NO;
}

- (IBAction)cardButtonAction:(id)sender {
    self.cardButton.selected = !self.cardButton.selected;
    self.referralCodeButton.selected = NO;
}

- (IBAction)signinButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"EmailLoginViewController" sender:nil];
}

- (IBAction)signupwithemailButtonAction:(id)sender {
    [self navigateToSignUpScreenWithSocialMedia:NO];
}

- (void)navigateToSignUpScreenWithSocialMedia:(BOOL)isSocialMedia {
    if (self.referralCodeButton.selected) {
        ReferralCodeViewController *obj = [[ReferralCodeViewController alloc] initWithNibName:@"ReferralCodeViewController" bundle:nil];
        [obj setDelegate:self];
        if (isSocialMedia) [obj setPrefilledDic:[AppDelegate instance].socialLoginCredential];
        [self presentPopupViewController:obj animationType:SKPopupViewAnimationFade];
    }
    else if (self.cardButton.selected) {
        PreApprovedCardViewController *obj = [[PreApprovedCardViewController alloc] initWithNibName:@"PreApprovedCardViewController" bundle:nil];
        if (isSocialMedia) [obj setPrefilledDic:[AppDelegate instance].socialLoginCredential];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else {
        LoginViaOTP *obj = [[LoginViaOTP alloc] init];
        [obj setIsFromRegisteration:YES];
        if (isSocialMedia) [obj setPrefilledDic:[AppDelegate instance].socialLoginCredential];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

#pragma mark - FACEBOOK

- (IBAction)fbButtonAction:(id)sender {
    MRProgressOverlayView *hud = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [hud setTitleLabelText:@"fb verification..."];
    
    [AppDelegate instance].socialTag = FACEBOOK_TAG;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_LOGIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbLoginSuccess:) name:FB_LOGIN_NOTIFICATION object:nil];
    
    [[AppDelegate instance] getFacebookInfo];
}

- (void)fbLoginSuccess:(NSNotification *)notification{
    NSDictionary *userInfo = notification.object;
    NSString *isSuccess = [userInfo objectForKey:@"isSuccess"];
    
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FB_LOGIN_NOTIFICATION object:nil];
    
    if ([isSuccess isEqualToString:@"YES"]) {
        [self navigateToSignUpScreenWithSocialMedia:YES];
    }
    else {
        [ApplicationUtils showMessage:@"fb verification failed." withTitle:@"" onView:self.view];
    }
}

#pragma mark - GOOGLE

-(IBAction)googleButtonAction:(id)sender {
    [ApplicationUtils setNavigationTitleAndButtonColorWithoutShadow:[UIColor blackColor]];
    [AppDelegate instance].socialTag = GOOGLE_TAG;
    [[GIDSignIn sharedInstance] setAllowsSignInWithWebView:NO];
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    if (error) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Sorry! Google could not fulfill this access request"];
        return;
    }
    [self saveGoogleUserInfo];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
}

- (void)saveGoogleUserInfo {
    if ([GIDSignIn sharedInstance].currentUser.authentication != nil) {
        
        [[AppDelegate instance].socialLoginCredential removeAllObjects];
        
        [[AppDelegate instance].socialLoginCredential setObject:@"gmail" forKey:SOCIAL_SOURCE];

        NSString *name = [GIDSignIn sharedInstance].currentUser.profile.name;
        NSArray *nameArray = [name componentsSeparatedByString:@" "];
        
        if ([nameArray count] > 0) {
            [[AppDelegate instance].socialLoginCredential setObject:[nameArray firstObject] forKey:FIRST_NAME_KEY];
        }
        else {
            [[AppDelegate instance].socialLoginCredential setObject:@"" forKey:FIRST_NAME_KEY];
        }
        if ([nameArray count] > 1) {
            [[AppDelegate instance].socialLoginCredential setObject:[nameArray lastObject] forKey:LAST_NAME_KEY];
        }
        else {
            [[AppDelegate instance].socialLoginCredential setObject:@"" forKey:LAST_NAME_KEY];
        }
        if ([GIDSignIn sharedInstance].currentUser.profile.email != nil) {
            [[AppDelegate instance].socialLoginCredential setObject:[GIDSignIn sharedInstance].currentUser.profile.email forKey:EMAIL_KEY];
        }
        else {
            [[AppDelegate instance].socialLoginCredential setObject:@"" forKey:EMAIL_KEY];
        }
        if ([GIDSignIn sharedInstance].currentUser.userID != nil) {
            [[AppDelegate instance].socialLoginCredential setObject:[GIDSignIn sharedInstance].currentUser.userID forKey:@"SOCIAL_ID"];
        }
        else {
            [[AppDelegate instance].socialLoginCredential setObject:@"" forKey:@"SOCIAL_ID"];
        }
        if ([GIDSignIn sharedInstance].currentUser.profile.hasImage) {
            NSUInteger dimension = round(80 * [[UIScreen mainScreen] scale]);
            NSURL *imageURL =   [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:dimension];
            
            // There is Profile Image to be loaded.
            [[AppDelegate instance].socialLoginCredential setObject:[imageURL absoluteString] forKey:PROFILE_IMAGE_KEY];
        }
        else {
            [[AppDelegate instance].socialLoginCredential setObject:@"" forKey:PROFILE_IMAGE_KEY];
        }
        
        [self navigateToSignUpScreenWithSocialMedia:YES];
    }
}

#pragma mark - ReferralCodeViewController Delegate

- (void)dismissClicked
{
    [self dismissPopupViewControllerWithanimationType:SKPopupViewAnimationFade];
}

@end
