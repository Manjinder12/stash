//
//  CountdownButton.h
//  StashFin
//
//  Created by sachin khard on 30/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownButton : UIButton

// Set this property will trigger the countdown timer start
@property(nonatomic) NSInteger count;

@property (strong, nonatomic) NSTimer *clockTimer;

- (void)disableButtonAndStartTimer;

@end
