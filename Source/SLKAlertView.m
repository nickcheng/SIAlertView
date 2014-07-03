//
//  SLKAlertView.m
//  Slack
//
//  Created by Ignacio Romero Z. on 7/3/14.
//  Based on SIAlerView from Kevin Cao https://github.com/Sumi-Interactive/SLKAlertView
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.

#import "SLKAlertView.h"
#import "SLAppearance.h"

#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"
#import "UIColor+Effect.h"

#define MESSAGE_MIN_LINE_COUNT 3
#define MESSAGE_MAX_LINE_COUNT 10
#define TITLE_MIN_LINE_COUNT 2

#define GAP 6.0
#define CANCEL_BUTTON_PADDING_TOP 5.0
#define CONTENT_PADDING_LEFT 17.0
#define CONTENT_PADDING_TOP 22.0
#define CONTENT_PADDING_BOTTOM CONTENT_PADDING_TOP/2.0
#define BUTTON_PADDING_LEFT 0.0
#define BUTTON_HEIGHT 56.0
#define BUTTON_BORDER_WIDTH 1.0
#define CONTAINER_WIDTH 300

NSString *const SLKAlertViewWillShowNotification = @"SLKAlertViewWillShowNotification";
NSString *const SLKAlertViewDidShowNotification = @"SLKAlertViewDidShowNotification";
NSString *const SLKAlertViewWillDismissNotification = @"SLKAlertViewWillDismissNotification";
NSString *const SLKAlertViewDidDismissNotification = @"SLKAlertViewDidDismissNotification";

const UIWindowLevel UIWindowLevelSLKAlert = 1996.0;  // don't overlap system's alert
const UIWindowLevel UIWindowLevelSLKAlertBackground = 1985.0; // below the alert window

@class SLKAlertBackgroundWindow;

static NSMutableArray *__si_alert_queue;
static BOOL __si_alert_animating;
static SLKAlertBackgroundWindow *__si_alert_background_window;
static SLKAlertView *__si_alert_current_view;

@interface SLKAlertView ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, assign) UIViewTintAdjustmentMode oldTintAdjustmentMode;

@property (nonatomic, assign, getter = isVisible) BOOL visible;
@property (nonatomic, assign, getter = isLayoutDirty) BOOL layoutDirty;

+ (NSMutableArray *)sharedQueue;
+ (SLKAlertView *)currentAlertView;

+ (BOOL)isAnimating;
+ (void)setAnimating:(BOOL)animating;

+ (void)showBackground;
+ (void)hideBackgroundAnimated:(BOOL)animated;

- (void)setup;
- (void)invalidateLayout;
- (void)resetTransition;

@end

#pragma mark - SIBackgroundWindow

@interface SLKAlertBackgroundWindow : UIWindow
@end

@interface SLKAlertBackgroundWindow ()
@property (nonatomic, assign) SLKAlertViewBackgroundStyle style;
@end

@implementation SLKAlertBackgroundWindow

