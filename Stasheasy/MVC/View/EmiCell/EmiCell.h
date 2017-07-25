//
//  EmiCell.h
//  Stasheasy
//
//  Created by tushar on 18/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sliderOuterView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *amntLbl;
@property (weak, nonatomic) IBOutlet UILabel *startlimitlbl;
@property (weak, nonatomic) IBOutlet UILabel *endLimitLbl;
@property (nonatomic,assign) int cellrow;
-(void)setupcellConfig:(int)row;
- (IBAction)slidervalueChanged:(id)sender;

@end
