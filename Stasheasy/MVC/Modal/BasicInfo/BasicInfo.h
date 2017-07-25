//
//  BasicInfo.h
//  Stasheasy
//
//  Created by Duke  on 09/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicInfo : NSObject

@property(nonatomic,strong) NSString *fname;
@property(nonatomic,strong) NSString *lname;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *company;
@property(nonatomic,strong) NSString *employmentType;
@property(nonatomic,strong) NSString *salary;
@property(nonatomic,strong) NSString *city;

-(NSArray *)giveKeysArray;
@end
