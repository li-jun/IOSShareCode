//
//  HqewUtil.m
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-29.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "HqewUtil.h"

@implementation HqewUtil

+(NSString *)MD5Encode:(NSString *)value{
    if (value == nil) {
        return @"";
    }
	//[value retain];
	const char *cStr = [value UTF8String];
	//[value release];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];  
}

+(int)GetUnixTime
{
    NSDate *now = [[NSDate alloc] init];
    int tmpTime = [now timeIntervalSince1970];
    return tmpTime;
}

+(NSString *)getFileNameFromUrl:(NSString *)fileUrl
{
    NSArray *tmpArray = [fileUrl componentsSeparatedByString:@"/"];
    return [tmpArray lastObject];
}

+(NSString *)ObjToStr:(NSObject *)obj
{
    if (obj == nil)
        return nil;
    
    NSError *error = nil;
    
    NSData *tmpData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error != nil)
        return nil;
    else {
        return [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
    }
    
    //SBJsonWriter *jw = [SBJsonWriter alloc];
    //return [jw stringWithObject:obj];
}

+(NSMutableDictionary *)StrToObj:(NSString *)str
{
    if (str == nil)
        return nil;
    NSData *tmpData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:tmpData options:kNilOptions error:&error];
    
    if (error != nil)
        return nil;
    else {
        return (NSMutableDictionary *)result;
    }
    //BOOL isJson = [NSJSONSerialization isv
    
    
    
    //SBJsonParser *json = [[SBJsonParser alloc] init];
    //NSMutableDictionary *jsonDict = [json objectWithString:str error:nil]; 
    //return jsonDict;
    
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;    
}



+ (UIColor *) colorWithHexString: (NSString *) hexString 
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];          
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];                      
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];                      
            break;
        default:
            return [UIColor blackColor];
            //[NSException:@"Invalid color value"format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+(NSDate *)StrToDate:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

+(NSString *)DateToStr:(NSDate *)date Format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    if (format == nil)
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+(CGSize)getTextSize:(NSString *)str Font:(UIFont *)font Width:(CGFloat)width;
{
    CGSize size = CGSizeMake(width, FLT_MAX);
    CGSize labelSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap]; 
    return labelSize;
}

+(CGFloat)getTextWidth:(NSString *)str Font:(UIFont *)font
{
    CGSize size = CGSizeMake(FLT_MAX, FLT_MAX);
    CGSize labelSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap]; 
    return labelSize.width;
}

+(BOOL)checkInteger:(NSString *)input
{
    NSString *rega = @"^[0-9]*$";
    
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:rega options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *aa = [reg matchesInString:input options:0 range:NSMakeRange(0,[input length])];
    NSLog(@"%d",[aa count]);
    if ([aa count] > 0)
    {
        return YES;
    }
    else
        return NO;
}

+(BOOL)checkFloat:(NSString *)input
{
    NSString *rega = @"^[\\d*\\.\\d*]+$";
    
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:rega options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *aa = [reg matchesInString:input options:0 range:NSMakeRange(0,[input length])];
    NSLog(@"%d",[aa count]);
    if ([aa count] > 0)
    {
        return YES;
    }
    else
        return NO;
}

@end
