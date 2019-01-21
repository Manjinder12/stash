//
//  MenuModel.m
//  mCollect
//
//  Created by Mac on 10/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

+ (instancetype) initMenuWithTitle:(NSString*)title
                            menuId:(NSString*)menuId
                      andImageName:(NSString*)imageName
                          andOrder:(NSNumber *)order
                     andVisibility:(BOOL)visible{
    MenuModel * menuModel = [[MenuModel alloc] init];
    menuModel.title = title;
    menuModel.menuID = menuId;
    menuModel.imageName = imageName;
    menuModel.order = order;
    menuModel.visible = visible;
    return menuModel;    
}


@end
