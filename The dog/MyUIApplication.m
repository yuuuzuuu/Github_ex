//
//  MyUIApplication.m
//  The Dog
//
//  Created by 木村 友真 on 2014/06/21.
//  Copyright (c) 2014年 yuma kimura. All rights reserved.
//

#import "MyUIApplication.h"

@implementation MyUIApplication

- (BOOL)openURL:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    self.myOpenURL = url;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WebViewController *webViewController =
    [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webViewController.openURL = self.myOpenURL;
    webViewController.title = @"Web View";
    [appDelegate.navigationController pushViewController:webViewController animated:YES];
    self.myOpenURL = nil;
    return YES;
}

@end
