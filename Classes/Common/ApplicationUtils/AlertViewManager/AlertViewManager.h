//
//  AlertViewManager.h
//  HS
//
//  Created by Mac on 10/10/17.
//  Copyright (c) 2017. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AlertType){
    AlertTypeSession = 1,
    AlertTypeEtc
};

@interface AlertViewManager : NSObject

@property (nonatomic, strong) UIAlertView * alertView;
@property (nonatomic) NSInteger alertType;

+ (AlertViewManager*)sharedManager;

@end
