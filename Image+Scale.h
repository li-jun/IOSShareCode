//
//  Image+Scale.h
//  ecircle
//
//  Created by 李军 on 13-3-27.
//  Copyright (c) 2013年 Shenzhen Huaqiang electronic trading network Co., Ltd. All rights reserved.
//
//  系统名称：ecircle
//  功能描述：
//

#import <Foundation/Foundation.h>

@interface UIImage (Scale)

- (UIImage *) scaleToSize:(CGSize)size;
- (UIImage *) scaleToSizeWithSameRadio:(CGSize)size;
- (UIImage *) getRectImage:(CGRect)rect;

@end
