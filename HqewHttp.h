//
//  HqewHttp.h
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-28.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#define _CacheFolder @"webdata"
#define _CacheImagesFolder @"images"
#define _CacheNameLabel @"code_%@_%@.dat"
#define _CacheTimeLabel @"%@.tme"


typedef enum {
    hdtJson,
    hdtString
} HttpDataType;

@protocol HqewHttpDelegate<NSObject>
@optional
//error 0没有错误
//code 协议代码
//data 返回的json数据
- (void) httpResponse:(int)error Code:(NSString *)code Data:(NSObject *)data; 
//error 0没有错误  -1保存文件错误
- (void) httpFileFinish:(int)error Code:(NSString *)code FileName:(NSString *)fileName FullName:(NSString *)fullName;
@end



@interface HqewHttp : NSOperation{
    NSMutableDictionary *DataDict;
    NSData *DataStream;
}
+ (NSOperationQueue *)httpQueue;

@property (nonatomic, weak)id<HqewHttpDelegate> delegate;
@property (nonatomic, strong)NSString *Code;
@property (nonatomic, strong)NSString *Data;
@property (nonatomic, strong)NSString *Url;
@property (nonatomic, strong)NSString *Method;
@property HttpDataType DataType;
@property BOOL useCache;
@property int expireTime;
@property (nonatomic, assign) BOOL isUseCacheOnError;

-(id) initWithCode:(NSString *)code;
-(void) setCode:(NSString *)code;

//-(void)Request:(NSString *)code postData:(NSString *)pData; 
//get请求的操作
-(void)GetData;
-(void)GetData:(NSString *)code; 

//post请求的操作
-(void)AddData:(NSString *)keyName Value:(NSString *)keyValue;
-(void)PostData;
-(void)PostData:(NSString *)code Data:(NSString *)pData; 
-(void)PostData:(NSData *)pData;
-(void)PostData:(NSString *)code sData:(NSData *)pData;
//下载文件
-(void)GetFile;
- (BOOL) isExistsInCache:(NSString *)fileName;
- (NSString *) getImageCachePath;

@end
