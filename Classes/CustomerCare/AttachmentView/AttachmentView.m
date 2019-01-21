//
//  AttachmentView.m
//  StashFin
//
//  Created by sachin khard on 27/05/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "AttachmentView.h"

@implementation AttachmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AttachmentView" owner:self options:nil] firstObject];
        self.frame = frame;
        
        [self.textLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    }
    return self;
}

@end
