//
//  ApplicationUtils.m
//  StashFin
//
//  Created by Mac on 14/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "ApplicationUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonKeyDerivation.h>


@implementation ApplicationUtils


+ (NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)sha256:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:strlen(cstr)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    
    CC_SHA256(keyData.bytes, (unsigned int)keyData.length, digest);
    
    NSString *hash = [[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH] description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString*)getDeviceID{
    UIPasteboard *myPasteboard = [UIPasteboard pasteboardWithName:@"uuidSFPasteboard" create:NO];
    NSString *uuid = myPasteboard.string;
    
    if (!uuid) {
        NSString *fifteenDigitNumberString = [[NSNumber numberWithInt:1 + arc4random_uniform(9)] stringValue];
        for (int i = 0; i < 14; i++) {
            fifteenDigitNumberString = [fifteenDigitNumberString stringByAppendingString:[[NSNumber numberWithInt:arc4random_uniform(10)] stringValue]];
        }
        
        uuid = fifteenDigitNumberString;
        UIPasteboard *myPasteboard = [UIPasteboard pasteboardWithName:@"uuidSFPasteboard" create:YES];
        [myPasteboard setString:uuid];
    }
    return uuid;
}

+ (float)calculateCellTextHeight:(NSString *)text RectSize:(CGSize)rect font:(UIFont *)font {
    CGRect frame = [text boundingRectWithSize:rect
                                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                              attributes:@{NSFontAttributeName:font}
                                                                 context:nil];
    
    return frame.size.height;
}

+ (float)calculateCellTextWidth:(NSString *)text RectSize:(CGSize)rect font:(UIFont *)font {
    CGRect frame = [text boundingRectWithSize:rect
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    return frame.size.width;
}

+ (void) showCameraPermissionAlert {
    [ApplicationUtils showAlertWithTitle:NSLocalizedString(@"Permission Error", nil) andMessage:NSLocalizedString(@"Please allow application to access camera in privacy settings.", nil)];
}

+ (void) showPhotosPermissionAlert {
    [ApplicationUtils showAlertWithTitle:NSLocalizedString(@"Permission Error", nil) andMessage:NSLocalizedString(@"Please allow application to access photos in privacy settings.", nil)];
}

+ (void)showMessage:(NSString *)text withTitle:(NSString *)title onView:(UIView *)view {
    if ([[ApplicationUtils validateStringData:text] length]) {
        [MRProgressOverlayView showOverlayAddedTo:view title:text mode:MRProgressOverlayViewModeIndeterminateSmallDefault animated:YES];
        
        // Delay execution of my block for 2 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [MRProgressOverlayView dismissOverlayForView:view animated:NO];
        });
    }
}

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    if ([[ApplicationUtils validateStringData:message] length]) {
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

+ (void)showOfflineAlert {
    [ApplicationUtils showAlertWithTitle:NSLocalizedString(@"", nil) andMessage:NSLocalizedString(@"This functionality is not available in offline mode. Please try again later", nil)];
}

+ (void)showAlertAndNavigateToPrevScreenWithMessage:(NSString *)msg withController:(UIViewController *)vc{
    [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:msg
                                                                     cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
        
        //Send to previous screen
        [ApplicationUtils popVCWithFadeAnimation:vc.navigationController];
        
    }] otherButtonItems: nil];
    [[AlertViewManager sharedManager].alertView show];
}

+ (NSString *)formatString:(double)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

+(CGFloat)GETFONTSIZE:(CGFloat)fontSize {
    switch((NSInteger)UIScreen.mainScreen.bounds.size.height) {
        case 480:
            return fontSize-5;
            
        case 568:
            return fontSize-4;
            
        case 667:
            return fontSize-3;
            
        case 736:
            return fontSize-2;
            
        case 812:
            return fontSize-2;

        case 1024:
            return fontSize;
            
        case 1366:
            return fontSize+1;
            
        default:
            return fontSize;
    }
}

