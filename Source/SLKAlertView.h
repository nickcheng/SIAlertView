//
//  SLKAlertView.h
//  Slack
//
//  Created by Ignacio on 7/3/14.
//  Based on SIAlerView from Kevin Cao https://github.com/Sumi-Interactive/SIAlertView
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.

#import <UIKit/UIKit.h>

extern NSString *const SLKAlertViewWillShowNotification;
extern NSString *const SLKAlertViewDidShowNotification;
extern NSString *const SLKAlertViewWillDismissNotification;
extern NSString *const SLKAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, SLKAlertViewButtonType) {
    SLKAlertViewButtonTypeDefault = 0,
    SLKAlertViewButtonTypeDestructive,
    SLKAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, SLKAlertViewBackgroundStyle) {
    SLKAlertViewBackgroundStyleSolid = 0,
    SLKAlertViewBackgroundStyleGradient,
};

typedef NS_ENUM(NSInteger, SLKAlertViewTransitionStyle) {
    SLKAlertViewTransitionStyleSlideFromBottom = 0,
    SLKAlertViewTransitionStyleSlideFromTop,
    SLKAlertViewTransitionStyleFade,
    SLKAlertViewTransitionStyleBounce,
    SLKAlertViewTransitionStyleDropDown
};

@class SLKAlertView;

typedef void(^SLKAlertViewHandler)(SLKAlertView *alertView);

@interface SLKAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is #FFFFFF
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is #3C4B5B
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is #8A8B8B
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is Lato-Bold 20pts.
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is Lato 14pts.
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is Lato 18pts.
@property (nonatomic, strong) UIColor *buttonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is #3EBA92
@property (nonatomic, strong) UIColor *cancelButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is #878787
@property (nonatomic, strong) UIColor *destructiveButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is #EB4D5B
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 10.0

@property (nonatomic, assign) SLKAlertViewTransitionStyle transitionStyle; // default is SLKAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) SLKAlertViewBackgroundStyle backgroundStyle; // default is SLKAlertViewBackgroundStyleSolid

@property (nonatomic, copy) SLKAlertViewHandler willShowHandler;
@property (nonatomic, copy) SLKAlertViewHandler didShowHandler;
@property (nonatomic, copy) SLKAlertViewHandler willDismissHandler;
@property (nonatomic, copy) SLKAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, getter = isParallaxEffectEnabled) BOOL enableParallaxEffect; // default is YES

- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle cancelHandler:(SLKAlertViewHandler)cancelHandler;

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle cancelHandler:(SLKAlertViewHandler)cancelHandler acceptButtonTitle:(NSString *)acceptTitle acceptHandler:(SLKAlertViewHandler)acceptHandler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end