- (id)initWithFrame:(CGRect)frame andStyle:(SLKAlertViewBackgroundStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelSLKAlertBackground;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case SLKAlertViewBackgroundStyleGradient:
        {
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            break;
        }
        case SLKAlertViewBackgroundStyleSolid:
        {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}

@end


#pragma mark - UIWindow+ViewController

@interface UIWindow (ViewController)
- (UIViewController *)currentViewController;
- (UIViewController *)viewControllerForStatusBarStyle;
- (UIViewController *)viewControllerForStatusBarHidden;
@end

@implementation UIWindow (ViewController)

- (UIViewController *)currentViewController
{
    UIViewController *viewController = self.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

- (UIViewController *)viewControllerForStatusBarStyle
{
    UIViewController *currentViewController = [self currentViewController];
    
    while ([currentViewController childViewControllerForStatusBarStyle]) {
        currentViewController = [currentViewController childViewControllerForStatusBarStyle];
    }
    return currentViewController;
}

- (UIViewController *)viewControllerForStatusBarHidden
{
    UIViewController *currentViewController = [self currentViewController];
    
    while ([currentViewController childViewControllerForStatusBarHidden]) {
        currentViewController = [currentViewController childViewControllerForStatusBarHidden];
    }
    return currentViewController;
}

@end


#pragma mark - SLKAlertItem

@interface SLKAlertItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SLKAlertViewButtonType type;
@property (nonatomic, copy) SLKAlertViewBlock action;
@end

@implementation SLKAlertItem
@end

#pragma mark - SLKAlertViewController

@interface SLKAlertViewController : UIViewController
@property (nonatomic, strong) SLKAlertView *alertView;
@end

@implementation SLKAlertViewController

#pragma mark - View life cycle

- (void)loadView
{
    self.view = self.alertView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.alertView setup];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.alertView resetTransition];
    [self.alertView invalidateLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIWindow *window = self.alertView.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    return [[window viewControllerForStatusBarStyle] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    UIWindow *window = self.alertView.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    return [[window viewControllerForStatusBarHidden] prefersStatusBarHidden];
}

@end


#pragma mark - Initialization

@implementation SLKAlertView

+ (void)initialize
{
    if (self != [SLKAlertView class])
        return;
    
    SLKAlertView *appearance = [self appearance];
    appearance.viewBackgroundColor = [UIColor whiteColor];
    appearance.titleColor = [UIColor colorFromHex:@"3C4B5B"];
    appearance.messageColor = [UIColor colorFromHex:@"8A8B8B"];
    appearance.titleFont = [UIFont slackBoldFontOfSize:20.0];
    appearance.messageFont = [UIFont slackFontOfSize:14.0];
    appearance.buttonFont = [UIFont slackFontOfSize:18.0];
    appearance.buttonColor = [UIColor keyColor];
    appearance.cancelButtonColor = [UIColor colorFromHex:@"878787"];
    appearance.destructiveButtonColor = [UIColor destructiveColor];
    appearance.cornerRadius = 10.0;
}

- (instancetype)init
{
	return [self initWithTitle:nil message:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
{
	self = [super init];
	if (self) {
		_title = title;
        _message = message;
        _enableParallaxEffect = YES;
		self.items = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle didCancel:(SLKAlertViewBlock)cancelled
{
    return [self showWithTitle:title message:message acceptButtonTitle:nil cancelButtonTitle:cancelTitle didAccept:NULL didCancel:cancelled];
}

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message acceptButtonTitle:(NSString *)acceptTitle cancelButtonTitle:(NSString *)cancelTitle didAccept:(SLKAlertViewBlock)accepted didCancel:(SLKAlertViewBlock)cancelled
{
    SLKAlertView *alert = [[SLKAlertView alloc] initWithTitle:title message:message];
    if (alert) {
        if (cancelTitle) [alert addButtonWithTitle:cancelTitle type:SLKAlertViewButtonTypeCancel handler:cancelled];
        if (acceptTitle) [alert addButtonWithTitle:acceptTitle type:SLKAlertViewButtonTypeDefault handler:accepted];
        [alert show];
    }
    return alert;
}


#pragma mark - Class methods

+ (NSMutableArray *)sharedQueue
{
    if (!__si_alert_queue) {
        __si_alert_queue = [NSMutableArray array];
    }
    return __si_alert_queue;
}

+ (SLKAlertView *)currentAlertView
{
    return __si_alert_current_view;
}

+ (void)setCurrentAlertView:(SLKAlertView *)alertView
{
    __si_alert_current_view = alertView;
}

+ (BOOL)isAnimating
{
    return __si_alert_animating;
}

+ (void)setAnimating:(BOOL)animating
{
    __si_alert_animating = animating;
}

+ (void)showBackground
{
    if (!__si_alert_background_window) {
        __si_alert_background_window = [[SLKAlertBackgroundWindow alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                              andStyle:[SLKAlertView currentAlertView].backgroundStyle];
        [__si_alert_background_window makeKeyAndVisible];
        __si_alert_background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             __si_alert_background_window.alpha = 1;
                         }];
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated
{
    if (!animated) {
        [__si_alert_background_window removeFromSuperview];
        __si_alert_background_window = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         __si_alert_background_window.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__si_alert_background_window removeFromSuperview];
                         __si_alert_background_window = nil;
                     }];
}


#pragma mark - Getters

- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView.backgroundColor = _viewBackgroundColor ? _viewBackgroundColor : [UIColor whiteColor];
        _containerView.layer.cornerRadius = self.cornerRadius;
        _containerView.layer.masksToBounds = YES;
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = self.titleFont;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.numberOfLines = TITLE_MIN_LINE_COUNT;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.containerView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        _messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = self.messageFont;
        _messageLabel.textColor = self.messageColor;
        _messageLabel.numberOfLines = MESSAGE_MAX_LINE_COUNT;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.containerView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index
{
    SLKAlertItem *item = self.items[index];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.tag = index;
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = self.buttonFont;
    
	[button setTitle:item.title forState:UIControlStateNormal];
    
	switch (item.type) {
		case SLKAlertViewButtonTypeCancel:
			[button setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.cancelButtonColor darkerColor] forState:UIControlStateHighlighted];
			break;
		case SLKAlertViewButtonTypeDestructive:
            [button setTitleColor:self.destructiveButtonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.destructiveButtonColor darkerColor] forState:UIControlStateHighlighted];
			break;
		case SLKAlertViewButtonTypeDefault:
		default:
			[button setTitleColor:self.buttonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.buttonColor darkerColor] forState:UIControlStateHighlighted];
			break;
	}
    
    [button setBackgroundImage:[self backgroundImageForColor:[UIColor colorWithWhite:0.0 alpha:0.0625]] forState:UIControlStateHighlighted];
    
    button.layer.borderColor = [UIColor colorFromHex:@"cdcdcd"].CGColor;
    button.layer.borderWidth = BUTTON_BORDER_WIDTH;
    
	[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIImage *)backgroundImageForColor:(UIColor *)color
{
    CGFloat height = 50.0;
    CGRect rect = CGRectMake(0, 0, 2.0, height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    // Rounded Rectangle Drawing
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    [color setFill];
    [path fill];
    
    // Create the image using the current context.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _title = title;
	[self invalidateLayout];
}

- (void)setMessage:(NSString *)message
{
	_message = message;
    [self invalidateLayout];
}

- (void)addButtonWithTitle:(NSString *)title type:(SLKAlertViewButtonType)type handler:(SLKAlertViewBlock)handler
{
    SLKAlertItem *item = [[SLKAlertItem alloc] init];
	item.title = title;
	item.type = type;
	item.action = handler;
	[self.items addObject:item];
}


#pragma mark - UIAppearance setters

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    if (_viewBackgroundColor == viewBackgroundColor) {
        return;
    }
    
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont == titleFont) {
        return;
    }
    
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
    [self invalidateLayout];
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if (_messageFont == messageFont) {
        return;
    }
    
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
    [self invalidateLayout];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor == titleColor) {
        return;
    }
    
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor == messageColor) {
        return;
    }
    
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    if (_buttonFont == buttonFont) {
        return;
    }
    
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setButtonColor:(UIColor *)buttonColor
{
    if (_buttonColor == buttonColor) {
        return;
    }
    
    _buttonColor = buttonColor;
    [self setColor:buttonColor toButtonsOfType:SLKAlertViewButtonTypeDefault];
}

- (void)setCancelButtonColor:(UIColor *)buttonColor
{
    if (_cancelButtonColor == buttonColor) {
        return;
    }
    
    _cancelButtonColor = buttonColor;
    [self setColor:buttonColor toButtonsOfType:SLKAlertViewButtonTypeCancel];
}

- (void)setDestructiveButtonColor:(UIColor *)buttonColor
{
    if (_destructiveButtonColor == buttonColor) {
        return;
    }
    
    _destructiveButtonColor = buttonColor;
    [self setColor:buttonColor toButtonsOfType:SLKAlertViewButtonTypeDestructive];
}

- (void)setColor:(UIColor *)color toButtonsOfType:(SLKAlertViewButtonType)type
{
    for (NSUInteger i = 0; i < self.items.count; i++) {
        SLKAlertItem *item = self.items[i];
        if(item.type == type) {
            UIButton *button = self.buttons[i];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitleColor:[color darkerColor] forState:UIControlStateHighlighted];
        }
    }
}


