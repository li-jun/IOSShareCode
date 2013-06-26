//
//  SplashViewController.h
//  EShopkeeper
//
//  Created by lijun on 13-4-25.
//  Copyright (c) 2013年 Shenzhen Huaqiang electronic trading network Co., Ltd. All rights reserved.
//
//  系统名称：EShopkeeper
//  功能描述：
//

#import <UIKit/UIKit.h>

#define FADE_SPLASH_SCREEN_NOTIFICATION @"FadeSplashScreenNotification"
#define SPLASH_SCREEN_DID_DISAPPEAR_NOTIFICATION @"SplashScreenDidDisappearNotification"

@interface SplashViewController : UIViewController

@property (nonatomic, assign) CGFloat fadeTime;

@end