+(UIFont *)GETFONT_CONDENSED_BLACK:(int)sizeOfFont {
    return [UIFont fontWithName:@"AvenirNextLTPro-HeavyCn" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_CONDENSED_BOLD:(int)sizeOfFont {
    return [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_LIGHT :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-UltLt" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_MEDIUM :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-Medium" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_REGULAR :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_BOLD :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-Bold" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_LIGHT_ITALIC :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-UltLtIt" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_MEDIUM_ITALIC :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-MediumIt" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_BOLD_ITALIC :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-BoldIt" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+(UIFont *)GETFONT_ITALIC :(int)sizeOfFont
{
    return [UIFont fontWithName:@"AvenirNextLTPro-It" size:[ApplicationUtils GETFONTSIZE:sizeOfFont]];
}

+ (void)setSearchBarProperties:(UISearchBar *)searchBar {
    searchBar.barTintColor = BUTTON_BG_COLOR;
    searchBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    searchBar.layer.borderWidth = 1.0;

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[ApplicationUtils GETFONT_LIGHT:16]];

    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]      setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                                                                             forState:UIControlStateNormal];
}

+(void)setSearchFieldProperties:(UITextField *)searchTxtField {
    [searchTxtField setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    searchTxtField.backgroundColor = TEXT_BG_COLOR;
    searchTxtField.returnKeyType = UIReturnKeySearch;
    searchTxtField.layer.cornerRadius = 3;
    [searchTxtField setTextAlignment:NSTextAlignmentLeft];
    [searchTxtField setBorderStyle:UITextBorderStyleNone];
    [searchTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    searchTxtField.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0);
}

+ (void)setButtonProperties:(UIButton *)button {
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 1;
    [button.titleLabel setFont:[self GETFONT_MEDIUM:16]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setBorderColor:[UIColor clearColor].CGColor];
}

+ (void)setAlignmentOfButton:(UIButton *)button {
    // the space between the image and text
    CGFloat spacing = 2.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

+ (UIImage *)getRoundedImage:(float)height withImage:(UIImage *)image{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(height, height), NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, height, height)   cornerRadius:height/2] addClip];
    // Draw your image
    [image drawInRect:CGRectMake(0, 0, height, height)];
    
    // Get the image, here setting the UIImageView image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    return img;
}

+ (BOOL)checkForReachabilityMode
{
    if (![UIDevice networkAvailable]) {
        [ApplicationUtils showOfflineAlert];
        return NO;
    }
    return YES;
}

+ (UIImage *)createDropDownImageForSize:(CGSize)newSize {
    UIImage *image       = [UIImage imageNamed:@"P-PreDropDown.png"];
    UIImage *image1      = [UIImage imageNamed:@"P-MidDropDown.png"];
    UIImage *image2      = [UIImage imageNamed:@"P-PostDropDown.png"];
    
    UIGraphicsBeginImageContext(newSize);
    
    float image1Width = newSize.width - (image.size.width/2) - (image2.size.width/2);
    
    // Apply supplied opacity if applicable
    [image drawInRect:CGRectMake(0,0,image.size.width/2,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    [image1 drawInRect:CGRectMake(image.size.width/2,0,image1Width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    [image2 drawInRect:CGRectMake((image1Width+image.size.width/2),0,image2.size.width/2,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    double newCropWidth, newCropHeight;
    
    //=== To crop more efficently =====//
    if(image.size.width < image.size.height){
        if (image.size.width < size.width) {
            newCropWidth = size.width;
        }
        else {
            newCropWidth = image.size.width;
        }
        newCropHeight = (newCropWidth * size.height)/size.width;
    } else {
        if (image.size.height < size.height) {
            newCropHeight = size.height;
        }
        else {
            newCropHeight = image.size.height;
        }
        newCropWidth = (newCropHeight * size.width)/size.height;
    }
    //==============================//
    
    double x = image.size.width/2.0 - newCropWidth/2.0;
    double y = image.size.height/2.0 - newCropHeight/2.0;
    
    CGRect cropRect = CGRectMake(x, y, newCropWidth, newCropHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (void)setDOBMinMaxValue:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMATTER;
    
    [datePicker setMinimumDate:[dateFormatter dateFromString:@"01-Jan-1900"]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.year = - 18;
    [datePicker setMaximumDate:[calendar dateByAddingComponents:addComponents toDate:[NSDate date] options:0]];
    dateFormatter = nil;
}

+ (NSDate *)dateAfterAddingMinutes:(int)minutes withInputDate:(NSDate *)inputDate{
    NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
    [offsetComponents1 setMinute:minutes];
    return [gregorian1 dateByAddingComponents:offsetComponents1 toDate:inputDate options:0];
}

+ (NSString *)getRespectiveDateString:(NSString*)dateString withOutputFormat:(NSString *)format
{
    NSDate *date = nil;
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
                                                               error:&error];
    NSArray *matches = [detector matchesInString:dateString
                                         options:0
                                           range:NSMakeRange(0, [dateString length])];
    for (NSTextCheckingResult *match in matches) {
        if (match.date) {
            date = match.date;
            break;
        }
    }
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    
    return [dateformatter stringFromDate:date];
}

+ (NSDate *)getRespectiveDate:(NSString*)dateString
{
    NSDate *date = nil;
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
                                                               error:&error];
    NSArray *matches = [detector matchesInString:dateString
                                         options:0
                                           range:NSMakeRange(0, [dateString length])];
    for (NSTextCheckingResult *match in matches) {
        if (match.date) {
            date = match.date;
            break;
        }
    }
    return date;
}

+ (NSString *)getDateStringFromDate:(NSDate *)date withOutputFormat:(NSString *)outputFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:outputFormat];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    dateFormatter = nil;
    return formattedDate;
}

+ (int)dateDifferenceFromDate:(NSDate *) fromDate andToDate:(NSDate *)toDate {
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitSecond;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *conversionInfo = [gregorian components:unitFlags fromDate:fromDate   toDate:toDate  options:0];
    
    int hours = (int)[conversionInfo hour];
    return hours;
}

+ (NSString *)formatCurrency:(NSString *)amount andCurrency:(NSString *)currency
{
    currency = [currency stringByAppendingString:@" "];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:currency];
    NSString *currencyVal = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[amount floatValue]]];
    return currencyVal;
}

+ (NSString *)validateStringData:(id)data
{
    if ([data isKindOfClass:[NSNull class]] || data == nil || ([data isKindOfClass:[NSString class]] && ([data isEqualToString:@"<null>"] || [data isEqualToString:@"null"]))) {
        return @"";
    }
    else if ([data isKindOfClass:[NSNumber class]]) {
        return [data stringValue];
    }
    return data;
}

+ (void)decodeHtmlString:(NSString *)str :(void (^)(NSString *))completion
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       NSString *inputString = [ApplicationUtils validateStringData:str];
                       NSData *encodedString = [inputString dataUsingEncoding:NSUTF8StringEncoding];
                       NSAttributedString *htmlString = [[NSAttributedString alloc] initWithData:encodedString
                                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];

                       completion([htmlString string]);
                   });
}

