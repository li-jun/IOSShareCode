//
//  UIUnderlineLabel.m
//  HqewXianbey
//
//  Created by lijun on 2012-11-28.
//
//

#import "UIUnderlineLabel.h"

@implementation UIUnderlineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    const CGFloat* colors = CGColorGetComponents(self.textColor.CGColor);
    
    CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0); // RGBA
    
    CGContextSetLineWidth(ctx, 1.0f);
    CGSize tmpSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 9999)];
    
    int height = tmpSize.height;
    
    CGSize tmpTextSize = [self.text sizeWithFont:self.font];
    int lineHeight = tmpTextSize.height + 5;
    
    int maxCount = height/lineHeight;
    
    if (maxCount == 0) {
        maxCount = 1;
    }
    
    float totalWidth = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(1000, 9999)].width;
    
    for(int i=1;i<=maxCount;i++)
        
    {
        
        float width=0.0;
        if((i*self.frame.size.width-totalWidth)<=0)
            width = self.frame.size.width;
        else
            width = self.frame.size.width - (i* self.frame.size.width - totalWidth);
        CGContextMoveToPoint(ctx, 0, lineHeight*i-1);
        CGContextAddLineToPoint(ctx, width, lineHeight*i-1);
    }
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
}


@end
