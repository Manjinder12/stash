//
//  ServerCall.m
//  StashFin
//
//  Created by Mac on 19/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "ServerCall.h"

@implementation ServerCall

+ (void)getServerResponseWithParameters:(id)parameters withHUD:(BOOL)HUD withHudBgView:(UIView *)view withCompletion:(void (^) (id response))block
{
    if (HUD)
    {
        [MRProgressOverlayView showOverlayAddedTo:view animated:YES];
    }
    
    AFHTTPClient *httpClient;
    
    if ([parameters[@"mode"] isEqualToString:@"SendOTPBeforeRegistration"] || [parameters[@"mode"] isEqualToString:@"referral_check"] || [parameters[@"mode"] isEqualToString:@"verifyNumberBeforeRegistration"] || [parameters[@"mode"] isEqualToString:@"checkPreapproval"] || [parameters[@"mode"] isEqualToString:@"RegisterAppCustomer"] || [parameters[@"mode"] isEqualToString:@"addProfessionalInfo"]) {
        httpClient = [ApplicationUtils generateHTTPHeaderWithOLDURL:NO];
    }
    else {
        httpClient = [ApplicationUtils generateHTTPHeaderWithOLDURL:YES];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {}]];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          options:NSJSONReadingMutableContainers
                                                            error:&error];

        NSLog(@"====%@",responseData);
        
        [MRProgressOverlayView dismissOverlayForView:view animated:YES];
        
        if (![responseData isKindOfClass:[NSNull class]] && responseData != nil)
        {
            if (([[responseData class] isSubclassOfClass:[NSDictionary class]] && [[[ApplicationUtils validateStringData:responseData[@"error"]] class] isSubclassOfClass:[NSString class]] && [[ApplicationUtils validateStringData:responseData[@"error"]] length] > 0))
            {
                if (([[[ApplicationUtils validateStringData:responseData[@"error"]] lowercaseString] isEqualToString:@"invalid auth token"] || [[[ApplicationUtils validateStringData:responseData[@"error"]] lowercaseString] isEqualToString:@"login expired"]) && !([parameters[@"mode"] isEqualToString:@"checkAuthTokenValidity"]))
                {
                    [[AppDelegate instance] showSessionExpiredAlertAndlogout];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(nil);
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block([ApplicationUtils validateStringData:responseData[@"error"]]);
                    });
                }
            }
            else if ([responseData isKindOfClass:[NSString class]] && ([responseData isEqualToString:@"<null>"] || [responseData isEqualToString:@"null"])) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(nil);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseData);
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil);
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MRProgressOverlayView dismissOverlayForView:view animated:YES];

        dispatch_async(dispatch_get_main_queue(), ^{
            block(error.localizedDescription);
        });
    }];
    [operation start];
}

@end
