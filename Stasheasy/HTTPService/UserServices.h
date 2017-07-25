//
//  UserService.h
//  AlcoholApp
//
//  Created by Manan Khatri on 14/11/16.
//  Copyright © 2016 IK03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPService.h"

@interface UserServices : HTTPService

/**
 *  Requesting to login API
 *
 *  @param params  instance of NSMutableDictionary containing paramters for api call
 *  @param success success block handled by calling UIViewController called if api is called successfully
 *  @param failure failure block handled by calling UIViewController called if api failed to called
 */
- (void)loginApiRequestWithParameter:(NSMutableDictionary *)params
                         withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Requesting to register API
 *
 *  @param params  instance of NSMutableDictionary containing paramters for api call
 *  @param success success block handled by calling UIViewController called if api is called successfully
 *  @param failure failure block handled by calling UIViewController called if api failed to called
 */
- (void)registerApiRequestWithParameter:(NSMutableDictionary *)params serviceName:(NSString *)serviceName
                            withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                            withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
