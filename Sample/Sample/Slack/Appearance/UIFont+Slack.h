//
//  UIFont+Slack.h
//  slack
//
//  Created by Ignacio on 5/21/14.
//  Copyright (c) 2014 Tiny Speck, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A convinience set of font initializers for Slack's app custom font.
 The main typeface used are currently the Lato family.
 */
@interface UIFont (Slack)

/** Light Font */
+ (UIFont *)slackLightFontOfSize:(CGFloat)size;
+ (UIFont *)slackLightItalicFontOfSize:(CGFloat)size;

/** Regular Font */
+ (UIFont *)slackFontOfSize:(CGFloat)size;
+ (UIFont *)slackItalicFontOfSize:(CGFloat)size;

/** Bold Font */
+ (UIFont *)slackBoldFontOfSize:(CGFloat)size;
+ (UIFont *)slackBoldItalicFontOfSize:(CGFloat)size;

/** Black Font */
+ (UIFont *)slackBlackFontOfSize:(CGFloat)size;

/** Symbol (Awesome) Font */
+ (UIFont *)slackSymbolFontOfSize:(CGFloat)size;
+ (UIFont *)slackSymboliconsBlockFontOfSize:(CGFloat)size;

@end