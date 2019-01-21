//
//  GetCardViewController.h
//  StashFin
//
//  Created by sachin khard on 20/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *getCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCardButton;

- (IBAction)getCardButtonAction:(id)sender;

@end