+ (void) remove :(NSString *)key {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void) save :(id)value :(NSString *)key {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (id) getValue :(NSString *)key {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (UIImage *)placeholderImage
{
    static UIImage *placeholderImage;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, 0.0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
        
        placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return placeholderImage;
}

+ (void)hideShowViewWithView:(UIView *)view alpha:(float)value {
    [UIView transitionWithView:view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        view.alpha = value;
                    }
                    completion:NULL];
}

+ (void)pushVCWithFadeAnimation:(UIViewController *)vc andNavigationController:(UINavigationController *)nc {
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.type = kCATransitionFade;
//    [nc.view.layer addAnimation:transition forKey:kCATransitionFade];
    [nc pushViewController:vc animated:YES];
}

+ (void)popToVCWithFadeAnimation:(UIViewController *)vc andNavigationController:(UINavigationController *)nc {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    [nc.view.layer addAnimation:transition forKey:nil];
    [nc popToViewController:vc animated:NO];
}

+ (void)popVCWithFadeAnimation:(UINavigationController *)nc {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    [nc.view.layer addAnimation:transition forKey:nil];
    [nc popViewControllerAnimated:NO];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)setNavigationTitleAndButtonColorWithNavigationBar:(UINavigationBar *)navigationBar withHeaderColor:(UIColor *)headercolor
{
    UIImage *image = [ApplicationUtils imageFromColor:headercolor];
    [navigationBar setBackgroundImage:image    forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = image;
    navigationBar.translucent = NO;

//    [ApplicationUtils setTintColorForNavigationBackButton:[UIColor clearColor]];

    if ([headercolor isEqual:ROSE_PINK_COLOR]) {
        navigationBar.tintColor = [UIColor whiteColor];
        [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],        NSFontAttributeName:[ApplicationUtils GETFONT_BOLD:19]}];
    }
    else {
        navigationBar.tintColor = [UIColor darkGrayColor];
        [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],        NSFontAttributeName:[ApplicationUtils GETFONT_BOLD:19]}];
    }
}

+ (void)setNavigationTitleAndButtonColorWithoutShadow:(UIColor *)color {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTintColor:color];
    [navigationBarAppearance setBarTintColor:[UIColor whiteColor]];
    
    [ApplicationUtils setTintColorForNavigationBackButton:color];
}

