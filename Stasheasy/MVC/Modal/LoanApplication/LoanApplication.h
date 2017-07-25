//
//  LoanApplication.h
//  Stasheasy
//
//  Created by tushar on 30/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanApplication : NSObject

@property(nonatomic,strong) NSString *birthDate;
@property(nonatomic,strong) NSString *gender;
@property(nonatomic,strong) NSString *panNumber;
@property(nonatomic,strong) NSString *adharNumber;
@property(nonatomic,strong) NSString *adharName;
@property(nonatomic,strong) NSString *salMode;
@property(nonatomic,strong) NSString *salary;
@property(nonatomic,strong) NSString *ownershipType;
@property(nonatomic,strong) NSString *occupiedSince;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *pin;
@property(nonatomic,strong) NSString *loanAmount;
@property(nonatomic,strong) NSString *tenure;
@property(nonatomic,strong) NSString *reason;
@property(nonatomic,strong) NSString *loanID;
-(NSArray *)giveKeysArray;

@end
