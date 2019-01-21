//
//  Base64String.h
//  CoR
//
//  Created by JE CIRCLE on 20/09/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64String : NSObject

//Converting String to Base64
+ (NSString *)base64String:(NSString *)pString;

//Converting NSData to String
+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;
+ (NSString*) encode:(NSData*) rawBytes;

//Converting NSString to NSData
+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
+ (NSData*) decode:(NSString*) string;

@end
