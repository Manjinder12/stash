//
//  Pickers.h
//  Stasheasy
//
//  Created by Tushar  on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pickers : NSObject

// loan reason
@property(nonatomic,strong) NSString *id_loaon_reason;
@property(nonatomic,strong) NSString *loanreason;

@property (nonatomic,strong) NSMutableArray *loanReasonArr;

// States
@property(nonatomic,strong) NSString *id_state;
@property(nonatomic,strong) NSString *maxpin;
@property(nonatomic,strong) NSString *minpin;
@property(nonatomic,strong) NSString *stateName;
@property (nonatomic,strong) NSMutableArray *statesArr;


//ownership Types
@property(nonatomic,strong) NSString *id_owner;
@property(nonatomic,strong) NSString *owner_type;
@property (nonatomic,strong) NSMutableArray *residenceArr;

//salary mode
@property(nonatomic,strong) NSString *id_sal;
@property(nonatomic,strong) NSString *salmode;
@property (nonatomic,strong) NSMutableArray *salModeArr;

//response array
@property(nonatomic,strong) NSDictionary *responseDic;

-(NSMutableArray *)giveLoanPickerArr;
-(NSMutableArray *)giveStatesPickerArr;
-(NSMutableArray *)giveResidencePickerArr;
-(NSMutableArray *)giveSalPickerArr;


@end
