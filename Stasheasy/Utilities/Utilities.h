//
//  Utilities.h
//  RossBrothers
//
//  Created by ammarali on 28/04/16.
//  Copyright © 2016 6degreesit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


@interface Utilities : NSObject

// Show alert for Response
+ (void)showAlertWithMessage:(NSString *)message;
+ (void)showMessage:alertText withTitle:alertTitle;

// Set Navigation Dictionary
+(NSDictionary *)setNavigationFontDictionary;

// Set Navigation Bar COlor
+(UIColor *)setNavigationBarColor;

// Date formatting Date to String
+(NSString *) Datefromstring: (NSDate *)stringDate byFormatter:(NSString *)formatter;

// Date formatting String to Date
+(NSDate *)stringToDate:(NSString *) stringDate byFormatter: (NSString *) formatter;

// Validation for Phone Number
+(BOOL)validatePhone:(NSString *)phoneNumber;

// Setc orner radius
+(void)setCornerRadius:(id)object;

// Set color from Hex string
+ (UIColor *)getColorFromHexString:(NSString *)hexString;

// Set Attributed string
+(NSAttributedString *)setAttributedTextForString:(NSString *)htmlString;

// Get json
+(NSDictionary *)getJsonDictionaryFromResponseString:(NSString *)responseString;
+ (BOOL) validate:(NSString *)string withField:(NSString *)filed;

// Get contact Number
+ (NSString *)getCallUsNumber;

// Set image compresison
+ (UIImage*)compressImageWithImage:(UIImage*)image
                      scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithColor:(UIColor *)color andBounds:(CGRect)imgBounds;

//Remove Duplicate items from Array
+ (NSArray *)getArrayWithoutDuplicateItems:(NSArray *)array;

// Resize UIImage keeping its Aspect ratio
+ (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width;

// Get formatted Image Url
+ (NSURL *)getFormattedImageURLFromString:(NSString *)string;

// Get Base64 Encoded String From UIImage
+ (NSString *)getBase64EncodedStringOfImage:(UIImage *)image;

// Set Border and Color
+(void)setBorderAndColor:(id)object;

// Set Button Ripple Effect

// Get navigation for a particula view controller
+ (UINavigationController *)getNavigationControllerForViewController:(UIViewController *)controller;

// Show Popup on View
+ (void)showPopupView:(UIView *)popupView onViewController:(UIViewController *)viewcontroller;

// Hide Popuo from View
+ (void)hidePopupView:(UIView *)popupView fromViewController:(UIViewController *)viewcontroller;

// Get number of lines of label
+ (CGFloat)getNumberOfLines:(UILabel *)label forText:(NSString *)text;

// Get label height
+ (CGFloat)getLabelHeight:(UILabel*)label;

// Pop to number of view controllers
+ (void) popToNumberOfControllers:(int)number withNavigation:(UINavigationController *)navigationController;

// Get Storyboard according to device
+ (UIStoryboard *)getStoryBoard;


// Check Internet Connection
//+ (BOOL)isInternetConnected;

//Navigate to a view controller by Identifier
+ (void)navigateToViewControllerWithIdentifier:(NSString *)identifier withNavigation:(UINavigationController *)navigation;

//Set UserDefault With Object and Key
+ (void)setUserDefaultWithObject:(id)object andKey:(NSString *)key;

//Get UserDefault Value From Key
+ (id)getUserDefaultValueFromKey:(NSString *)key;

// Get Device UDID
+ (NSString *)getDeviceUDID;

// Get VC from identifier
+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier;

// Get Base64 string of Image
+ (NSString *)getBase64StringOfImage:(UIImage *)image;


@end
