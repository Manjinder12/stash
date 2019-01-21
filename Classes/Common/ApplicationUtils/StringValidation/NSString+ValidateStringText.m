//
//  NSString+ValidateStringText.m
//  StashFin
//
//  Created by Mac on 14/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "NSString+ValidateStringText.h"

@implementation NSString (Contains)

//For iOS7 handlling
- (BOOL)containsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end

@implementation NSString (ValidateStringText)

- (BOOL)isNilOrEmpty {
	return !self || [self isEmpty] || ([[self class] isSubclassOfClass:[NSNull class]]);
}

- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber
                                                               error:nil];
    
    return [detector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (BOOL)isDigit {
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (BOOL)isNumeric {
    NSString *regex = @"([0-9])+((\\.|,)([0-9])+)?";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isAlphanumeric {
    NSString *regex = @"^[a-zA-Z0-9]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)validatePAN
{
    NSString * const regularExpression =  @"^[A-Za-z]{5}[0-9]{4}[A-Za-z]$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, [self length])];
    return numberOfMatches > 0;
}

- (BOOL)validateAadhar
{
    NSString *regex = @"[0-9]{12}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

- (BOOL)validateVPAString
{
    NSString *regex = @"[A-Za-z0-9.-]{3,50}+@[A-Za-z0-9.-]{3,50}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

- (BOOL)validateAmountString
{
    NSString *regex = @"[0-9]+\\.[0-9]{1,2}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

- (BOOL)validateMobileString
{
    NSString *regex = @"[6-9][0-9]{9}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

- (BOOL)validateNumeric {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)validateForAlphaNumeralsAndSpace
{
    NSString * const regularExpression =  @"^[A-Za-z0-9 ]{1,100}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, [self length])];
    return numberOfMatches > 0;
}

- (BOOL)validateForAlphaNumerals
{
    NSString * const regularExpression =  @"^[A-Za-z0-9]{1,100}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, [self length])];
    return numberOfMatches > 0;
}

- (BOOL)validateInputWithStringWithRegex:(NSString *)regexString {
    NSString * const regularExpression = regexString;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, [self length])];
    return numberOfMatches > 0;
}

- (BOOL)isCapsAlphabetic {
    NSString *regex = @"^[A-Z]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isAlphabetic {
    NSString *regex = @"^[a-zA-Z]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isAlphabeticAndSpace {
    NSString *regex = @"^[a-zA-Z ]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

//Note - If you want to allow - put it in last as it represents range while used in middle
- (BOOL)isCharSpecial {
    NSString *regex = @"^[a-zA-Z ,/()@*^%$#.!_=+{}\[]:;'?&amp;-]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isAlphanumericAndSpace {
    NSString *regex = @"^[a-zA-Z0-9 ]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isAlphanumericSpecial {
    NSString *regex = @"^[\\ _.a-zA-Z0-9-]*$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)hasBothCases {
    NSString *regex = @"^.*(?=.*?[a-z])(?=.*?[A-Z]).+$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isUrl {
    NSString *regex = @"https?:\\/\\/[\\S]+";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isMinLength:(NSUInteger)length {
    return (self.length >= length);
}

- (BOOL)isMaxLength:(NSUInteger)length {
    return (self.length <= length);
}

- (BOOL)isMinLength:(NSUInteger)min andMaxLength:(NSUInteger)max {
    return ([self isMinLength:min] && [self isMaxLength:max]);
}

- (BOOL)isEmpty {
    return (!self.length);
}


@end
