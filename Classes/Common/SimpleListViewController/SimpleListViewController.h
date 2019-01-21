//
//  SimpleListViewController.h
//  StashFin
//
//  Created by Mac on 16/02/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SimpleListVCDelegate <NSObject>

- (void)selectedListOption:(NSInteger)selectedOption WithDropdownTag:(NSInteger)tag;

@end

@interface SimpleListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *trendingLabel;
@property (nonatomic, weak) id<SimpleListVCDelegate> delegate;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, assign) NSInteger dropdowntag;
@end
