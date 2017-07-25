//
//  LoanApplication.m
//  Stasheasy
//
//  Created by tushar on 30/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "LoanApplication.h"

@implementation LoanApplication

- (NSArray *)giveKeysArray {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"loanAmount",@"first",@"tenure",@"second", nil];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"birthDate",@"first",@"gender",@"second", nil];

    NSArray *keysArr = [[NSArray alloc]initWithObjects:dic,@"reason",dic2,@"panNumber",@"adharNumber",@"adharName",@"salary",@"address",@"occupiedSince",@"ownershipType",@"loanID", nil];
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

@end
