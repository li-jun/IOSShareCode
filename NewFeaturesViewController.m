//
//  NewFeaturesViewController.m
//  HqewSoso
//
//  Created by Jun Li on 12-8-3.
//  Copyright (c) 2012Âπ?Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "NewFeaturesViewController.h"
#import "Common.h"

@interface NewFeaturesViewController ()
{
    NSMutableArray *subViews;
    UIButton *btnStart;
}
@end

@implementation NewFeaturesViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize dataSource;
@synthesize direction;
@synthesize contentView;
@synthesize imgArray;
@synthesize delegate;
@synthesize imageScaledBySameRadio;
@synthesize isNeedPageControl;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([Common isPad]) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate {
    
    return YES;
}

- (void) loadView
{
    direction = YES;
    imgArray = [[NSMutableArray alloc] init];
    subViews = [[NSMutableArray alloc] init];
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appRect.size.width, appRect.size.height)];
    contentView.autoresizesSubviews = YES;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    contentView.backgroundColor = [UIColor clearColor];
    [self setView:contentView];
    
    UIImageView *imgBkg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appRect.size.width, appRect.size.height)];
    imgBkg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imgBkg];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, appRect.size.width, appRect.size.height)];
    scrollView.autoresizesSubviews = YES;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame = CGRectMake(10, appRect.size.height - 10 - 40, appRect.size.width - 20, 40);
    [btnStart setTitle:@"开始体验" forState:UIControlStateNormal];
    btnStart.titleLabel.textColor = [UIColor whiteColor];
    btnStart.titleLabel.font = [UIFont systemFontOfSize:17.0];
    btnStart.hidden = YES;
    UIImage *redImage = [[UIImage imageNamed:@"redbtnbkg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [btnStart setBackgroundImage:redImage forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(btnStartTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    pageControl = [[HqewPageControl alloc] initWithFrame:CGRectMake(0, 0, appRect.size.width, appRect.size.height)];
    pageControl.autoresizesSubviews = YES;
    pageControl.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.center = CGPointMake(self.view.center.x, appRect.size.height - 10);
    pageControl.userInteractionEnabled = NO;    
    [self.view addSubview:pageControl];
    
    [self initAdvertImageFile];
    [self createPages];
}


- (void) btnStartTouchUpInside {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) loadScrollViewWithPage:(UIImageView *)page
{
    int pageCount = [scrollView subviews].count;
    
    CGRect bounds = scrollView.bounds;
    bounds.origin.x = bounds.size.width * pageCount;
    bounds.origin.y = 0;
    bounds.size = scrollView.frame.size;
    page.frame = bounds;
    [scrollView addSubview:page];
}

- (void) createPages
{       
    CGRect pageRect = scrollView.frame;
    
    for (int i = 0; i < imgArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:pageRect];
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [imgArray objectAtIndex:i];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouchUpInside:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        [self loadScrollViewWithPage:imageView];
        [subViews addObject:imageView];
    }
    if (imgArray.count > 1) {
        pageControl.hidden = !isNeedPageControl;
        pageControl.numberOfPages = imgArray.count;
        pageControl.currentPage = 0;
    }
    else {
        pageControl.hidden = YES;
        pageControl.currentPage = 0;
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * imgArray.count, self.scrollView.frame.size.height);
    CGRect btnRect = btnStart.frame;
    btnRect.origin.x = scrollView.frame.size.width * (imgArray.count - 1) + 10;
    btnStart.frame = btnRect;
    [scrollView addSubview:btnStart];
}

- (void) imageViewTouchUpInside:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == imgArray.count - 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma scrollView Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    int page = floor((scrollView.contentOffset.x - rect.size.width / 3) / rect.size.width) + 1;
    
    if (page == imgArray.count) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewfeaturesWillDisappearNotification object:nil];
    }
    else {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
        if (page >= imgArray.count - 1) {
            btnStart.hidden = YES;
        }
        else {
            btnStart.hidden = YES;
        }
    }
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /**/
}

- (void) initAdvertImageFile
{
    for (NSInteger i = 0; i < dataSource.count; i++) 
    {
        UIImage *img = [UIImage imageNamed:[dataSource objectAtIndex:i]];
        [imgArray addObject:img];
    }
}

@end
