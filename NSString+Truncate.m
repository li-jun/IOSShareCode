//
//  NSString+Truncate.m
//  EShopkeeper
//
//  Created by lijun on 13-5-8.
//  Copyright (c) 2013年 Shenzhen Huaqiang electronic trading network Co., Ltd. All rights reserved.
//

#import "NSString+Truncate.h"

@implementation NSString (Truncate)

- (NSArray *) truncateWithFixedSize:(CGSize)size WithFont:(UIFont *)font LineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableArray *aryResult = [[NSMutableArray alloc] init];
    
    CGSize maxSize = CGSizeMake(size.width, 1000);
    CGSize textSize = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    if (textSize.width <= size.width && textSize.height <= size.height) {
        [aryResult addObject:self];
        return aryResult;
    }
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSInteger i = 0; i < [self length]; i++) {
        [string appendString:[self substringWithRange:NSMakeRange(i, 1)]];
        
        CGSize rSize = [string sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode];
        if (rSize.width > size.width || rSize.height > size.height) {
            [string deleteCharactersInRange:NSMakeRange(i, 1)];
            [aryResult addObject:string];
            NSString *remainString = [self substringFromIndex:i];
            [aryResult addObject:remainString];
            
            break;
        }
    }
    
    return aryResult;
}

@end
