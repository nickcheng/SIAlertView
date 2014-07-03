//
//  UIColor+Slack.h
//  slack
//
//  Created by Brady Archambo on 5/8/14.
//  Copyright (c) 2014 Tiny Speck, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Slack)

/** Navigation Bar Colors */
+ (UIColor *)navBarBackgroundColor;
+ (UIColor *)navBarButtonColor;
+ (UIColor *)navBarButtonDisabledColor;

/** Blue Button Colors */
+ (UIColor *)blueButtonColor;
+ (UIColor *)blueButtonDisabledColor;
+ (UIColor *)blueButtonPressedColor;

/** Green Button Colors */
+ (UIColor *)greenButtonColor;
+ (UIColor *)greenButtonDisabledColor;
+ (UIColor *)greenButtonPressedColor;

/** White Button Colors */
+ (UIColor *)whiteButtonColor;
+ (UIColor *)whiteButtonDisabledColor;
+ (UIColor *)whiteButtonPressedColor;

/** UITableView Colors */
+ (UIColor *)tableBackgroundColor;
+ (UIColor *)tableCellTextColor;
+ (UIColor *)tableSeparatorColor;
+ (UIColor *)tableCellHighlightColor;
+ (UIColor *)tablePlaceholderColor;

/** Presence Colors */
+ (UIColor *)onlineBrightColor;
+ (UIColor *)offlineBrightColor;
+ (UIColor *)onlineDullColor;
+ (UIColor *)offlineDullColor;

/** Icon Colors */
+ (UIColor *)greenIconColor;
+ (UIColor *)redIconColor;
+ (UIColor *)yellowIconColor;
+ (UIColor *)blueIconColor;

/** General Colors */
+ (UIColor *)keyColor;
+ (UIColor *)externalTextLinkColor;
+ (UIColor *)internalTextLinkColor;
+ (UIColor *)destructiveColor;
+ (UIColor *)warningColor;

/** Text Colors */
+ (UIColor *)textColor;
+ (UIColor *)textLightColor;

@end
