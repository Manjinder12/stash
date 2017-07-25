//
//  UserService.m
//  AlcoholApp
//
//  Created by Manan Khatri on 14/11/16.
//  Copyright © 2016 IK03. All rights reserved.
//

#import "UserServices.h"

@implementation UserServices

- (void)registerApiRequestWithParameter:(NSMutableDictionary *)params serviceName:(NSString *)serviceName
                            withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSArray *objects = [NSArray arrayWithObjects:@"application/json",@"1.0.0", nil];
    NSArray *Keys = [NSArray arrayWithObjects:@"content-type",@"Accept", nil];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc]initWithObjects:objects forKeys:Keys];
    
    
    [self startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:serviceName withParameters:params withSuccess:success withFailure:failure];
}

- (void)loginApiRequestWithParameter:(NSMutableDictionary *)params
                         withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
        
    [self startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:nil withServiceName:@"" withParameters:params withSuccess:success withFailure:failure];
}


@end
