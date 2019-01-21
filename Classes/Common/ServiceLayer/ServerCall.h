//
//  ServerCall.h
//  StashFin
//
//  Created by Mac on 19/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerCall : NSObject

+ (void)getServerResponseWithParameters:(id)parameters withHUD:(BOOL)HUD withHudBgView:(UIView *)view withCompletion:(void (^) (id response))block;


@end
