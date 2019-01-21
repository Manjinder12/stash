//
//  FILeftMenuViewController.h
//  StashFin
//
//  Created by Mac on 10/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface FILeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RESideMenuDelegate> {
    NSInteger selectedRow;
}

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)selectMenuActionWithIndex:(NSInteger)index;

@end
