//
//  HqewIO.m
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-26.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "HqewIO.h"

@implementation HqewIO
+ (NSString *)getDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (BOOL)saveDataToFile:(NSData *)fileData toFile:(NSString *)fileName
{
    NSString *path = [HqewIO getDocPath]; //stringByAppendingPathComponent:@"version"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
        {
            NSLog(@"create dir fail");
            return NO;
        }
    }
    return [fileManager createFileAtPath:[path stringByAppendingPathComponent:fileName] contents:fileData attributes:nil];
}

+ (BOOL)saveDataToFile:(NSData *)fileData toDir:(NSString *)destDir toFile:(NSString *)fileName
{
    NSString *path = [[HqewIO getDocPath] stringByAppendingPathComponent:destDir];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
        {
            NSLog(@"create dir fail");
            return NO;
        }
    }
    return [fileManager createFileAtPath:[path stringByAppendingPathComponent:fileName] contents:fileData attributes:nil];   
}

+ (BOOL)saveStringToFile:(NSString *)fileData toFile:(NSString *)fileName
{
    NSData *aData = [fileData dataUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [HqewIO getDocPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
        {
            NSLog(@"create dir fail");
            return NO;
        }
    }
    return [fileManager createFileAtPath:[path stringByAppendingPathComponent:fileName] contents:aData attributes:nil];
}

+ (BOOL)saveStringToFile:(NSString *)fileData toDir:(NSString *)destDir toFile:(NSString *)fileName
{
    NSData *aData = [fileData dataUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [[HqewIO getDocPath] stringByAppendingPathComponent:destDir];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
        {
            NSLog(@"create dir fail");
            return NO;
        }
    }
    return [fileManager createFileAtPath:[path stringByAppendingPathComponent:fileName] contents:aData attributes:nil];
}

+ (NSString *)readStringFromFile:(NSString *)fileName
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //[fileManager changeCurrentDirectoryPath:[
    if (![fileManager fileExistsAtPath:fileName])
    {
        return nil;
    }
    else
    {
        return [NSString stringWithContentsOfFile:fileName usedEncoding:nil error:nil];
    }
}

+ (NSData *)readDataFromFile:(NSString *)fileName
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileName])
    {
        return nil;
    }
    else
    {
        return [NSData dataWithContentsOfFile:fileName];
    } 
}

+ (BOOL)fileExists:(NSString *)fileName;
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

@end
