//
//  Utilities.m
//  RossBrothers
//
//  Created by ammarali on 28/04/16.
//  Copyright © 2016 6degreesit. All rights reserved.
//

#import "Utilities.h"
#import <AFNetworking/AFNetworking.h>

@implementation Utilities

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
+(NSDictionary *)setNavigationFontDictionary
{
    NSDictionary *dict = [NSDictionary new];
    dict=@{
           NSForegroundColorAttributeName: [UIColor whiteColor],
           NSFontAttributeName: [UIFont systemFontOfSize:20]
           };
    
    return dict;
}

+(UIColor *)setNavigationBarColor
{
    return [UIColor blackColor];
}
+(NSString *) Datefromstring: (NSDate *)stringDate byFormatter:(NSString *) formatter
{
    NSString *dateString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:formatter];
    dateString = [dateFormatter stringFromDate:stringDate];
    dateFormatter = nil;
    return dateString;
}
+(NSDate *)stringToDate:(NSString *) stringDate byFormatter: (NSString *) formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *tempDate = [dateFormatter dateFromString:stringDate];
    dateFormatter = nil;
    return tempDate;
}
+(BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"[789][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+(void)setCornerRadius:(id)object
{
    CALayer *layer=[object layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0f];
}
+ (UIColor *)getColorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color andBounds:(CGRect)imgBounds
{
    UIGraphicsBeginImageContextWithOptions(imgBounds.size, NO, 0);
    [color setFill];
    UIRectFill(imgBounds);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


+ (NSAttributedString *)setAttributedTextForString:(NSString *)htmlString
{
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrString;
    
}
+(NSDictionary *)getJsonDictionaryFromResponseString:(NSString *)responseString
{
    NSError *jsonError;
    NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
   
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingAllowFragments error:&jsonError];
        return json;
}


+ (BOOL) validate:(NSString *)string withField:(NSString *)field
{
    NSString *regex = nil;
    
    if ([field isEqualToString:@"TaxID"])
    {
        regex = @"[0-9A-Za-z -]{1,100}";
    }
    if ([field isEqualToString:@"username"])
    {
        regex = @"[0-9A-Za-z ]{1,100}";
    }
    if ([field isEqualToString:@"comment"])
    {
        regex = @"[0-9A-Za-z -_'"".!$,]{1,100}";
    }
    if ([field isEqualToString:@"name"])
    {
        regex = @"[A-Za-z ]{1,100}";
    }
    else if ([field isEqualToString:@"phone"])
    {
        regex = @"\\+?[0-9]{10,14}";
    }
    else if ([field isEqualToString:@"email"])
    {
        regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    }
    else if ([field isEqualToString:@"streetAddress"])
    {
        regex = @"[0-9A-Za-z /]{1,100}";
    }
    else if ([field isEqualToString:@"city"])
    {
        regex = @"[A-Za-z ]{1,100}";
    }
    else if ([field isEqualToString:@"state"])
    {
        regex = @"[A-Za-z ]{1,100}";
    }
    else if ([field isEqualToString:@"zip"])
    {
        regex = @"[0-9]{5,10}";
    }
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    BOOL isMatch;
    if (string.length > 0)
    {
        isMatch = [predicate evaluateWithObject:string];
        
    }
    else
    {
        isMatch = NO;
    }
    
    
    regex = nil;
    
    return isMatch;
}
+ (NSURL *)getFormattedImageURLFromString:(NSString *)string
{
    NSURL *url;
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:string];
    return url;
}
+ (NSString *)getCallUsNumber
{
    NSString *number;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"contact_number"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults]valueForKey:@"contact_number"] length] != 0)
    {
        number = [[NSUserDefaults standardUserDefaults] valueForKey:@"contact_number"];
    }
    else
    {
        number = [@"tel://" stringByAppendingString:@"1(866)804-9750"];
    }
    
    return number;
}

