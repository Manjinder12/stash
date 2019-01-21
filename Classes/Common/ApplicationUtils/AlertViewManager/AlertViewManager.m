//
//  AlertViewManager.m
//  StashFin
//
//  Created by Mac on 14/01/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "AlertViewManager.h"

@implementation AlertViewManager

#pragma mark Singleton Methods

+ (AlertViewManager*)sharedManager {
    static AlertViewManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (AlertViewManager *)init {
    if (self = [super init]) {
        
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:@"" cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", nil) action:^{}] otherButtonItems: nil];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
