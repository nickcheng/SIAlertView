//
//  UIColor+Slack.m
//  slack
//
//  Created by Brady Archambo on 5/8/14.
//  Copyright (c) 2014 Tiny Speck, Inc. All rights reserved.
//

#import "UIColor+Slack.h"
#import "UIColor+Hex.h"

@implementation UIColor (Slack)

#pragma mark - Navigation Bar Colors

+ (UIColor *)navBarBackgroundColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"f4f5f6"];
    });
    return color;
}

+ (UIColor *)navBarButtonColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"3EBA92"];
    });
    return color;
}

+ (UIColor *)navBarButtonDisabledColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"D0D0D0"];
    });
    return color;
}


#pragma mark - Blue Button Colors

+ (UIColor *)blueButtonColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"2A80B9"];
    });
    return color;
}

+ (UIColor *)blueButtonDisabledColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"DDDDE0"];
    });
    return color;
}

+ (UIColor *)blueButtonPressedColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"3A75A1"];
    });
    return color;
}


#pragma mark - Green Button Colors

+ (UIColor *)greenButtonColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"02B046"];
    });
    return color;
}

+ (UIColor *)greenButtonDisabledColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"DDDDE0"];
    });
    return color;
}

+ (UIColor *)greenButtonPressedColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"488F3A"];
    });
    return color;
}


#pragma mark - White Button Colors

+ (UIColor *)whiteButtonColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"02B046"];
    });
    return color;
}

+ (UIColor *)whiteButtonDisabledColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"DDDDE0"];
    });
    return color;
}

+ (UIColor *)whiteButtonPressedColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"488F3A"];
    });
    return color;
}


#pragma mark - UITableView Colors

+ (UIColor *)tableBackgroundColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"ebecf0"];
    });
    return color;
}

+ (UIColor *)tableCellTextColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"424242"];
    });
    return color;
}

+ (UIColor *)tableSeparatorColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"d3d3d7"];
    });
    return color;
}

+ (UIColor *)tableCellHighlightColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"f5f6f7"];
    });
    return color;
}

+ (UIColor *)tablePlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"d7d7d7"];
    });
    return color;
}

#pragma mark - Presence Colors

+ (UIColor *)onlineBrightColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"93cc93"];
    });
    return color;
}

+ (UIColor *)offlineBrightColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"dbdbde"];
    });
    return color;
}

+ (UIColor *)onlineDullColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"4c837d"];
    });
    return color;
}

+ (UIColor *)offlineDullColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"625361"];
    });
    return color;
}

#pragma mark - Icon Colors

+ (UIColor *)greenIconColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"3EBA92"];
    });
    return color;
}

+ (UIColor *)redIconColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"E9293D"];
    });
    return color;
}

+ (UIColor *)yellowIconColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"EAA821"];
    });
    return color;
}

+ (UIColor *)blueIconColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"2780F8"];
    });
    return color;
}


#pragma mark - General Colors

+ (UIColor *)keyColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"3EBA92"];
    });
    return color;
}

+ (UIColor *)externalTextLinkColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"0088CC"];
    });
    return color;
}

+ (UIColor *)internalTextLinkColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"6ABBE3"];
    });
    return color;
}

+ (UIColor *)destructiveColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"EB4D5B"];
    });
    return color;
}

+ (UIColor *)warningColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"DAA038"];
    });
    return color;
}


#pragma mark - Text Colors

+ (UIColor *)textColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"3D3C40"];
    });
    return color;
}

+ (UIColor *)textLightColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorFromHex:@"A7A8AC"];
    });
    return color;
}

@end