#pragma mark - Public

- (void)show
{
    if (self.isVisible) {
        return;
    }
    
    self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if ([self.oldKeyWindow respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        self.oldTintAdjustmentMode = self.oldKeyWindow.tintAdjustmentMode;
        self.oldKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }
    
    if (![[SLKAlertView sharedQueue] containsObject:self]) {
        [[SLKAlertView sharedQueue] addObject:self];
    }
    
    if ([SLKAlertView isAnimating]) {
        return; // wait for next turn
    }
    
    if ([SLKAlertView currentAlertView].isVisible) {
        return; // wait for next turn
    }
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SLKAlertViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    
    [SLKAlertView setAnimating:YES];
    [SLKAlertView setCurrentAlertView:self];
    
    // transition background
    [SLKAlertView showBackground];
    
    SLKAlertViewController *viewController = [[SLKAlertViewController alloc] initWithNibName:nil bundle:nil];
    viewController.alertView = self;
    
    if (!self.alertWindow)
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelSLKAlert;
        window.rootViewController = viewController;
        self.alertWindow = window;
    }
    [self.alertWindow makeKeyAndVisible];
    
    [self validateLayout];
    
    [self transitionInCompletion:^{
        if (self.didShowHandler) {
            self.didShowHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SLKAlertViewDidShowNotification object:self userInfo:nil];
        
        [self addParallaxEffect];
        
        [SLKAlertView setAnimating:NO];
        
        NSInteger index = [[SLKAlertView sharedQueue] indexOfObject:self];
        if (index < [SLKAlertView sharedQueue].count - 1) {
            [self dismissAnimated:YES cleanup:NO]; // dismiss to show next alert view
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup
{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SLKAlertViewWillDismissNotification object:self userInfo:nil];
        
        [self removeParallaxEffect];
    }
    
    void (^dismissComplete)(void) = ^{
        self.visible = NO;
        
        [self teardown];
        
        [SLKAlertView setCurrentAlertView:nil];
        
        SLKAlertView *nextAlertView;
        NSInteger index = [[SLKAlertView sharedQueue] indexOfObject:self];
        if (index != NSNotFound && index < [SLKAlertView sharedQueue].count - 1) {
            nextAlertView = [SLKAlertView sharedQueue][index + 1];
        }
        
        if (cleanup) {
            [[SLKAlertView sharedQueue] removeObject:self];
        }
        
        [SLKAlertView setAnimating:NO];
        
        if (isVisible) {
            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SLKAlertViewDidDismissNotification object:self userInfo:nil];
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
        if (nextAlertView) {
            [nextAlertView show];
        }
        else {
            // show last alert view
            if ([SLKAlertView sharedQueue].count > 0) {
                SLKAlertView *alert = [[SLKAlertView sharedQueue] lastObject];
                [alert show];
            }
        }
    };
    
    if (animated && isVisible)
    {
        [SLKAlertView setAnimating:YES];
        [self transitionOutCompletion:dismissComplete];
        
        if ([SLKAlertView sharedQueue].count == 1) {
            [SLKAlertView hideBackgroundAnimated:YES];
        }
        
    }
    else {
        dismissComplete();
        
        if ([SLKAlertView sharedQueue].count == 0) {
            [SLKAlertView hideBackgroundAnimated:YES];
        }
    }
    
    UIWindow *window = self.oldKeyWindow;
    
    if ([window respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        window.tintAdjustmentMode = self.oldTintAdjustmentMode;
    }
    
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}


#pragma mark - Transitions

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle)
    {
        case SLKAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SLKAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SLKAlertViewTransitionStyleFade:
        {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.containerView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SLKAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case SLKAlertViewTransitionStyleDropDown:
        {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle)
    {
        case SLKAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SLKAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SLKAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.containerView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case SLKAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case SLKAlertViewTransitionStyleDropDown:
        {
            CGPoint point = self.containerView.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.containerView.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 self.containerView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)resetTransition
{
    [self.containerView.layer removeAllAnimations];
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self validateLayout];
}

- (void)invalidateLayout
{
    self.layoutDirty = YES;
    [self setNeedsLayout];
}

- (void)validateLayout
{
    if (!self.isLayoutDirty) {
        return;
    }
    self.layoutDirty = NO;
    
    CGFloat height = [self preferredHeight];
    CGFloat left = roundf((self.bounds.size.width - CONTAINER_WIDTH) * 0.5);
    CGFloat top = roundf((self.bounds.size.height - height) * 0.5);
    
    self.containerView.transform = CGAffineTransformIdentity;
    self.containerView.frame = CGRectMake(left, top, CONTAINER_WIDTH, height);
    
    CGFloat y = CONTENT_PADDING_TOP;
    
	if (self.titleLabel)
    {
        self.titleLabel.text = self.title;
        CGFloat height = [self heightForTitleLabel];
        self.titleLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
	}
    if (self.messageLabel)
    {
        if (y > CONTENT_PADDING_TOP) {
            y += GAP;
        }
        self.messageLabel.text = self.message;
        CGFloat height = [self heightForMessageLabel];
        self.messageLabel.frame = CGRectMake(CONTENT_PADDING_LEFT, y, self.containerView.bounds.size.width - CONTENT_PADDING_LEFT * 2, height);
        y += height;
    }
    if (self.items.count > 0)
    {
        y = (CGRectGetMaxY(self.containerView.bounds)-BUTTON_HEIGHT)+BUTTON_BORDER_WIDTH;
        
        if (self.items.count == 1)
        {
            CGFloat width = self.containerView.bounds.size.width;
            width+=BUTTON_BORDER_WIDTH*2;
            
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(-BUTTON_BORDER_WIDTH, y, width, BUTTON_HEIGHT);
        }
        else if (self.items.count == 2)
        {
            CGFloat width = self.containerView.bounds.size.width/2.0;
            width+=BUTTON_BORDER_WIDTH;
            
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(-BUTTON_BORDER_WIDTH, y, width, BUTTON_HEIGHT);
            
            button = self.buttons[1];
            button.frame = CGRectMake(width-(BUTTON_BORDER_WIDTH*2), y, width+BUTTON_BORDER_WIDTH, BUTTON_HEIGHT);
        }
    }
}

- (CGFloat)preferredHeight
{
	CGFloat height = CONTENT_PADDING_TOP;
    
	if (self.title) {
		height += [self heightForTitleLabel];
	}
    if (self.message)
    {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        height += [self heightForMessageLabel];
    }
    if (self.items.count > 0)
    {
        if (height > CONTENT_PADDING_TOP) {
            height += GAP;
        }
        if (self.items.count > 0) {
            height += BUTTON_HEIGHT;
        }
    }
    
    height += CONTENT_PADDING_BOTTOM;
    
	return roundf(height);
}

- (CGFloat)heightForTitleLabel
{
    if (self.title.length > 0)
    {
        CGFloat maxHeight = self.titleLabel.font.lineHeight * TITLE_MIN_LINE_COUNT;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = self.titleLabel.lineBreakMode;
        paragraphStyle.alignment = self.titleLabel.textAlignment;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.titleLabel.font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        
        CGSize size = [self.title boundingRectWithSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        
        return roundf(size.height);
    }
    return 0.0;
}

- (CGFloat)heightForMessageLabel
{
    if (self.message.length > 0)
    {
        CGFloat minHeight = self.messageLabel.font.lineHeight * MESSAGE_MIN_LINE_COUNT;
        CGFloat maxHeight = self.messageLabel.font.lineHeight * MESSAGE_MAX_LINE_COUNT;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = self.messageLabel.lineBreakMode;
        paragraphStyle.alignment = self.messageLabel.textAlignment;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.messageLabel.font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        
        CGSize size = [self.message boundingRectWithSize:CGSizeMake(CONTAINER_WIDTH - CONTENT_PADDING_LEFT * 2, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        
        return roundf(MAX(minHeight, size.height+GAP));
    }
    return 0.0;
}


#pragma mark - Setup

- (void)setup
{
    [self updateTitleLabel];
    [self updateMessageLabel];
    [self setupButtons];
    [self invalidateLayout];
}

- (void)teardown
{
    [_containerView removeFromSuperview];
    _containerView = nil;
    _titleLabel = nil;
    _messageLabel = nil;
    
    [_buttons removeAllObjects];
    
    [_alertWindow removeFromSuperview];
    _alertWindow = nil;
    
    _layoutDirty = NO;
}

- (void)updateTitleLabel
{
	if (self.title.length > 0)
    {
		self.titleLabel.text = self.title;
	}
    else {
		[_titleLabel removeFromSuperview];
		_titleLabel = nil;
	}
    
    [self invalidateLayout];
}

- (void)updateMessageLabel
{
    if (self.message.length > 0)
    {
        self.messageLabel.text = self.message;
    }
    else {
        [_messageLabel removeFromSuperview];
        _messageLabel = nil;
    }
    
    [self invalidateLayout];
}

- (void)setupButtons
{
    if (self.items.count == 0) {
        [self addButtonWithTitle:@"OK" type:SLKAlertViewButtonTypeCancel handler:NULL];
    }
    
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    
    for (NSUInteger i = 0; i < self.items.count; i++)
    {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}


#pragma mark - Actions

- (void)buttonAction:(UIButton *)button
{
	[SLKAlertView setAnimating:YES]; // set this flag to YES in order to prevent showing another alert in action block
    
    SLKAlertItem *item = self.items[button.tag];
    
	if (item.action) {
		item.action(self);
	}
    
	[self dismissAnimated:YES];
}


#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}


#pragma mark - Enable parallax effect

- (void)addParallaxEffect
{
    if (_enableParallaxEffect && NSClassFromString(@"UIInterpolatingMotionEffect"))
    {
        UIInterpolatingMotionEffect *effectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"position.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        UIInterpolatingMotionEffect *effectVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"position.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        [effectHorizontal setMaximumRelativeValue:@(20.0f)];
        [effectHorizontal setMinimumRelativeValue:@(-20.0f)];
        [effectVertical setMaximumRelativeValue:@(50.0f)];
        [effectVertical setMinimumRelativeValue:@(-50.0f)];
        [self.containerView addMotionEffect:effectHorizontal];
        [self.containerView addMotionEffect:effectVertical];
    }
}

- (void)removeParallaxEffect
{
    if (_enableParallaxEffect && NSClassFromString(@"UIInterpolatingMotionEffect"))
    {
        [self.containerView.motionEffects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.containerView removeMotionEffect:obj];
        }];
    }
}

@end
