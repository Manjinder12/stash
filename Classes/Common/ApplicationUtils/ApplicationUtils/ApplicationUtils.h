//
//  ApplicationUtils.h
//  StashFin
//
//  Created by Mac on 14/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationUtils : NSObject

+ (NSString*) sha1:(NSString*)input;
+ (NSString *)sha256:(NSString *)input;
+ (NSString *) md5:(NSString *) input;
+ (UIImage *)placeholderImage;
+ (void) save :(id)value :(NSString *)key;
+ (id) getValue:(NSString *)key;
+ (void) remove: (NSString *)key;
+ (NSString*)getDeviceID;

+ (float)calculateCellTextHeight:(NSString *)text RectSize:(CGSize)rect font:(UIFont *)font;
+ (float)calculateCellTextWidth:(NSString *)text RectSize:(CGSize)rect font:(UIFont *)font;
+ (void)showCameraPermissionAlert;
+ (void)showPhotosPermissionAlert;
+ (void)showMessage:(NSString *)text withTitle:(NSString *)title onView:(UIView *)view;
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (void)showAlertAndNavigateToPrevScreenWithMessage:(NSString *)msg withController:(UIViewController *)vc;
+ (void)showOfflineAlert;
+ (UIImage *)normalizedImage:(UIImage *)img;
+ (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;
+ (NSString *)encodeToBase64String:(UIImage *)image compressionQuality:(float)quality;
+ (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio;
+ (NSString *)stringByFormattingAsCreditCardNumber:(NSString *)string;

+ (BOOL)checkForReachabilityMode;
+ (NSString *)formatString:(double)value;
+ (NSString *)formatCurrency:(NSString *)amount andCurrency:(NSString *)currency;

#pragma - Fonts
+(UIFont *)GETFONT_CONDENSED_BLACK:(int)sizeOfFont;
+(UIFont *)GETFONT_CONDENSED_BOLD:(int)sizeOfFont;
+(UIFont *)GETFONT_LIGHT :(int)sizeOfFont;
+(UIFont *)GETFONT_MEDIUM :(int)sizeOfFont;
+(UIFont *)GETFONT_REGULAR :(int)sizeOfFont;
+(UIFont *)GETFONT_BOLD :(int)sizeOfFont;
+(UIFont *)GETFONT_ITALIC :(int)sizeOfFont;
+(UIFont *)GETFONT_LIGHT_ITALIC :(int)sizeOfFont;
+(UIFont *)GETFONT_MEDIUM_ITALIC :(int)sizeOfFont;
+(UIFont *)GETFONT_BOLD_ITALIC :(int)sizeOfFont;

+ (void)setDOBMinMaxValue:(UIDatePicker *)datePicker;
+ (int)dateDifferenceFromDate:(NSDate *) fromDate andToDate:(NSDate *)toDate;
+ (NSString *)getDateStringFromDate:(NSDate *)date withOutputFormat:(NSString *)outputFormat;
+ (NSString *)getRespectiveDateString:(NSString*)dateString withOutputFormat:(NSString *)format;
+ (NSDate *)getRespectiveDate:(NSString*)dateString;
+ (NSDate *)dateAfterAddingMinutes:(int)minutes withInputDate:(NSDate *)inputDate;

+ (UIImage *)createDropDownImageForSize:(CGSize)newSize;
+ (void)setSearchBarProperties:(UISearchBar *)searchBar;
+(void)setSearchFieldProperties:(UITextField *)searchTxtField;
+ (void)setButtonProperties:(UIButton *)button;
+ (void)setAlignmentOfButton:(UIButton *)button;
+ (NSString *)validateStringData:(id)data;
+ (void)decodeHtmlString:(NSString *)str :(void (^)(NSString *))completion;

+ (void)hideShowViewWithView:(UIView *)view alpha:(float)value;
+ (void)pushVCWithFadeAnimation:(UIViewController *)vc andNavigationController:(UINavigationController *)nc;
+ (void)popVCWithFadeAnimation:(UINavigationController *)nc;
+ (void)popToVCWithFadeAnimation:(UIViewController *)vc andNavigationController:(UINavigationController *)nc;
+ (void)fadeInOutView:(float)value duration:(NSTimeInterval)time view:(UIView *)targetView;

+ (void)setNavigationTitleAndButtonColorWithNavigationBar:(UINavigationBar *)navigationBar withHeaderColor:(UIColor *)headercolor;
+ (void)setNavigationTitleAndButtonColorWithoutShadow:(UIColor *)color;
+ (void)setTintColorForNavigationBackButton:(UIColor *)color;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromRGBData:(NSDictionary *)rgbDic;
+ (NSString *)hexStringFromRGBData:(NSDictionary *)rgbDic;
+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIImage *)getRoundedImage:(float)height withImage:(UIImage *)image;
+ (void)insertBackgroundGradientLayer:(UIView *)bgView withFrame:(CGRect)frame;
+ (void)setFieldViewProperties:(UIView *)view;
+ (void)hideGreenCheckImageFromFieldView:(UIView *)view shouldHide:(BOOL)hide;

@end
