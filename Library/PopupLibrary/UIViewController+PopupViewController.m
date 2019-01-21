//
//  UIViewController+PopupViewController.m
//  StashFin
//
//  Created by Mac on 05/03/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "UIViewController+PopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PopupBackgroundView.h"
#import <objc/runtime.h>

#define kPopupModalAnimationDuration 0.35
#define kPopupViewController @"kPopupViewController"
#define kPopupBackgroundView @"kPopupBackgroundView"
#define kSourceViewTag 23941
#define kPopupViewTag 23942
#define kOverlayViewTag 23945

@interface UIViewController (PopupViewControllerPrivate)
- (UIView*)topView;
- (void)presentPopupView:(UIView*)popupView;
@end

static NSString *SKPopupViewDismissedKey = @"SKPopupViewDismissed";

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (PopupViewController)

static void * const keypath = (void*)&keypath;

- (UIViewController*)sk_popupViewController {
    return objc_getAssociatedObject(self, kPopupViewController);
}

- (void)setSk_popupViewController:(UIViewController *)sk_popupViewController {
    objc_setAssociatedObject(self, kPopupViewController, sk_popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (PopupBackgroundView*)sk_popupBackgroundView {
    return objc_getAssociatedObject(self, kPopupBackgroundView);
}

- (void)setSk_popupBackgroundView:(PopupBackgroundView *)sk_popupBackgroundView {
    objc_setAssociatedObject(self, kPopupBackgroundView, sk_popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(SKPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed
{
    self.sk_popupViewController = popupViewController;
    [self presentPopupView:popupViewController.view animationType:animationType dismissed:dismissed];
}

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(SKPopupViewAnimation)animationType
{
    [self presentPopupViewController:popupViewController animationType:animationType dismissed:nil];
}

- (void)dismissPopupViewControllerWithanimationType:(SKPopupViewAnimation)animationType
{
    UIView *sourceView = [self topView];
    UIView *popupView = [sourceView viewWithTag:kPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kOverlayViewTag];
    
    switch (animationType) {
        case SKPopupViewAnimationSlideBottomTop:
        case SKPopupViewAnimationSlideBottomBottom:
        case SKPopupViewAnimationSlideTopTop:
        case SKPopupViewAnimationSlideTopBottom:
        case SKPopupViewAnimationSlideLeftLeft:
        case SKPopupViewAnimationSlideLeftRight:
        case SKPopupViewAnimationSlideRightLeft:
        case SKPopupViewAnimationSlideRightRight:
            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
            break;
            
        default:
            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }
}



////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling

- (void)presentPopupView:(UIView*)popupView animationType:(SKPopupViewAnimation)animationType
{
    [self presentPopupView:popupView animationType:animationType dismissed:nil];
}

- (void)presentPopupView:(UIView*)popupView animationType:(SKPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed
{
    UIView *sourceView = [self topView];
    sourceView.tag = kSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    self.sk_popupBackgroundView = [[PopupBackgroundView alloc] initWithFrame:sourceView.bounds];
    self.sk_popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sk_popupBackgroundView.backgroundColor = [UIColor clearColor];
    self.sk_popupBackgroundView.alpha = 0.0f;
    [overlayView addSubview:self.sk_popupBackgroundView];
    
    // Make the Background Clickable
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimation:) forControlEvents:UIControlEventTouchUpInside];
    switch (animationType) {
        case SKPopupViewAnimationSlideBottomTop:
        case SKPopupViewAnimationSlideBottomBottom:
        case SKPopupViewAnimationSlideTopTop:
        case SKPopupViewAnimationSlideTopBottom:
        case SKPopupViewAnimationSlideLeftLeft:
        case SKPopupViewAnimationSlideLeftRight:
        case SKPopupViewAnimationSlideRightLeft:
        case SKPopupViewAnimationSlideRightRight:
            dismissButton.tag = animationType;
            [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
            break;
        default:
            dismissButton.tag = SKPopupViewAnimationFade;
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }
    
    [self setDismissedCallback:dismissed];
}

-(UIView*)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (void)dismissPopupViewControllerWithanimation:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* dismissButton = sender;
        switch (dismissButton.tag) {
            case SKPopupViewAnimationSlideBottomTop:
            case SKPopupViewAnimationSlideBottomBottom:
            case SKPopupViewAnimationSlideTopTop:
            case SKPopupViewAnimationSlideTopBottom:
            case SKPopupViewAnimationSlideLeftLeft:
            case SKPopupViewAnimationSlideLeftRight:
            case SKPopupViewAnimationSlideRightLeft:
            case SKPopupViewAnimationSlideRightRight:
                [self dismissPopupViewControllerWithanimationType:dismissButton.tag];
                break;
            default:
                [self dismissPopupViewControllerWithanimationType:SKPopupViewAnimationFade];
                break;
        }
    } else {
        [self dismissPopupViewControllerWithanimationType:SKPopupViewAnimationFade];
    }
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations

#pragma mark --- Slide

- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(SKPopupViewAnimation)animationType
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    switch (animationType) {
        case SKPopupViewAnimationSlideBottomTop:
        case SKPopupViewAnimationSlideBottomBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        sourceSize.height,
                                        popupSize.width,
                                        popupSize.height);
            
            break;
        case SKPopupViewAnimationSlideLeftLeft:
        case SKPopupViewAnimationSlideLeftRight:
            popupStartRect = CGRectMake(-sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        case SKPopupViewAnimationSlideTopTop:
        case SKPopupViewAnimationSlideTopBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        -popupSize.height,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.sk_popupViewController viewWillAppear:NO];
        self.sk_popupBackgroundView.alpha = 1.0f;
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
        [self.sk_popupViewController viewDidAppear:NO];
    }];
}

- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(SKPopupViewAnimation)animationType
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    switch (animationType) {
        case SKPopupViewAnimationSlideBottomTop:
        case SKPopupViewAnimationSlideTopTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      -popupSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case SKPopupViewAnimationSlideBottomBottom:
        case SKPopupViewAnimationSlideTopBottom:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      sourceSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case SKPopupViewAnimationSlideLeftRight:
        case SKPopupViewAnimationSlideRightRight:
            popupEndRect = CGRectMake(sourceSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
        default:
            popupEndRect = CGRectMake(-popupSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
    }
    
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.sk_popupViewController viewWillDisappear:NO];
        popupView.frame = popupEndRect;
        self.sk_popupBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.sk_popupViewController viewDidDisappear:NO];
        self.sk_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil)
        {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark --- Fade

- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.sk_popupViewController viewWillAppear:NO];
        self.sk_popupBackgroundView.alpha = 0.5f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.sk_popupViewController viewDidAppear:NO];
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.sk_popupViewController viewWillDisappear:NO];
        self.sk_popupBackgroundView.alpha = 0.0f;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.sk_popupViewController viewDidDisappear:NO];
        self.sk_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil)
        {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark -
#pragma mark Category Accessors

#pragma mark --- Dismissed

- (void)setDismissedCallback:(void(^)(void))dismissed
{
    objc_setAssociatedObject(self, &SKPopupViewDismissedKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback
{
    return objc_getAssociatedObject(self, &SKPopupViewDismissedKey);
}

@end
