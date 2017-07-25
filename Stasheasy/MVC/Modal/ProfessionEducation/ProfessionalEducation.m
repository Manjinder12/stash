//
//  ProfessionalEducation.m
//  Stasheasy
//
//  Created by Tushar  on 07/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ProfessionalEducation.h"

@implementation ProfessionalEducation

-(NSMutableArray *)giveprofKeysArray {
    NSDictionary *dic3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"linkedin",@"First",@"highesteducation",@"Second", nil];
    NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"designation",@"First",@"workStartYear",@"Second", nil];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"experienceYears",@"First",@"officeemail",@"Second", nil];

    NSMutableArray *profKeys = [[NSMutableArray alloc]initWithObjects:dic3,@"company_name",dic1,dic2,@"officephone",@"prof_address", nil];
    return profKeys;
}

@end
