//
//  HqewUtil.h
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-29.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqewUtil : NSObject

//md5字符串加密
+(NSString *)MD5Encode:(NSString *)value;

//取从1970年1月1日起的时间截
+(int)GetUnixTime;

//从地址里取出文件名
//如  /file/abcd/images/img.jpg 返回img.jpg
+(NSString *)getFileNameFromUrl:(NSString *)fileUrl;

//对象转换为json的字符串
+(NSString *)ObjToStr:(NSObject *)obj;

//json的字符串转换为json对象
+(NSMutableDictionary *)StrToObj:(NSString *)str;

//十六进制颜色字符串转uicolor
+ (UIColor *) colorWithHexString: (NSString *) hexString;

//标准日期时间字符串转date类型
+(NSDate *)StrToDate:(NSString *)str;

//date按格式输入出
+(NSString *)DateToStr:(NSDate *)date Format:(NSString *)format;

//取得多行文字实际高度 
+(CGSize)getTextSize:(NSString *)str Font:(UIFont *)font Width:(CGFloat)width;

//取得单行文字的宽度
+(CGFloat)getTextWidth:(NSString *)str Font:(UIFont *)font;

//检测input是否整型
+(BOOL)checkInteger:(NSString *)input;
//检测input是否浮点型
+(BOOL)checkFloat:(NSString *)input;
@end
