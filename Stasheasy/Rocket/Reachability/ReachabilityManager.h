//
//  ReachabilityManager.h
//  HuntMii
//
//  Created by Duke  on 21/09/15.
//  Copyright (c) 2015 KT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;
@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
