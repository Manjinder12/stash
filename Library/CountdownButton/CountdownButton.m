//
//  CountdownButton.m
//  StashFin
//
//  Created by sachin khard on 30/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "CountdownButton.h"


@interface CountdownButton()

@end

@implementation CountdownButton

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)disableButtonAndStartTimer {
    self.count = 60;
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"%@ (%d)",@"Resend OTP", self.count] forState:UIControlStateNormal];
    
    self.clockTimer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(clockDidTick:)
                                       userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.clockTimer forMode:NSRunLoopCommonModes];
}

- (void)clockDidTick:(NSTimer *)timer
{
    if (self.count <= 1) {
        self.enabled = YES;
        [self setTitle:@"Resend OTP" forState:UIControlStateNormal];
        [self.clockTimer invalidate];
    }
    else {
        self.count--;
        [self setTitle:[NSString stringWithFormat:@"%@ (%d)",@"Resend OTP", self.count] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [self.clockTimer invalidate];
}

@end
