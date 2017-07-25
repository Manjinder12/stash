//
//  ProfessionalEducation.h
//  Stasheasy
//
//  Created by Tushar  on 07/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfessionalEducation : NSObject

@property(nonatomic,strong) NSString *designation;
@property(nonatomic,strong) NSString *highesteducation;
@property(nonatomic,strong) NSString *eduCompYear;
@property(nonatomic,strong) NSString *workStartYear;
@property(nonatomic,strong) NSString *experienceYears;
@property(nonatomic,strong) NSString *company_name;
@property(nonatomic,strong) NSString *officeemail;
@property(nonatomic,strong) NSString *officephone;
@property(nonatomic,strong) NSString *prof_address;
@property(nonatomic,strong) NSString *prof_state;
@property(nonatomic,strong) NSString *prof_city;
@property(nonatomic,strong) NSString *prof_pin;
@property (nonatomic,strong) NSString *linkedin;
-(NSMutableArray *)giveprofKeysArray;
@end
