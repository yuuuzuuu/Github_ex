//
//  WebViewController.h
//  The Dog
//
//  Created by 木村 友真 on 2014/06/21.
//  Copyright (c) 2014年 yuma kimura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *openURL;

@end