+ (void)showMessage:alertText withTitle:alertTitle
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
}
+ (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"StashFin" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
}
+ (UIImage*)compressImageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSArray *)getArrayWithoutDuplicateItems:(NSArray *)array
{
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:array];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    
    return arrayWithoutDuplicates;
}

+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)getBase64EncodedStringOfImage:(UIImage *)image
{
    // here we get App directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *appDirectory = [paths objectAtIndex:0];
    int random = arc4random_uniform(74); // generating random no for random name
    NSString *fileName = [NSString stringWithFormat:@"file%d",random];
    NSData *data = UIImageJPEGRepresentation(image, 0.8); // creating data from image
    
    // creating Path
    NSString *filePath = [appDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES]; // writing data on path
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath]; // getting data from path
    // converting to string
    NSString *strencoded = [fileData base64EncodedStringWithOptions:kNilOptions];
    
    return strencoded;
}

+(void)setBorderAndColor:(id)object
{
    CALayer *layer = [object layer];
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor darkGrayColor].CGColor;
}

+ (UINavigationController *)getNavigationControllerForViewController:(UIViewController *)controller
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    return navigationController;
}
+ (void)showPopupView:(UIView *)popupView onViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [overlayView setTag:786];
    [popupView setHidden:NO];
    [viewcontroller.view addSubview:overlayView];
    
    [viewcontroller.view bringSubviewToFront:popupView];
    popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        popupView.transform = CGAffineTransformIdentity;
    } completion:nil
     ];
}

+ (void)hidePopupView:(UIView *)popupView fromViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [viewcontroller.view viewWithTag:786];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
     }
                     completion:^(BOOL finished) {
                         
                         [popupView setHidden:YES];
                     }];
    [overlayView removeFromSuperview];
    
}

+ (CGFloat)getNumberOfLines:(UILabel *)label forText:(NSString *)text
{
    if ( label !=  nil && text != nil)
    {
        CGFloat lineCount;
        NSDictionary *attributes = @{NSFontAttributeName: label.font};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        lineCount = rect.size.height /label.font.lineHeight;
        return lineCount;
    }
    else
    {
        return 0;
    }
}
+ (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}
+ (void) popToNumberOfControllers:(int)number withNavigation:(UINavigationController *)navigationController
{
    if (number <= 1)
        [navigationController popViewControllerAnimated:YES];
    else
    {
        NSArray* controller = [ navigationController viewControllers];
        int requiredIndex = (int)[controller count] - number - 1;
        if (requiredIndex < 0) requiredIndex = 0;
        UIViewController* requireController = [[navigationController viewControllers] objectAtIndex:requiredIndex];
        [ navigationController popToViewController:requireController animated:YES];
    }
}
+ (UIStoryboard *)getStoryBoard
{
    return [ UIStoryboard storyboardWithName:@"iPhone" bundle:nil ];

//    NSString *deviceType = [UIDevice currentDevice].model;
//    if ([deviceType isEqualToString:@"iPhone"])
//    {
//        return [ UIStoryboard storyboardWithName:@"iPhone" bundle:nil ];
//    }
//    else
//    {
//        return [ UIStoryboard storyboardWithName:@"iPad" bundle:nil ];
//    }
    
}
+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *vc = [ [ self getStoryBoard ] instantiateViewControllerWithIdentifier:identifier ];
    return vc;
}
+ (void)navigateToViewControllerWithIdentifier:(NSString *)identifier withNavigation:(UINavigationController *)navigation
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    [navigation pushViewController:vc animated:YES];
}


