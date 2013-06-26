//
//  SplashViewController.m
//  EShopkeeper
//
//  Created by lijun on 13-4-25.
//  Copyright (c) 2013年 Shenzhen Huaqiang electronic trading network Co., Ltd. All rights reserved.
//
//

#import "SplashViewController.h"
#import "Common.h"

@interface SplashViewController ()

@property (nonatomic, retain) UIImageView *splashImageView;

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.fadeTime = 2.0f;
    [self initLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    self.splashImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void) initLayout {
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    self.splashImageView = [[UIImageView alloc] init];
    self.splashImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.splashImageView];
    
    UIInterfaceOrientation orientation = [Common statusBarOrientation];
    NSString *splashImageName = @"";
    CGRect splashImageRect = CGRectZero;
    if ([Common isPad]) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                splashImageName = @"Default-Portrait~ipad.png";
                splashImageRect = CGRectMake(0, -1 * [Common getStatusBarHeight], screenFrame.size.width, screenFrame.size.height);
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                splashImageName = @"Default-Landscape~ipad.png";
                splashImageRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
                break;
            default:
                break;
        }
        
    } else {
        if (IS_IPHONE_5) {
            splashImageName = @"Default-568h@2x.png";
        } else {
            splashImageName = @"Default.png";
        }
        splashImageRect = CGRectMake(0, -1 * [Common getStatusBarHeight], screenFrame.size.width, screenFrame.size.height);
    }
    self.splashImageView.frame = splashImageRect;
    self.splashImageView.image = [UIImage imageNamed:splashImageName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeScreen) name:FADE_SPLASH_SCREEN_NOTIFICATION object:nil];
}

- (void) fadeScreen {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.fadeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishdFading)];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
}

- (void) finishdFading {
    [[NSNotificationCenter defaultCenter] postNotificationName:SPLASH_SCREEN_DID_DISAPPEAR_NOTIFICATION object:nil];
}

@end
