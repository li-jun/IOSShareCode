//
//  LoadMoreView.h
//  HqewXianbey
//
//  Created by YeGanLin on 12-12-11.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface LoadMoreView : UIView
{
    UILabel *lblText;
}

//@property(nonatomic, weak) UIScrollView *scrollView;

-(void)resizeFrame:(UIScrollView *)scrollView;
@end
