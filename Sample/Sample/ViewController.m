//
//  ViewController.m
//  Sample
//
//  Created by Ignacio Romero Z. on 7/2/14.
//  Copyright (c) 2014 Tiny Speck, Inc. All rights reserved.
//

#import "ViewController.h"
#import "SLKAlertView.h"

@interface ViewController ()
@end


@implementation ViewController

+ (void)initialize {
  [super initialize];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
    [self showAnotherAlert];
  });
}

- (IBAction)showAlert:(id)sender {
  NSString *title   = @"Allow new members to see the group’s history?";
  NSString *message = @"We can archive all current messages in the group to hide it from the new members you invite here. Current team members will still be able to access the history from a link to the archives.";

//  [SLKAlertView showWithTitle:title message:message acceptButtonTitle:@"YES" cancelButtonTitle:@"NO"
//                    didAccept:^ (SLKAlertView *alertView) {
//    NSLog(@"%s", __FUNCTION__);
//  } didCancel:^ (SLKAlertView *alertView) {
//    NSLog(@"%s", __FUNCTION__);
//  }];

  [SLKAlertView showWithTitle:title message:message buttonTitle1:@"Title1" buttonTitle2:@"Title2" buttonTitle3:@"Title3" buttonHandler1:^(SLKAlertView *alertView) {
    NSLog(@"Title 1");
  } buttonHandler2:^(SLKAlertView *alertView) {
    NSLog(@"Title 2");
  } buttonHandler3:^(SLKAlertView *alertView) {
    NSLog(@"Title 3");
  }];
  
//  [SLKAlertView showWithTitle:@"Haha" message:@"" cancelButtonTitle:@"OK" didCancel:^(SLKAlertView *alertView) {
//    NSLog(@"hahaha");
//  }];
}

- (void)showAnotherAlert {
  [SLKAlertView showWithTitle:@"WTF?" message:@"Yo niggah wtf is going on!?" acceptButtonTitle:@"IDK" cancelButtonTitle:@"STFU"
                    didAccept:^ (SLKAlertView *alertView) {
    NSLog(@"%s", __FUNCTION__);
  } didCancel:^ (SLKAlertView *alertView) {
    NSLog(@"%s", __FUNCTION__);
  }];
}

@end
