//
//  BasicInfo.m
//  Stasheasy
//
//  Created by Duke  on 09/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "BasicInfo.h"

@implementation BasicInfo
- (NSArray *)giveKeysArray {
    NSArray *keysArr = [[NSArray alloc]initWithObjects:@"fname",@"lname",@"email",@"phone",@"company",@"employmentType",@"salary",@"city", nil];
    return keysArr;
}


-(BOOL)validateFname:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter first name",NSLocalizedFailureReasonErrorKey:@"First Name can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateLname:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter last name",NSLocalizedFailureReasonErrorKey:@"Last Name can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateEmail:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter email",NSLocalizedFailureReasonErrorKey:@"Email can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validatePhone:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter phone number",NSLocalizedFailureReasonErrorKey:@"Phone number can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateCompany:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter company name",NSLocalizedFailureReasonErrorKey:@"Company name can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateSalary:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter salary",NSLocalizedFailureReasonErrorKey:@"Salary can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateEmploymentType:(id *)ioValue error:(NSError * __autoreleasing *)outError{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please check employment type",NSLocalizedFailureReasonErrorKey:@"Employment type can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
@end
