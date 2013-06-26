//
//  MultipleImageScrollView.m
//  HqewXianbey
//
//  Created by lijun on 2012-11-21.
//
//

#import "MultipleImageScrollView.h"
#import <QuartzCore/CALayer.h>
#import "UIImageView+WebCache.h"
#import "Common.h"


@interface MultipleImageScrollView ()
{
    NSMutableArray *subViews;
    NSMutableArray *aryimages;
    NSInteger showImageIndex;
}
@end

@implementation MultipleImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.hasFrame = NO;
        self.frameWidth = 0;
        self.frameColor = [UIColor clearColor];
        self.margin = 5;
        self.orientation = UIMultipleImageOrientationLandscape;
        self.isFillPage = YES;
        self.imageSize = CGSizeZero;
        self.isAutoRepeatScroll = NO;
        self.autoScrollTime = 0.0f;
        subViews = [[NSMutableArray alloc] init];
        aryimages = [[NSMutableArray alloc] init];
        
        self.pageControl = [[HqewPageControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.pageControl.autoresizesSubviews = YES;
        self.pageControl.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.center = CGPointMake(self.center.x, self.bounds.size.height - 10);
        self.pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg.png"]];
    }
    return self;
}

- (void) dealloc {
    [subViews removeAllObjects];
    subViews = nil;
    [aryimages removeAllObjects];
    aryimages = nil;
    
    [self removeTimer];
}

- (void) removeTimer {
    if (self.timerAutoScroll) {
        [self.timerAutoScroll invalidate];
        self.timerAutoScroll = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) loadScrollViewWithPage:(UIView *)page
{
    int pageCount = subViews.count;
    
    CGRect bounds = page.bounds;
    if (self.orientation == UIMultipleImageOrientationLandscape) {
        if (pageCount > 0) {
            bounds.origin.x = bounds.size.width * pageCount + self.margin * pageCount;
        } else {
            bounds.origin.x = bounds.size.width * pageCount;
        }
        
        bounds.origin.y = 0;
    }
    else {
        bounds.origin.x = 0;
        if (pageCount > 0) {
            bounds.origin.y = bounds.size.height * pageCount + self.margin * pageCount;
        } else {
            bounds.origin.y = bounds.size.height * pageCount;
        }
    }
    //bounds.size = self.frame.size;
    page.frame = bounds;
    [self addSubview:page];
}

- (void) removeAllViews {
    for (UIImageView *viewImage in subViews) {
        [viewImage removeFromSuperview];
    }
    [subViews removeAllObjects];
}

- (void) loadImageWithArray:(NSArray *)images {
    CGRect pageRect = self.frame;
    if (!self.isFillPage) {
        pageRect.size = self.imageSize;
    }
    [self removeAllViews];
    [aryimages removeAllObjects];
    [aryimages addObjectsFromArray:images];
    
    for (int i = 0; i < images.count; i++) {
        /*UIView *subView = [[UIView alloc] initWithFrame:pageRect];
        if ([self.viewBkgImage isEqualToString:@""]) {
            subView.backgroundColor = [UIColor clearColor];
        }
        else {
            subView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:self.viewBkgImage]];
        }
        //边框
        if (self.hasFrame) {
            [[subView layer] setMasksToBounds:YES];
            [[subView layer] setBorderWidth:self.frameWidth];
            [[subView layer] setBorderColor:[self.frameColor CGColor]];
        }*/
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pageRect.size.width, pageRect.size.height)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        NSURL *imageURL = [NSURL URLWithString:[images objectAtIndex:i]];
        [imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"jyhplaceholder.png"]];
        //[subView addSubview:imageView];
        
        if (self.hasFrame) {
            [[imageView layer] setMasksToBounds:YES];
            [[imageView layer] setBorderWidth:self.frameWidth];
            [[imageView layer] setBorderColor:[self.frameColor CGColor]];
        }
        
        imageView.tag = i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
        [imageView addGestureRecognizer:singleTap];
        
        [self loadScrollViewWithPage:imageView];
        [subViews addObject:imageView];
    }
    
    if (self.isFillPage && aryimages.count > 1) {
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = aryimages.count;
        self.pageControl.currentPage = 0;
        [self.pageControl setImageHighlighted:[UIImage imageNamed:@"PointSel.png"]];
        [self.pageControl setImageNormal:[UIImage imageNamed:@"Point.png"]];
    }
    else {
        self.pageControl.hidden = YES;
        self.pageControl.currentPage = 0;
    }
    
    if (self.orientation == UIMultipleImageOrientationLandscape) {
        self.contentSize = CGSizeMake(pageRect.size.width * aryimages.count + self.margin * (aryimages.count - 1), pageRect.size.height);
    } else {
        self.contentSize = CGSizeMake(pageRect.size.width, pageRect.size.height * aryimages.count + self.margin * (aryimages.count - 1));
    }
    
}

- (void) openURL: (UITapGestureRecognizer*)sender
{
    if ([Common isPad]) {
        for (UIImageView *iview in subViews ) {
            [[iview layer] setMasksToBounds:YES];
            [[iview layer] setBorderWidth:self.frameWidth];
            [[iview layer] setBorderColor:[self.frameColor CGColor]];
        }
        UIImageView *imageView = (UIImageView *)sender.view;
        [[imageView layer] setMasksToBounds:YES];
        [[imageView layer] setBorderWidth:2];
        [[imageView layer] setBorderColor:[UIColor redColor].CGColor];
    }
    if (self.delegateImageView) {
        [self.delegateImageView imageTouchUpInsideAtIndex:sender.view.tag];
        showImageIndex = sender.view.tag;
        if (self.isAutoRepeatScroll) {
            [self removeTimer];
            self.timerAutoScroll = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTime target:self selector:@selector(scrollImage) userInfo:nil repeats:self.isAutoRepeatScroll];
        }
    }
}

- (void) setSelectedIndex:(NSInteger)index {
    if (index < 0 || index >= subViews.count) {
        return ;
    }
    
    for (UIImageView *iview in subViews ) {
        [[iview layer] setMasksToBounds:YES];
        [[iview layer] setBorderWidth:self.frameWidth];
        [[iview layer] setBorderColor:[self.frameColor CGColor]];
    }
    
    UIImageView *imageView = [subViews objectAtIndex:index];
    [[imageView layer] setMasksToBounds:YES];
    [[imageView layer] setBorderWidth:2];
    [[imageView layer] setBorderColor:[UIColor redColor].CGColor];
    showImageIndex = index;
}

- (void) scrollImage {
    if (showImageIndex >= [subViews count] - 1) {
        showImageIndex = 0;
    }
    else {
        showImageIndex = showImageIndex + 1;
    }
    [self setSelectedIndex:showImageIndex];
    if (self.delegateImageView) {
        [self.delegateImageView imageTouchUpInsideAtIndex:showImageIndex];
    }
}

- (void) autoScrollImageView {
    if ([aryimages count] > 1) {
        [self removeTimer];
        self.timerAutoScroll = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTime target:self selector:@selector(scrollImage) userInfo:nil repeats:self.isAutoRepeatScroll];
    }
}

#pragma HqewImageViewDelegate
- (void) imageViewTouchUpInside:(NSInteger)tag {
    
}

@end
