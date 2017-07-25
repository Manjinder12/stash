//
//  CommonFunctions.m
//  Bella_iOS
//
//  Created by Duke  on 20/12/16.
//  Copyright © 2016 Duke. All rights reserved.
//

#import "CommonFunctions.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define APP_DELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@implementation CommonFunctions

#pragma mark - InputForms Methods


#pragma mark - Navigation Customization Methods

+ (void)addButton:(NSString*)type
              InNavigationItem:(UINavigationItem*) navigationItem
              forNavigationController:(UINavigationController*) navigationController
                           withTarget:(id) target
                          andSelector:(SEL) selector {
   
    UIImage *backImage;
    if ([type isEqualToString:@"back"]) {
         backImage = [UIImage imageNamed:@"back_arrow"];
    } else {
         backImage = [UIImage imageNamed:@"menu"];
    }
  
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,50, 44)];
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    
    if (target != nil && selector != nil) {
        [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    } else {
        [backButton addTarget:navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // backButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *barButtonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIButton *bell = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f,50, 44)];
    [bell setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];

    UIBarButtonItem *barbell = [[UIBarButtonItem alloc] initWithCustomView:bell];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20.f;
    
    [navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,barButtonBack,nil]];
    [navigationItem setRightBarButtonItem:barbell];

    
}

+(BOOL) reachabiltyCheck
{
    BOOL status =YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    
    // //DLog(@"reachabiltyCheck status  : %d",[reach currentReachabilityStatus]);
    
    if([reach currentReachabilityStatus]==0)
    {
        status = NO;
        //DLog(@"network not connected");
    }
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // blockLabel.text = @"Block Says Reachable";
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //  blockLabel.text = @"Block Says Unreachable";
        });
    };
    
    [reach startNotifier];
    return status;
}
+(BOOL)reachabilityChanged:(NSNotification*)note
{
    BOOL status =YES;
    
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //notificationLabel.text = @"Notification Says Reachable"
        status = YES;
        //DLog(@"NetWork is Available");
    }
    else
    {
        status = NO;
        /*
         CustomAlert *alert=[[CustomAlert alloc]initWithTitle:@"There was a small problem" message:@"The network doesn't seem to be responding, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         */
    }
    return status;
}



+ (void) showAlertWithTitle:(NSString*) alertTitle message:(NSString*) message cancelTitle:(NSString*) cancelTitle otherTitle:(NSString*) otherTitle tag:(NSInteger) tag delegate:(id) delegate withDelay:(float) delay onViewController:(UIViewController *)vc
{
    
    float delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
        UIAlertController *alert;
        
        NSString *alTitle = @"Bella";
        
        if(alTitle == nil || alTitle.length<=0)
            alTitle= @"";
        
        
        alert = [UIAlertController alertControllerWithTitle:alTitle message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:ok];
        
        [vc presentViewController:alert animated:YES completion:nil];
        
    });
}
/**
 *  Used to set user default key-value pair
 *
 *  @param key   : key
 *  @param value : value
 */
+(void)setUserDefault:(NSString *)key value:(id)value{
    if (key != nil && value != nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:key];
        [userDefaults setObject:value forKey:key];
        [userDefaults synchronize];
    }
}

/**
 *  Used to get user default key-value pair
 *
 *  @param key : key
 *
 *  @return : value
 */
+(id)getUserDefaultValue:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:key]) {
        return [userDefaults objectForKey:key];
    }
    return nil;
}


+ (void)removeAllDefaults {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL) validateEmail: (NSString *) email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+(BOOL)validateBellaPassword:(NSString *)password{
    NSString *passwordRegex = @"^.{6,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [predicate evaluateWithObject:password];
}


+ (NSMutableArray *)createYearList {
    NSMutableArray *yearArr = [[NSMutableArray alloc]init];
    NSString *yearStr = @"1950";
    [yearArr addObject:yearStr];
    int year = [yearStr intValue];
    
    while (year != 2020) {
        year++;
        [yearArr addObject:[NSString stringWithFormat:@"%d",year]];
    }
    return yearArr;
}

#pragma mark - HUD methods
+(void) showHUDWithLabel:(NSString *)messageLabel ForNavigationController:(UINavigationController*) navController
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    HUD.color = [UIColor colorWithRed:98/255.0f green:141/255.0f blue:225/255.0f alpha:1.0f];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.removeFromSuperViewOnHide = YES;
    
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage animatedImageWithImages:[NSArray arrayWithObjects:   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   [UIImage imageNamed:@"logo11"],
                                                                                                   nil] duration:1.0]];
    [customView startAnimating];
    HUD.customView = customView;
    
    if(messageLabel != nil) {
        HUD.labelText= messageLabel;
    }
    
    [HUD bringSubviewToFront:navController.view];
}
+ (void)removeActivityIndicator {
    [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
    [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
}
+ (void)removeActivityIndicatorFromViewController:(UIViewController *)controller {
    [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
    [MBProgressHUD hideHUDForView:controller.view animated:YES];
}
+ (void)showActivityIndicatorOnViewController:(UIViewController *)controller {
    [self removeActivityIndicator];
    
    [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
}


+ (void)showActivityIndicatorWithText:(NSString *)text {
    [self removeActivityIndicator];
    
    MBProgressHUD *hud   = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    hud.detailsLabelText = text;
}

@end
