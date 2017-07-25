//
//  City.m
//  Stasheasy
//
//  Created by tushar on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "City.h"

@implementation City

-(NSMutableArray *)getCityModalArray:(NSArray *)cityArr {
    NSMutableArray *citymArr = [NSMutableArray array];
    for (NSDictionary *dic in cityArr) {
        City *cObj = [[City alloc]init];
        cObj.cityName = [dic objectForKey:@"city_name"];
        cObj.cityid = [dic objectForKey:@"id"];
        cObj.isOperational = [dic objectForKey:@"is_operational"];
        
        [citymArr addObject:cObj];
    }
    return citymArr;
}

@end
