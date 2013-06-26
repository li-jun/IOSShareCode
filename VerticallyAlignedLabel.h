//
//  VerticallyAlignedLabel.h
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-6-19.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel 
{
@private
    VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@end 
