//
//  LoanApplication.m
//  Stasheasy
//
//  Created by tushar on 30/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LoanApplication.h"

@implementation LoanApplication

- (NSArray *)giveKeysArray
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"loanAmount",@"first",@"tenure",@"second", nil];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"birthDate",@"first",@"gender",@"second", nil];

    NSArray *keysArr = [[NSArray alloc]initWithObjects:dic,@"reason",dic2,@"panNumber",@"adharNumber",@"adharName",@"salary",@"salary_mode",@"address",@"scp",@"occupiedSince",@"residenceType",@"loanID", nil];
    
//      NSArray *keysArr = [[NSArray alloc]initWithObjects:@"loanAmount",@"tenure",@"reason",@"birthDate",@"gender",@"panNumber",@"adharNumber",@"adharName",@"salary",@"address",@"occupiedSince",@"ownershipType",@"loanID", nil];
    
    return keysArr;
}
-(BOOL)validateLoanAmount:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter loan Amount",NSLocalizedFailureReasonErrorKey:@"Loan amount can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
-(BOOL)validateTenure:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter tenure",NSLocalizedFailureReasonErrorKey:@"Tenure can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateReason:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter Reason",NSLocalizedFailureReasonErrorKey:@"Reason can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateBirthDate:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter birthDate",NSLocalizedFailureReasonErrorKey:@"Birth Date can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateGender:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter gender",NSLocalizedFailureReasonErrorKey:@"Gender can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validatePanNumber:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter Pan Number",NSLocalizedFailureReasonErrorKey:@"Pan Number can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateAdharNumber:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter adhar number",NSLocalizedFailureReasonErrorKey:@"Adhar Number can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateAdharName:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter adhar name ",NSLocalizedFailureReasonErrorKey:@"Adhar Name can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
-(BOOL)validateSalary:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter salary",NSLocalizedFailureReasonErrorKey:@"Salary can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateSalaryMode:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please select salary mode",NSLocalizedFailureReasonErrorKey:@"Address can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateAddress:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter address",NSLocalizedFailureReasonErrorKey:@"Address can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
-(BOOL)validateStateCityPin:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please select state, city and pin",NSLocalizedFailureReasonErrorKey:@"Address can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateOccupiedSince:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter occupied since",NSLocalizedFailureReasonErrorKey:@"Occupied since can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
-(BOOL)validateOwnershipType:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter residence type",NSLocalizedFailureReasonErrorKey:@"Residence type can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

@end
