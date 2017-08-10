//
//  ProfessionalEducation.m
//  Stasheasy
//
//  Created by Tushar  on 07/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ProfessionalEducation.h"

@implementation ProfessionalEducation

-(NSMutableArray *)giveprofKeysArray
{
    NSDictionary *dic3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"linkedin",@"First",@"highesteducation",@"Second", nil];
    NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"designation",@"First",@"workStartYear",@"Second", nil];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"experienceYears",@"First",@"officeemail",@"Second", nil];

    NSMutableArray *profKeys = [[NSMutableArray alloc]initWithObjects:dic3,@"company_name",dic1,dic2,@"officephone",@"prof_address", nil];
    return profKeys;
}
-(BOOL)validateLinkedin:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter linkedin detail",NSLocalizedFailureReasonErrorKey:@"Linkedin detail can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
-(BOOL)validateHighesteducation:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter highest education",NSLocalizedFailureReasonErrorKey:@"Highest Education can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateDesignation:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter designation",NSLocalizedFailureReasonErrorKey:@"Designation can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateWorkStartYear:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter work start year",NSLocalizedFailureReasonErrorKey:@"Work start year can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateExperienceYears:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter experience years",NSLocalizedFailureReasonErrorKey:@"Experience Year can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateOfficeemail:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter office email",NSLocalizedFailureReasonErrorKey:@"Office email can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}

-(BOOL)validateCompanyName:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter company name",NSLocalizedFailureReasonErrorKey:@"Company Name can not be empty"};
        
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
-(BOOL)validateProfaddress:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if (*ioValue == nil || ((NSString *)*ioValue).length<=0)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Please enter professional address",NSLocalizedFailureReasonErrorKey:@"Professional Address can not be empty"};
        
        *outError = [[NSError alloc] initWithDomain:@"SIGNUP_ERROR_DOMAIN" code:0 userInfo:userInfo];
        return NO;
    }
    return YES;
}
@end
