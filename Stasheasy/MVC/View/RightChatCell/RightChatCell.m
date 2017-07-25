//
//  RightChatCell.m
//  Stasheasy
//
//  Created by Tushar  on 21/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "RightChatCell.h"

@implementation RightChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.chatView.layer.cornerRadius =5.0f;
    self.chatView.clipsToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
