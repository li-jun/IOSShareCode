//
//  MultipleImageScrollView.h
//  HqewXianbey
//
//  Created by lijun on 2012-11-21.
//
//

#import <UIKit/UIKit.h>
#import "HqewPageControl.h"

@protocol MultipleImageScrollViewDelegate <NSObject>

- (void) imageTouchUpInsideAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, UIMultipleImageOrientation) {
    UIMultipleImageOrientationLandscape,
    UIMultipleImageOrientationPortrait
};

@interface MultipleImageScrollView : UIScrollView
@property (nonatomic, retain) HqewPageControl *pageControl;
@property (nonatomic) UIMultipleImageOrientation orientation;
@property (nonatomic) NSInteger margin;
@property (nonatomic, retain) UIColor *frameColor;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) BOOL hasFrame;
@property (nonatomic) BOOL isFillPage;
@property (nonatomic) CGSize imageSize;
@property (nonatomic, retain) NSString *viewBkgImage;
@property (nonatomic, assign) id<MultipleImageScrollViewDelegate> delegateImageView;
@property (nonatomic) BOOL isAutoRepeatScroll;
@property (nonatomic) float autoScrollTime;
@property (nonatomic, retain) NSTimer *timerAutoScroll;

- (void) loadImageWithArray:(NSArray *)images;
- (void) setSelectedIndex:(NSInteger)index;
//自动切换图片，需要在loadImageWithArray方法后设置isAutoRepeatScroll = YES;autoScrollTime（切换时间);然后在调用该方法
- (void) autoScrollImageView;
//在使用到自动切换的单元中，当要释放本试图的时候 如果开启了自动切换 需要在释放之前先调用removeTimer清空计时器，否则无法释放
- (void) removeTimer;

@end
