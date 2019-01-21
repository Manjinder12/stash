//
//  UIViewController+PopupViewController.h
//  StashFin
//
//  Created by Mac on 05/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupBackgroundView;

typedef enum {
    SKPopupViewAnimationFade = 0,
    SKPopupViewAnimationSlideBottomTop = 1,
    SKPopupViewAnimationSlideBottomBottom,
    SKPopupViewAnimationSlideTopTop,
    SKPopupViewAnimationSlideTopBottom,
    SKPopupViewAnimationSlideLeftLeft,
    SKPopupViewAnimationSlideLeftRight,
    SKPopupViewAnimationSlideRightLeft,
    SKPopupViewAnimationSlideRightRight,
} SKPopupViewAnimation;

@interface UIViewController (PopupViewController)

@property (nonatomic, retain) UIViewController *sk_popupViewController;
@property (nonatomic, retain) PopupBackgroundView *sk_popupBackgroundView;

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(SKPopupViewAnimation)animationType;
- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(SKPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed;
- (void)dismissPopupViewControllerWithanimationType:(SKPopupViewAnimation)animationType;

@end
