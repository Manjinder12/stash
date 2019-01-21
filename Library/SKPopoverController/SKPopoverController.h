#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SKPopoverControllerDelegate;
@class SKPopoverTheme;

#ifndef SK_POPOVER_DEFAULT_ANIMATION_DURATION
    #define SK_POPOVER_DEFAULT_ANIMATION_DURATION    .25f
#endif

#ifndef SK_POPOVER_MIN_SIZE
    #define SK_POPOVER_MIN_SIZE                      CGSizeMake(240, 160)
#endif

typedef NS_OPTIONS(NSUInteger, SKPopoverArrowDirection) {
    SKPopoverArrowDirectionUp = 1UL << 0,
    SKPopoverArrowDirectionDown = 1UL << 1,
    SKPopoverArrowDirectionLeft = 1UL << 2,
    SKPopoverArrowDirectionRight = 1UL << 3,
    SKPopoverArrowDirectionNone = 1UL << 4,
    SKPopoverArrowDirectionAny = SKPopoverArrowDirectionUp | SKPopoverArrowDirectionDown | SKPopoverArrowDirectionLeft | SKPopoverArrowDirectionRight,
    SKPopoverArrowDirectionUnknown = NSUIntegerMax
};

typedef NS_OPTIONS(NSUInteger, SKPopoverAnimationOptions) {
    SKPopoverAnimationOptionFade = 1UL << 0,            // default
    SKPopoverAnimationOptionScale = 1UL << 1,
    SKPopoverAnimationOptionFadeWithScale = SKPopoverAnimationOptionFade | SKPopoverAnimationOptionScale
};

////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SKPopoverBackgroundView : UIView

@property (nonatomic, strong) UIColor *tintColor                UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *fillTopColor             UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *fillBottomColor          UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *glossShadowColor         UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize   glossShadowOffset        UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  glossShadowBlurRadius    UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) NSUInteger  borderWidth              UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  arrowBase                UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  arrowHeight              UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *outerShadowColor         UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *outerStrokeColor         UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  outerShadowBlurRadius    UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize   outerShadowOffset        UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  outerCornerRadius        UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  minOuterCornerRadius     UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *innerShadowColor         UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *innerStrokeColor         UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  innerShadowBlurRadius    UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize   innerShadowOffset        UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger  innerCornerRadius        UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets viewContentInsets    UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *overlayColor             UI_APPEARANCE_SELECTOR;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SKPopoverController : NSObject <UIAppearanceContainer>

@property (nonatomic, weak) id <SKPopoverControllerDelegate> delegate;

@property (nonatomic, copy) NSArray                            *passthroughViews;
@property (nonatomic, assign) BOOL                              wantsDefaultContentAppearance;
@property (nonatomic, assign) UIEdgeInsets                      popoverLayoutMargins;
@property (nonatomic, readonly, getter=isPopoverVisible) BOOL   popoverVisible;
@property (nonatomic, strong, readonly) UIViewController       *contentViewController;
@property (nonatomic, assign) CGSize                            popoverContentSize;
@property (nonatomic, assign) float                             animationDuration;

@property (nonatomic, strong) SKPopoverTheme                   *theme;

+ (void)setDefaultTheme:(SKPopoverTheme *)theme;
+ (SKPopoverTheme *)defaultTheme;

// initialization

- (id)initWithContentViewController:(UIViewController *)viewController;

// theme

- (void)beginThemeUpdates;
- (void)endThemeUpdates;

// Present popover from classic views methods

- (void)presentPopoverFromRect:(CGRect)rect
                        inView:(UIView *)view
      permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated;

- (void)presentPopoverFromRect:(CGRect)rect
                        inView:(UIView *)view
      permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

- (void)presentPopoverFromRect:(CGRect)rect
                        inView:(UIView *)view
      permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated
                       options:(SKPopoverAnimationOptions)options;

- (void)presentPopoverFromRect:(CGRect)rect
                        inView:(UIView *)view
      permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                      animated:(BOOL)animated
                       options:(SKPopoverAnimationOptions)options
                    completion:(void (^)(void))completion;

// Present popover from bar button items methods

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item
               permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                               animated:(BOOL)animated;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item
               permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                               animated:(BOOL)animated
                             completion:(void (^)(void))completion;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item
               permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                               animated:(BOOL)animated
                                options:(SKPopoverAnimationOptions)options;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item
               permittedArrowDirections:(SKPopoverArrowDirection)arrowDirections
                               animated:(BOOL)animated
                                options:(SKPopoverAnimationOptions)options
                             completion:(void (^)(void))completion;

// Present popover as dialog methods

- (void)presentPopoverAsDialogAnimated:(BOOL)animated;

- (void)presentPopoverAsDialogAnimated:(BOOL)animated
                            completion:(void (^)(void))completion;

- (void)presentPopoverAsDialogAnimated:(BOOL)animated
                               options:(SKPopoverAnimationOptions)options;

- (void)presentPopoverAsDialogAnimated:(BOOL)animated
                               options:(SKPopoverAnimationOptions)options
                            completion:(void (^)(void))completion;

// Dismiss popover methods

- (void)dismissPopoverAnimated:(BOOL)animated;

- (void)dismissPopoverAnimated:(BOOL)animated
                    completion:(void (^)(void))completion;

- (void)dismissPopoverAnimated:(BOOL)animated
                       options:(SKPopoverAnimationOptions)aOptions;

- (void)dismissPopoverAnimated:(BOOL)animated
                       options:(SKPopoverAnimationOptions)aOptions
                    completion:(void (^)(void))completion;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol SKPopoverControllerDelegate <NSObject>
@optional

- (BOOL)popoverControllerShouldDismissPopover:(SKPopoverController *)popoverController;

- (void)popoverControllerDidPresentPopover:(SKPopoverController *)popoverController;

- (void)popoverControllerDidDismissPopover:(SKPopoverController *)popoverController;

- (void)popoverController:(SKPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view;

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(SKPopoverController *)popoverController;

- (void)popoverController:(SKPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SKPopoverTheme : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *fillTopColor;
@property (nonatomic, strong) UIColor *fillBottomColor;

@property (nonatomic, strong) UIColor *glossShadowColor;
@property (nonatomic, assign) CGSize   glossShadowOffset;
@property (nonatomic, assign) NSUInteger  glossShadowBlurRadius;

@property (nonatomic, assign) NSUInteger  borderWidth;
@property (nonatomic, assign) NSUInteger  arrowBase;
@property (nonatomic, assign) NSUInteger  arrowHeight;

@property (nonatomic, strong) UIColor *outerShadowColor;
@property (nonatomic, strong) UIColor *outerStrokeColor;
@property (nonatomic, assign) NSUInteger  outerShadowBlurRadius;
@property (nonatomic, assign) CGSize   outerShadowOffset;
@property (nonatomic, assign) NSUInteger  outerCornerRadius;
@property (nonatomic, assign) NSUInteger  minOuterCornerRadius;

@property (nonatomic, strong) UIColor *innerShadowColor;
@property (nonatomic, strong) UIColor *innerStrokeColor;
@property (nonatomic, assign) NSUInteger  innerShadowBlurRadius;
@property (nonatomic, assign) CGSize   innerShadowOffset;
@property (nonatomic, assign) NSUInteger  innerCornerRadius;

@property (nonatomic, assign) UIEdgeInsets viewContentInsets;

@property (nonatomic, strong) UIColor *overlayColor;

+ (instancetype)theme;
+ (instancetype)themeForIOS6;
+ (instancetype)themeForIOS7;

@end
