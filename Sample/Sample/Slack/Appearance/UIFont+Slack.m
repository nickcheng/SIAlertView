//
//  UIFont+Slack.m
//  slack
//
//  Created by Ignacio on 5/21/14.
//  Copyright (c) 2014 Tiny Speck, Inc. All rights reserved.
//

#import "UIFont+Slack.h"
#import <CoreText/CoreText.h>

static NSString * const kSLKLightFont = @"Lato-Light";
static NSString * const kSLKLightItalicFont = @"Lato-LightItalic";
static NSString * const kSLKRegularFont = @"Lato-Regular";
static NSString * const kSLKItalicFont = @"Lato-Italic";
static NSString * const kSLKBoldFont = @"Lato-Bold";
static NSString * const kSLKBoldItalicFont = @"Lato-BoldItalic";
static NSString * const kSLKBlackFont = @"Lato-Black";
static NSString * const kSLKSymbolFont = @"FontAwesome";
static NSString * const kSLKSymboliconsBlockFont = @"SSSymboliconsBlock";

@implementation UIFont (Slack)

+ (UIFont *)slackLightFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKLightFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKLightFont size:size];
}

+ (UIFont *)slackLightItalicFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKLightItalicFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKLightItalicFont size:size];
}

+ (UIFont *)slackFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKRegularFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKRegularFont size:size];
}

+ (UIFont *)slackItalicFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKItalicFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKItalicFont size:size];
}

+ (UIFont *)slackBoldFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKBoldFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKBoldFont size:size];
}

+ (UIFont *)slackBoldItalicFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKBoldItalicFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKBoldItalicFont size:size];
}

+ (UIFont *)slackBlackFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKBlackFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKBlackFont size:size];
}

+ (UIFont *)slackSymbolFontOfSize:(CGFloat)size {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKSymbolFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKSymbolFont size:size];
}

+ (UIFont *)slackSymboliconsBlockFontOfSize:(CGFloat)size
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:kSLKSymboliconsBlockFont withExtension:@"ttf"];
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeNone, nil);
    });
    return [UIFont fontWithName:kSLKSymboliconsBlockFont size:size];
}

@end
