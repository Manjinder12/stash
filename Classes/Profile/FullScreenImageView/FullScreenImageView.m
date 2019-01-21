//
//  FullScreenImageView.m
//  StashFin
//
//  Created by sachin khard on 12/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "FullScreenImageView.h"

@implementation FullScreenImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FullScreenImageView" owner:self options:nil] firstObject];
        self.frame = frame;
        
        self.alpha = 0;

        self.mainImageView.layer.cornerRadius = 10;
        self.mainImageView.layer.masksToBounds = YES;
        
        self.bgScrollView.layer.cornerRadius = 10;
        self.bgScrollView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)showLargeImageView:(NSString *)imageURL {
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
    self.bgScrollView.zoomScale = self.bgScrollView.minimumZoomScale;
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
    }];
}

- (IBAction)closeButtonClicked:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        self.alpha = 0;
    }];
}

#pragma mark UIScrollView Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageFromView;
    
    for (UIView *sub in self.bgScrollView.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            imageFromView = (UIImageView *)sub;
            break;
        }
    }
    return imageFromView;
}

@end
