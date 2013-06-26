//
//  NSString+Truncate.h
//  EShopkeeper
//
//  Created by lijun on 13-5-8.
//  Copyright (c) 2013年 Shenzhen Huaqiang electronic trading network Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Truncate)

- (NSArray *) truncateWithFixedSize:(CGSize)size WithFont:(UIFont *)font LineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
