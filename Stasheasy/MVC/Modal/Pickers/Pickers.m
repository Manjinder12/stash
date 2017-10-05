//
//  Pickers.m
//  Stasheasy
//
//  Created by Tushar  on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "Pickers.h"

@implementation Pickers

-(NSMutableArray *)giveLoanPickerArr
{
   self.loanReasonArr = [NSMutableArray array];
   NSArray *loanresponseArr = [_responseDic objectForKey:@"loan_reasons"];

    for (NSDictionary *dic in loanresponseArr)
    {
        Pickers *loanpicker = [[Pickers alloc]init];
        loanpicker.id_loaon_reason = [dic objectForKey:@"id"];
        loanpicker.loanreason = [dic objectForKey:@"loan_reason"];
        
        [self.loanReasonArr addObject:loanpicker];
    }
    return self.loanReasonArr;
}

-(NSMutableArray *)giveStatesPickerArr
{
    NSArray *statesArr = [_responseDic objectForKey:@"states"];
    self.statesArr = [NSMutableArray array];
    for (NSDictionary *dic in statesArr)
    {
        Pickers *statespicker = [[Pickers alloc]init];
        statespicker.id_state = [dic objectForKey:@"id"];
        statespicker.maxpin = [dic objectForKey:@"maxPinPrefix"];
        statespicker.minpin = [dic objectForKey:@"minPinPrefix"];
        statespicker.stateName = [dic objectForKey:@"state_name"];
        
        [self.statesArr addObject:statespicker];
    }
    return self.statesArr;
}

-(NSMutableArray *)giveResidencePickerArr {
    self.residenceArr = [NSMutableArray array];
    NSArray *ownerShipArr = [_responseDic objectForKey:@"ownership_types"];

    for (NSDictionary *dic in ownerShipArr) {
        Pickers *residencepicker = [[Pickers alloc]init];
        residencepicker.id_owner = [dic objectForKey:@"id"];
        residencepicker.owner_type = [dic objectForKey:@"ownership_type"];
        [self.residenceArr addObject:residencepicker];
    }
    
    return self.residenceArr;
}

-(NSMutableArray *)giveSalPickerArr
{
    NSArray *salArr = [_responseDic objectForKey:@"salary_modes"];
    self.salModeArr = [NSMutableArray array];
    for (NSDictionary *dic in salArr)
    {
        Pickers *salpicker = [[Pickers alloc]init];
        salpicker.id_sal = [dic objectForKey:@"id"];
        salpicker.salmode = [dic objectForKey:@"mode"];
        [self.salModeArr addObject:salpicker];
    }
    
    return self.salModeArr;
}

@end
