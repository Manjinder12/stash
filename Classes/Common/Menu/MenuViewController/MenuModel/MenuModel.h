//
//  MenuModel.h
//  StashFin
//
//  Created by Mac on 10/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * menuID;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSNumber * order;
@property (nonatomic, getter=isVisible) BOOL visible;

+ (instancetype) initMenuWithTitle:(NSString*)title
                            menuId:(NSString*)menuId
                      andImageName:(NSString*)imageName
                          andOrder:(NSNumber*)order
                     andVisibility:(BOOL)visible;
@end
