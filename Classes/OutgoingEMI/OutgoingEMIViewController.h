//
//  OutgoingEMIViewController.h
//  StashFin
//
//  Created by Mac on 12/06/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutgoingEMIViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *emiArray;

@end
