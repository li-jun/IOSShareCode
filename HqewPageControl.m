//
//  HqewPageControl.m
//  HqewWorldShop
//
//  Created by Jun Li on 12-5-30.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "HqewPageControl.h"

@implementation HqewPageControl

@synthesize imageNormal;
@synthesize imageHighlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setImageNormal:(UIImage *)image
{
    imageNormal = image;
    [self updateDots];
}

- (void) setImageHighlighted:(UIImage *)image
{
    imageHighlighted = image;
    [self updateDots];
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void) updateDots
{
    if (imageHighlighted || imageNormal) {
        NSArray *subView = self.subviews;
        for (NSInteger i = 0; i < subView.count; i++) {
            UIImageView *dot = [subView objectAtIndex:i];
            dot.image = self.currentPage == i ? imageHighlighted : imageNormal;
        }
    }
}

- (void) setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end
