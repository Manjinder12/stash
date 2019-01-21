//
//  FILeftMenuTableViewCell.m
//  mCollect
//
//  Created by Mac on 10/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "FILeftMenuTableViewCell.h"

@implementation FILeftMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
