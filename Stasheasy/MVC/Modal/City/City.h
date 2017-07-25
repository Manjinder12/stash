//
//  City.h
//  Stasheasy
//
//  Created by tushar on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityid;
@property(nonatomic,strong)NSString *isOperational;

-(NSMutableArray *)getCityModalArray:(NSArray *)cityArr;
@end
