//
//  ServerCall.h
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utilities.h"

@interface ServerCall : NSObject

+ (void)getServerResponseWithParameters:(id)parameters withHUD:(BOOL)HUD withCompletion:(void (^) (id response))response;


@end
