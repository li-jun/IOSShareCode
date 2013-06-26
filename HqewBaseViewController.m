//
//  HqewBaseViewController.m
//  HqewESearch
//
//  Created by lijun on 13-6-24.
//  Copyright (c) 2013年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "HqewBaseViewController.h"

@interface HqewBaseViewController ()

@end

@implementation HqewBaseViewController

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

- (void) viewDidUnload {
    [self releaseMemory];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window)
        {
            [self releaseMemory];
            self.view = nil;
        }
        
    }
}

- (void) releaseMemory {
    
}

@end
