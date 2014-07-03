//
//  SLViewController.m
//  Sample
//
//  Created by Ignacio Romero Z. on 7/2/14.
//  Copyright (c) 2014 Tiny Speck, Inc. All rights reserved.
//

#import "SLViewController.h"
#import "SIAlertView.h"

@interface SLViewController ()
@end


@implementation SLViewController

+ (void)initialize
{
    [super initialize];
}

- (IBAction)showAlert:(id)sender
{
    NSString *title = @"Allow new members to see the group’s history?";
    NSString *message = @"We can archive all current messages in the group to hide it from the new members you invite here. Current team members will still be able to access the history from a link to the archives.";
    
    [SIAlertView showWithTitle:title message:message
             cancelButtonTitle:@"NO" cancelHandler:^(SIAlertView *alertView) {
                 NSLog(@"%s",__FUNCTION__);
             }
             acceptButtonTitle:@"YES" acceptHandler:^(SIAlertView *alertView) {
                 NSLog(@"%s",__FUNCTION__);
             }];
}

@end
