//
//  GuideLineView.h
//  HqewESearch
//
//  Created by RUI CHEN on 13-4-18.
//  Copyright (c) 2013年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//
//  系统名称：HqewESearch
//  功能描述：引导界面
//

#import <UIKit/UIKit.h>

@interface GuideLineView : UIView

@property (nonatomic, retain) UIImageView *imgViewGuide;

- (void) showGuideLineView:(NSString *)controllerName ParentViewController:(UIViewController *)parentViewController Rect:(CGRect)rect;
@end
