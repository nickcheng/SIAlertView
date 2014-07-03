//
//  SLKAlertView.h
//  Slack
//
//  Created by Ignacio Romero Z. on 7/3/14.
//  Based on SIAlerView from Kevin Cao https://github.com/Sumi-Interactive/SIAlertView
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.

#import <UIKit/UIKit.h>

extern NSString *const SLKAlertViewWillShowNotification;
extern NSString *const SLKAlertViewDidShowNotification;
extern NSString *const SLKAlertViewWillDismissNotification;
extern NSString *const SLKAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, SLKAlertViewButtonType) {
    SLKAlertViewButtonTypeDefault,
    SLKAlertViewButtonTypeDestructive,
    SLKAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, SLKAlertViewBackgroundStyle) {
    SLKAlertViewBackgroundStyleSolid,
    SLKAlertViewBackgroundStyleGradient,
};

typedef NS_ENUM(NSInteger, SLKAlertViewTransitionStyle) {
    SLKAlertViewTransitionStyleDropDown,
    SLKAlertViewTransitionStyleSlideFromBottom,
    SLKAlertViewTransitionStyleSlideFromTop,
    SLKAlertViewTransitionStyleFade,
    SLKAlertViewTransitionStyleBounce,
    
};

@class SLKAlertView;

typedef void(^SLKAlertViewBlock)(SLKAlertView *alertView);

@interface SLKAlertView : UIView

/** The alert title */
@property (nonatomic, copy) NSString *title;
/** The alert message */
@property (nonatomic, copy) NSString *message;
/** The alert background color. Default is white. */
@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert title color. Default is #3C4B5B */
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert message color. Default is #8A8B8B */
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert title font. Default is Lato-Bold 20pts. */
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert message font. Default is Lato 14pts. */
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert button font. Default is Lato 18pts. */
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert default button color. Default is #3EBA92 */
@property (nonatomic, strong) UIColor *buttonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert cancel button color. Default is #878787 */
@property (nonatomic, strong) UIColor *cancelButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert destructive button color. Default is #EB4D5B */
@property (nonatomic, strong) UIColor *destructiveButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
/** The alert corner radius. Default is 10.0 */
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

/** The alert transition style. Default is SLKAlertViewTransitionStyleSlideFromBottom */
@property (nonatomic, assign) SLKAlertViewTransitionStyle transitionStyle;
/** The alert background style. Default is SLKAlertViewBackgroundStyleSolid */
@property (nonatomic, assign) SLKAlertViewBackgroundStyle backgroundStyle;

/** A block object triggered when the alert will be shown. */
@property (nonatomic, copy) SLKAlertViewBlock willShowHandler;
/** A block object triggered when the alert did shown. */
@property (nonatomic, copy) SLKAlertViewBlock didShowHandler;
/** A block object triggered when the alert will be dismissed. */
@property (nonatomic, copy) SLKAlertViewBlock willDismissHandler;
/** A block object triggered when the alert was dismissed. */
@property (nonatomic, copy) SLKAlertViewBlock didDismissHandler;

/** YES if the alert is visible */
@property (nonatomic, readonly, getter = isVisible) BOOL visible;
/** YES if the parallax effect should be enabled. */
@property (nonatomic, getter = isParallaxEffectEnabled) BOOL enableParallaxEffect; // default is YES

/**
 Convenience method for initializing an alert view.
 
 @param title The alert title
 @param message The alert message
 @returns The newly initialized alert view.
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

/**
 Convenience method for initializing an alert view.
 
 @param title The alert title
 @param message The alert message
 @paran cancelButtonTitle The cancel button title.
 @paran cancelled A block object to be triggered when the button is tapped.
 @returns The newly initialized alert view.
 */
+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle didCancel:(SLKAlertViewBlock)cancelled;

/**
 Convenience method for initializing an alert view.
 
 @param title The alert title
 @param message The alert message
 @paran cancelButtonTitle The cancel button title.
 @paran acceptTitle The accept button title.
 @paran didAccept A block object to be triggered when the button is tapped.
 @paran cancelled A block object to be triggered when the button is tapped.
 */
+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message acceptButtonTitle:(NSString *)acceptTitle cancelButtonTitle:(NSString *)cancelTitle didAccept:(SLKAlertViewBlock)accepted didCancel:(SLKAlertViewBlock)cancelled;

/**
 Displays the receiver using animation.
 */
- (void)show;

/**
 Dismisses the receiver, optionally with animation.
 
 @param animated YES if the alert should be dismissed with animation. 
 */
- (void)dismissAnimated:(BOOL)animated;

@end
