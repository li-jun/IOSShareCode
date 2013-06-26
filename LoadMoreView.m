//
//  LoadMoreView.m
//  HqewXianbey
//
//  Created by YeGanLin on 12-12-11.
//
//

#import "LoadMoreView.h"

@implementation LoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lblText = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 14) / 2, self.frame.size.width, 14)];
        [lblText setTextColor:[UIColor grayColor]];
        [lblText setBackgroundColor:[UIColor clearColor]];
        [lblText setTextAlignment:NSTextAlignmentCenter];
        [lblText setFont:[UIFont systemFontOfSize:14.0]];
        [lblText setText:@"正在加载更多..."];
        [self addSubview:lblText];
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

-(void)resizeFrame:(UIScrollView *)scrollView
{
    if (!scrollView)
    {
        [self setHidden:YES];
        return;
    }
    CGSize frameSize = scrollView.contentSize;
    CGRect rect = self.frame;
    rect.origin.y = frameSize.height;
    [self setFrame:rect];
    frameSize.height = frameSize.height + self.frame.size.height;
    [scrollView setContentSize:frameSize];
}

@end
