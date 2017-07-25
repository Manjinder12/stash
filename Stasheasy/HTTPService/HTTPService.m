//
//  HTTPService.m
//
//  Created by Ashish Sharma on 30/05/15.
//  Copyright (c) 2015 Konstant Info. All rights reserved.
//

#import "HTTPService.h"
#import "CommonFunctions.h"

@interface HTTPService ()

/**
 *  Call this to set HTTP headers for request
 *
 *  @param headers HTTP headers
 */
- (void) setHeaders:(NSDictionary*) headers;

/**
 *  Call this to convert params in raw json format
 *
 *  @param params params to post
 */
- (void) addQueryStringWithParams:(NSDictionary*) params;

@end

@implementation HTTPService

#pragma mark - Designated Initializer

- (id)initWithBaseURL:(NSURL*) baseURL andSessionConfig:(NSURLSessionConfiguration*) config
{
    self = [super init];
    
    if (self)
    {
        NSAssert (baseURL, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"baseURL can't be nil",__PRETTY_FUNCTION__]));
        
        httpBaseURL = [baseURL absoluteString];
        
        if (config)
            httpSessionManager = [[AFHTTPSessionManager alloc]
                                  initWithBaseURL:baseURL sessionConfiguration:config];
        else
            httpSessionManager = [[AFHTTPSessionManager alloc]
                                  initWithBaseURL:baseURL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [httpSessionManager.requestSerializer setTimeoutInterval:80.0];
    }
    
    return self;
}

#pragma mark - Super Class Methods

- (id)init
{
    self = [super init];
    
    if (self)
    {
        httpBaseURL = BASE_URL;
        
        httpSessionManager = [[AFHTTPSessionManager alloc]
                              initWithBaseURL:[NSURL URLWithString:httpBaseURL]];
        httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)dealloc
{
    httpSessionManager = nil;
}

#pragma mark - Instance Methods (Private)

- (void) setHeaders:(NSDictionary*) headers
{
    if (headers != nil)
    {
        NSArray *allHeaders = [headers allKeys];
        
        for (NSString *key in allHeaders)
        {
            [httpSessionManager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
}

- (void) addQueryStringWithParams:(NSDictionary*) params
{
    [httpSessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        __block NSMutableString *query = [NSMutableString stringWithString:@""];
        
        NSError *err;
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:params options:0 error:&err];
        NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        query = jsonString;
        
        return query;
    }];
}

#pragma mark - Instance Methods

- (void) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType
                    withHttpHeaders:(NSMutableDictionary*) headers
                    withServiceName:(NSString*) serviceName
                     withParameters:(NSMutableDictionary*) params
                        withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
   
    NSAssert(serviceName, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"serviceName can't be nil",__PRETTY_FUNCTION__]));
   
    
    NSString *serviceUrl = [httpBaseURL stringByAppendingPathComponent:serviceName];
    if (headers == nil)
    {
        NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Accept",@"application/json; charset=utf-8",@"Content-Type",nil];
        [self setHeaders:headers];
    }
    else
    {
//        [headers setObject:@"application/json" forKey:@"Accept"];
//        [headers setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
        [self setHeaders:headers];
    }
    
    if (params != nil)
        [self addQueryStringWithParams:params];
    
    switch (httpMethodType)
    {
        case kHttpMethodTypeGet:
        {
            [httpSessionManager GET:serviceUrl
                         parameters:params
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                if (success != nil)
                                    success(task,responseObject);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                                
                                if (failure != nil)
                                    // handle error code

//                                    [self handleErrorCode:error withTask:task];
                                    failure(task,error);
                            }];
        }
            break;
        case kHttpMethodTypePost:
        {
            [httpSessionManager POST:serviceUrl
                          parameters:params
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
                                 if (success != nil)
                                     success(task,responseObject);
                             }
                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 
                                 if (failure != nil)
                                     failure(task,error);
                             }];
        }
            break;
        case kHttpMethodTypeDelete:
        {
            [httpSessionManager DELETE:serviceUrl
                            parameters:params
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   
                                   if (success != nil)
                                       success(task,responseObject);
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   
                                   if (failure != nil)
                                       failure(task,error);
                               }];
        }
            break;
        case kHttpMethodTypePut:
        {
            [httpSessionManager PUT:serviceUrl
                         parameters:params
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                if (success != nil)
                                    success(task,responseObject);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                if (failure != nil)
                                    failure(task,error);
                            }];
        }
            break;
            
        default:
            break;
    }
}

- (void) uploadFileRequestWithHttpHeaders:(NSMutableDictionary*) headers
                          withServiceName:(NSString*) serviceName
                           withParameters:(NSMutableDictionary*) params
                             withFileData:(NSArray*) files
                              withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSAssert(serviceName, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"serviceName can't be nil",__PRETTY_FUNCTION__]));
    
    NSString *serviceUrl = [httpBaseURL stringByAppendingPathComponent:serviceName];
    
    if (headers == nil)
    {
        NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:@"multipart/form-data",@"Content-Type",nil];
        [self setHeaders:headers];
    }
    else
    {
        [headers setObject:@"multipart/form-data" forKey:@"Content-Type"];
        [self setHeaders:headers];
    }
    
    [httpSessionManager POST:serviceUrl
                  parameters:params
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       
       for (NSData *fileData in files)
       {
           [formData appendPartWithFileData:fileData name:@"profile" fileName:@"profile_pic.jpg" mimeType:@"image/jpeg"];
       }
   }
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         if (success != nil)
                             success(task,responseObject);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         if (failure != nil)
                             // [self handleErrorCode:error withTask:task];
                             failure(task,error);
                     }];
}
//-(void)handleErrorCode:(NSError*)error withTask:(NSURLSessionDataTask*)task
//{
//    DLog(@"Error Code IS = %@",[error description]);
////    if (error.code == -1011) {
////        [APPDELEGATE logout];
////    }
////    else
//    if (error.code==-1001)    {
//        [CommonFunctions alertTitle:NSLocalizedString(@"APP_NAME", @"") withMessage:NSLocalizedString(@"ERROR_NETWROK_1001", @"") withDelegate:nil];
//    }
//    else if (error.code==-1004)    {
//        [CommonFunctions alertTitle:NSLocalizedString(@"APP_NAME", @"") withMessage:NSLocalizedString(@"ERROR_NETWROK_1004", @"") withDelegate:nil];
//    }
//    else if(error.code==-1005)
//    {
//        [CommonFunctions alertTitle:NSLocalizedString(@"APP_NAME", @"") withMessage:NSLocalizedString(@"ERROR_NETWROK_1005", @"") withDelegate:nil];
//
//    }
//    else{
//    //if(error.code == -1011){
//        [self getErrorData:error andStatusCode:task];
//    }
//}
//-(void)getErrorData :(NSError *) error andStatusCode :(NSURLSessionDataTask *) task {
//    
//    [CommonFunctions getStatusCode:task];
//    if ( [CommonFunctions getStatusCode:task] ==401 ||[CommonFunctions getStatusCode:task] ==501 || [CommonFunctions getStatusCode:task] ==403 || [CommonFunctions getStatusCode:task] ==404) {
//        [APPDELEGATE logout];
//    }
//    else {
//        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        if (errorData) {
//            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
//            DLog(@"Error Data => %@",serializedData);
//            [self showAlertWithTitle:NSLocalizedString(@"APP_NAME", @"") withMessage:[serializedData objectForKey:@"reply"]];
//        }
//
//    }
//}
//
//-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message {
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:atitle
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"LIB_OK", nil)
//                                          otherButtonTitles:nil];
//    [alert show];
//}

@end
