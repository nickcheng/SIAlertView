//
//  SIAlertView.h
//  SIAlertView
//
//  Created by Kevin Cao on 13-4-29.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SIAlertViewWillShowNotification;
extern NSString *const SIAlertViewDidShowNotification;
extern NSString *const SIAlertViewWillDismissNotification;
extern NSString *const SIAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, SIAlertViewButtonType) {
    SIAlertViewButtonTypeDefault = 0,
    SIAlertViewButtonTypeDestructive,
    SIAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, SIAlertViewBackgroundStyle) {
    SIAlertViewBackgroundStyleSolid = 0,
    SIAlertViewBackgroundStyleGradient,
};

typedef NS_ENUM(NSInteger, SIAlertViewTransitionStyle) {
    SIAlertViewTransitionStyleSlideFromBottom = 0,
    SIAlertViewTransitionStyleSlideFromTop,
    SIAlertViewTransitionStyleFade,
    SIAlertViewTransitionStyleBounce,
    SIAlertViewTransitionStyleDropDown
};

@class SIAlertView;
typedef void(^SIAlertViewHandler)(SIAlertView *alertView);

@interface SIAlertView : UIView

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

@property (nonatomic, assign) SIAlertViewTransitionStyle transitionStyle; // default is SIAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) SIAlertViewBackgroundStyle backgroundStyle; // default is SIAlertViewBackgroundStyleSolid

@property (nonatomic, copy) SIAlertViewHandler willShowHandler;
@property (nonatomic, copy) SIAlertViewHandler didShowHandler;
@property (nonatomic, copy) SIAlertViewHandler willDismissHandler;
@property (nonatomic, copy) SIAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, getter = isParallaxEffectEnabled) BOOL enableParallaxEffect; // default is YES

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle cancelHandler:(SIAlertViewHandler)cancelHandler;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle cancelHandler:(SIAlertViewHandler)cancelHandler acceptButtonTitle:(NSString *)acceptTitle acceptHandler:(SIAlertViewHandler)acceptHandler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end
