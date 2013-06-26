//
//  GuideLineView.m
//  HqewESearch
//
//  Created by RUI CHEN on 13-4-18.
//  Copyright (c) 2013年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//
//

#import "GuideLineView.h"
#import "Common.h"

@implementation GuideLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.imgViewGuide = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.imgViewGuide setUserInteractionEnabled:YES];
        [self addSubview:self.imgViewGuide];
        
        UITapGestureRecognizer *viewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImgTap:)];
        [self.imgViewGuide addGestureRecognizer:viewGestureRecognizer];
        [self addGestureRecognizer:viewGestureRecognizer];
    }
    return self;
}

- (BOOL)showGuideImgView:(NSString *)viewControllernName {
    NSString *guideImgPath = [[NSBundle mainBundle] pathForResource:@"GuideLineInfo" ofType:@"plist"];
    NSDictionary *dcty = [[NSDictionary alloc] initWithContentsOfFile:guideImgPath];
    
    if (![viewControllernName isEqualToString:@""]) {
        NSInteger readMark = [[Common loadKeyValue:viewControllernName] integerValue];
        if (readMark != 1) {
            NSString *imgGuideName;
            
            imgGuideName = [dcty objectForKey:viewControllernName];
            
            if (imgGuideName != nil)
            {
                [self saveKeyAndValue:viewControllernName Value:@"1"];
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)handleImgTap:(UIGestureRecognizer *)sender {
    [self fadeScreen];
}

- (void) fadeScreen {
    /*[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishdFading)];
    self.alpha = 0.0;
    [UIView commitAnimations];*/
    self.alpha = 0.0;
}

- (void) setGuideLineImgView:(NSString *)controllerName Rect:(CGRect)rect {
    self.imgViewGuide.frame = rect;
    NSString *guideImgPath = [[NSBundle mainBundle] pathForResource:@"GuideLineInfo" ofType:@"plist"];
    NSDictionary *dcty = [[NSDictionary alloc] initWithContentsOfFile:guideImgPath];
    controllerName = [dcty objectForKey:controllerName];
    self.imgViewGuide.image = [UIImage imageNamed:controllerName];
}

- (void) showGuideLineView:(NSString *)controllerName ParentViewController:(UIViewController *)parentViewController Rect:(CGRect)rect {
    BOOL flag = [self showGuideImgView:controllerName];
    if (!flag) {
        [self setGuideLineImgView:controllerName Rect:rect];
        [parentViewController.view addSubview:self];
    }
}

- (void) saveKeyAndValue:(NSString *)aKey Value:(NSString *)aValue
{
    NSUserDefaults *userStore = [NSUserDefaults standardUserDefaults];
    [userStore setObject:aValue forKey:aKey];
}

/*- (void)finalize {
    self.imgViewGuide = nil;
}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
