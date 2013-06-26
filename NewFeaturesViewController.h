//
//  NewFeaturesViewController.h
//  HqewSoso
//
//  Created by Jun Li on 12-8-3.
//  Copyright (c) 2012å¹?Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HqewPageControl.h"

#define kNewfeaturesWillDisappearNotification @"NewfeaturesWillDisappearNotification"

@protocol NewFeaturesDelegate <NSObject>

@optional
- (void) scrollToLastFeature;

@end

@interface NewFeaturesViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, weak) id<NewFeaturesDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSMutableArray *imgArray;
@property BOOL direction;
@property BOOL imageScaledBySameRadio;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet HqewPageControl *pageControl;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) BOOL isNeedPageControl;

@end