- (void)navigateToViewController:(UIViewController *)vc withNavigation:(UINavigationController *)navigation
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    vc = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([vc class])];
    [navigation pushViewController:vc animated:YES];
    
}
+ (void)setUserDefaultWithObject:(id)object andKey:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getUserDefaultValueFromKey:(NSString *)key
{
    return [ [ NSUserDefaults standardUserDefaults ] objectForKey:key];
}
+ (NSString *)getDeviceUDID
{
    NSString *udid =  [[[UIDevice currentDevice] identifierForVendor] UUIDString ];
    NSString *final = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return final;
}
+ (NSString *)getBase64StringOfImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
}
+ ( NSDictionary *)getDayDateYear:(NSString *)date
{
    NSMutableDictionary *mdict = [ NSMutableDictionary new ];
    NSDateFormatter *formatter = [ [ NSDateFormatter alloc ] init ];
    [ formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss" ];
    NSDate *jobDate = [ formatter dateFromString:date ];
    
    NSTimeZone *currentUserTimezone = [ NSTimeZone localTimeZone];
    [ formatter setTimeZone:currentUserTimezone ];
    
    NSDateFormatter *newformatter = [ [ NSDateFormatter alloc ] init ];
    [ newformatter setDateFormat:@"dd" ];
    [ mdict setObject:[ newformatter stringFromDate:jobDate ] forKey:@"day" ];
    
    [ newformatter setDateFormat:@"MMM" ];
    [ mdict setObject:[ newformatter stringFromDate:jobDate ] forKey:@"month" ];
    
    [ newformatter setDateFormat:@"yyyy" ];
    [ mdict setObject:[ newformatter stringFromDate:jobDate ] forKey:@"year" ];
    
    [ newformatter setDateFormat:@"HH:mm:ss" ];
    [ mdict setObject:[ newformatter stringFromDate:jobDate ] forKey:@"time" ];
    
    return ( NSDictionary *)mdict;
}
+(NSString *)formateDateToDMY:(NSString *)strDate
{
    NSMutableDictionary *mdict = [ NSMutableDictionary new ];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd"];
    NSDate *date = [ formatter dateFromString:strDate ];

    NSTimeZone *currentUserTimezone = [ NSTimeZone localTimeZone];
    [ formatter setTimeZone:currentUserTimezone ];
    
    NSDateFormatter *newformatter = [ [ NSDateFormatter alloc ] init ];
    [ newformatter setDateFormat:@"dd" ];
    [ mdict setObject:[ newformatter stringFromDate:date ] forKey:@"day" ];
    
    [ newformatter setDateFormat:@"MMM" ];
    [ mdict setObject:[ newformatter stringFromDate:date ] forKey:@"month" ];
    
    [ newformatter setDateFormat:@"yyyy" ];
    [ mdict setObject:[ newformatter stringFromDate:date ] forKey:@"year" ];

    [NSString stringWithFormat:@"%@ %@ %@",[mdict valueForKey:@"day"],[mdict valueForKey:@"month"],[mdict valueForKey:@"year"]];
    
    return ( NSString * )[NSString stringWithFormat:@"%@ %@ %@",[mdict valueForKey:@"day"],[mdict valueForKey:@"month"],[mdict valueForKey:@"year"]];
}

+ (void)setLeftPaddingToTextfield:(UITextField *)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

+ (void)navigateToLOCDashboard:(UINavigationController *)navigationController
{
    LineCreditVC *vc = (LineCreditVC *) [[self getStoryBoard] instantiateViewControllerWithIdentifier:@"LineCreditVC"];
    
    if ( [navigationController.viewControllers count]  == 2 )
    {
        [navigationController popViewControllerAnimated:YES];
    }
    else
    {
        navigationController.viewControllers = @[vc];
        [navigationController popViewControllerAnimated:YES];
    }
}
+ (void)setShadowToView:(UIView *)view
{
    view.layer.shadowOffset = CGSizeMake(1, 10);
    view.layer.shadowRadius = 5.0f;
    view.layer.shadowOpacity = 0.6;
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
}
+ (NSString *)getStringFromResponse:(NSString *)str
{
    if ( [str isEqualToString:@""] || [ str isKindOfClass:[NSNull class]] || [str isEqual:NULL] || [str isEqualToString:@"null"] || [ str containsString:@"null"] )
    {
        return @"Not Available";
    }
    else
    {
        return str;
    }
        
}

@end
