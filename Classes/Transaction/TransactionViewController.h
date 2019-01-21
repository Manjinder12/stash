//
//  TransactionViewController.h
//  StashFin
//
//  Created by sachin khard on 13/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionViewController : UIViewController {
    IBOutlet UISearchBar *searchBar;
    BOOL isAscending;
}

@property (strong, nonatomic) UIButton *sortButton;
@property (strong, nonatomic) NSArray *transactionArray;
@property (strong, nonatomic) NSArray *analysisArray;
@property (strong, nonatomic) NSArray *searchListArray;

@property (weak, nonatomic) IBOutlet UIButton *transactionButton;
@property (weak, nonatomic) IBOutlet UIButton *analysisButton;
@property (weak, nonatomic) IBOutlet UITableView *transactionTableView;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLabelXConstraint;

@end
