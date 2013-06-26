//
//  HqewIO.h
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-26.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqewIO : NSObject
//获取Document的路径
+ (NSString *)getDocPath;

//保存NData到Document里
//toFile为文件名，不能带目录
+ (BOOL)saveDataToFile:(NSData *)fileData toFile:(NSString *)fileName;

//保存NData到Document里
//toDir目录目录，如：@"adir/bdir"
//toFile为文件名，不能带目录
+ (BOOL)saveDataToFile:(NSData *)fileData toDir:(NSString *)destDir toFile:(NSString *)fileName;

//保存NSString到Document里
//toFile为文件名，不能带目录
+ (BOOL)saveStringToFile:(NSString *)fileData toFile:(NSString *)fileName;

//保存NSString到Document里
//toDir目录目录，如：@"adir/bdir"
//toFile为文件名，不能带目录
+ (BOOL)saveStringToFile:(NSString *)fileData toDir:(NSString *)destDir toFile:(NSString *)fileName;

+ (NSString *)readStringFromFile:(NSString *)fileName;

+ (NSData *)readDataFromFile:(NSString *)fileName;

//filename完整的文件路径
//文件存在返回yes 否则返回no
+ (BOOL)fileExists:(NSString *)fileName;
@end
