//
//  NSString+ValidateStringText.h
//  StashFin
//
//  Created by Mac on 14/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidateStringText)

- (BOOL)isNilOrEmpty;
- (BOOL)isEmail;
- (BOOL)isPhoneNumber;
- (BOOL)isDigit;
- (BOOL)isNumeric;
- (BOOL)isAlphanumeric;
- (BOOL)hasBothCases;
- (BOOL)isUrl;
- (BOOL)isMinLength:(NSUInteger)length;
- (BOOL)isMaxLength:(NSUInteger)length;
- (BOOL)isMinLength:(NSUInteger)min andMaxLength:(NSUInteger)max;
- (BOOL)isEmpty;
- (BOOL)isAlphanumericAndSpace;
- (BOOL)isAlphabetic;
- (BOOL)validatePAN;
- (BOOL)validateAadhar;
- (BOOL)isAlphanumericSpecial;
- (BOOL)isCapsAlphabetic;
- (BOOL)isAlphabeticAndSpace;
- (BOOL)isCharSpecial;
- (BOOL)validateNumeric;
- (BOOL)validateForAlphaNumeralsAndSpace;
- (BOOL)validateForAlphaNumerals;
- (BOOL)validateVPAString;
- (BOOL)validateAmountString;
- (BOOL)validateMobileString;
- (BOOL)validateInputWithStringWithRegex:(NSString *)regexString;
@end
