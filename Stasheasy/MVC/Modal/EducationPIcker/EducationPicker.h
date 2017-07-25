//
//  EducationPicker.h
//  Stasheasy
//
//  Created by Tushar  on 07/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EducationPicker : NSObject
@property(nonatomic,strong) NSString *id_education;
@property(nonatomic,strong) NSString *education_name;
@property (nonatomic,strong) NSMutableArray *educationArr;


// States
@property(nonatomic,strong) NSString *id_state;
@property(nonatomic,strong) NSString *maxpin;
@property(nonatomic,strong) NSString *minpin;
@property(nonatomic,strong) NSString *stateName;
@property (nonatomic,strong) NSMutableArray *statesArr;


//response array
@property(nonatomic,strong) NSDictionary *responseDic;

-(NSMutableArray *)giveEducationPickerArr;
-(NSMutableArray *)giveStatesPickerArr;
@end
