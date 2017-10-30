//
//  ServerCall.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 24/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ServerCall.h"

//#define service_url @"http://devapi.stasheasy.com/webServicesMobile/StasheasyApp" // Development

#define service_url @"https://api.stashfin.com/webServicesMobile/StasheasyApp" // Live



@implementation ServerCall

+ (void)getServerResponseWithParameters:(id)parameters withHUD:(BOOL)HUD withCompletion:(void (^) (id response))response
{
    if (HUD)
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer setTimeoutInterval:60];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    sessionManager.responseSerializer.acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    NSString *token = [NSString stringWithFormat:@"%@",[Utilities getUserDefaultValueFromKey:@"auth_token"]];
    
    NSString *deviceID = [NSString stringWithFormat:@"%@",[Utilities getDeviceUDID]];

    [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"auth_token"];
    [sessionManager.requestSerializer setValue:deviceID forHTTPHeaderField:@"device_id"];
    [sessionManager POST:service_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         response(dictResponse);
         if (HUD)
         {
             [SVProgressHUD dismiss];
         }
     }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSString *strServerError = error.localizedDescription;
         response(strServerError);
         if (HUD)
         {
             [SVProgressHUD dismiss];
         }
     }];
    
}

@end