+ (void)setTintColorForNavigationBackButton:(UIColor *)color {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    //Hide navigation back button title with set color to clear color
    [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName:color,        NSFontAttributeName:[ApplicationUtils GETFONT_MEDIUM:17]}];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]       setTitleTextAttributes:@{NSForegroundColorAttributeName:color,         NSFontAttributeName:[ApplicationUtils GETFONT_MEDIUM:17]}    forState:UIControlStateNormal];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorFromRGBData:(NSDictionary *)rgbDic {
    return [UIColor colorWithRed:[rgbDic[@"r"] floatValue]/255.0 green:[rgbDic[@"g"] floatValue]/255.0 blue:[rgbDic[@"b"] floatValue]/255.0 alpha:1.0];
}

+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (NSString *)hexStringFromRGBData:(NSDictionary *)rgbDic {
    UIColor *color = [UIColor colorWithRed:[rgbDic[@"r"] floatValue]/255.0 green:[rgbDic[@"g"] floatValue]/255.0 blue:[rgbDic[@"b"] floatValue]/255.0 alpha:1.0];
  
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    if(strEncodeData == nil)
        return nil;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    if (image == nil) {
        return nil;
    }
    return [ApplicationUtils encodeToBase64String:image compressionQuality:1.0];
}

+ (NSString *)encodeToBase64String:(UIImage *)image compressionQuality:(float)quality {
    return [UIImageJPEGRepresentation(image,quality) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)encodeToBase64StringForPngImages:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio
{
    return [self compressTheImage:image compressRatio:ratio maxCompressRatio:0.1f];
}

+ (UIImage *)compressTheImage:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio
{
    //Compression settings
    CGFloat compression = ratio;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    //Retuns the compressed image
    return [[UIImage alloc] initWithData:imageData];
}

+ (UIImage *)normalizedImage:(UIImage *)img {
    if (img.imageOrientation == UIImageOrientationUp) return img;
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    [img drawInRect:(CGRect){0, 0, img.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+ (void)insertBackgroundGradientLayer:(UIView *)bgView withFrame:(CGRect)frame
{
    UIColor *topColor = ORANGE_BG_COLOR;
    UIColor *bottomColor = ROSE_PINK_COLOR;
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    gradientLayer.frame = frame;
    [bgView.layer insertSublayer:gradientLayer atIndex:0];
}

+ (void)setFieldViewProperties:(UIView *)view {
    UILabel *lbl = (UILabel *)[view viewWithTag:FIELD_LABEL_TAG];
    [lbl setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    
    UITextField *tf = (UITextField *)[view viewWithTag:FIELD_TEXTFIELD_TAG];
    [tf setFont:[ApplicationUtils GETFONT_REGULAR:20]];
    [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [tf setTextColor:[UIColor blackColor]];
    
    UILabel *linelbl = (UILabel *)[view viewWithTag:FIELD_SEPERATOR_TAG];
    [linelbl setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    UIImageView *greenImageView = (UIImageView *)[view viewWithTag:FIELD_GREEN_MARK_TAG];
    greenImageView.hidden = YES;
    
    //Dropdown
    UIButton *dropdownButton = (UIButton *)[view viewWithTag:FIELD_DROPDWON_TAG];
    [dropdownButton.titleLabel setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [dropdownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dropdownButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, -10.0, 0.0, 0.0);
    
    //Radio - Gender
    UIButton *radioButton1 = (UIButton *)[view viewWithTag:FIELD_RADIO1_TAG];
    [radioButton1.titleLabel setFont:[ApplicationUtils GETFONT_REGULAR:20]];

    UIButton *radioButton2 = (UIButton *)[view viewWithTag:FIELD_RADIO2_TAG];
    [radioButton2.titleLabel setFont:[ApplicationUtils GETFONT_REGULAR:20]];
}

+ (void)hideGreenCheckImageFromFieldView:(UIView *)view shouldHide:(BOOL)hide {
    UIImageView *greenImageView = (UIImageView *)[view viewWithTag:FIELD_GREEN_MARK_TAG];
    greenImageView.hidden = hide;
}

+ (NSString *)stringByFormattingAsCreditCardNumber:(NSString *)string
{
    NSMutableString *result = [NSMutableString string];
    __block NSInteger count = -1;
    [string enumerateSubstringsInRange:(NSRange){0, [string length]}
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if ([substring rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound)
                                  return;
                              count += 1;
                              if (count == 4) {
                                  [result appendString:@" "];
                                  count = 0;
                              }
                              [result appendString:substring];
                          }];
    return result;
}

#pragma mark - fadeInOutView

+ (void)fadeInOutView:(float)value duration:(NSTimeInterval)time view:(UIView *)targetView{
    [UIView beginAnimations:@"fade out view" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    targetView.alpha = value;
    [UIView commitAnimations];
}



@end
