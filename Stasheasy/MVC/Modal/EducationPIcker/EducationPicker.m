//
//  EducationPicker.m
//  Stasheasy
//
//  Created by Tushar  on 07/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "EducationPicker.h"

@implementation EducationPicker

-(NSMutableArray *)giveEducationPickerArr {
    NSArray *educationArr = [_responseDic objectForKey:@"educations"];
    self.educationArr = [NSMutableArray array];
    for (NSDictionary *dic in educationArr) {
        EducationPicker *statespicker = [[EducationPicker alloc]init];
        statespicker.id_education = [dic objectForKey:@"id"];
        statespicker.education_name = [dic objectForKey:@"education"];
        
        [self.educationArr addObject:statespicker];
    }
    return self.educationArr;

}

-(NSMutableArray *)giveStatesPickerArr {
    NSArray *statesArr = [_responseDic objectForKey:@"operational_states"];
    self.statesArr = [NSMutableArray array];
    for (NSDictionary *dic in statesArr) {
        EducationPicker *statespicker = [[EducationPicker alloc]init];
        statespicker.id_state = [dic objectForKey:@"id"];
        statespicker.maxpin = [dic objectForKey:@"maxPinPrefix"];
        statespicker.minpin = [dic objectForKey:@"minPinPrefix"];
        statespicker.stateName = [dic objectForKey:@"state_name"];
        
        [self.statesArr addObject:statespicker];
    }
    return self.statesArr;
}

@end
