//
//  HqewHttp.m
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-28.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//
#import "HqewHttp.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HqewIO.h"
//#import "SBJson.h"
#import "HqewUtil.h"
#import <CommonCrypto/CommonDigest.h>

#define WIFI_USERNAME @"hqmartpublic"
#define WIFI_PASSWORD @"123456"

@implementation HqewHttp

@synthesize delegate;
@synthesize Code;
@synthesize Data;
@synthesize Url;
@synthesize Method;
@synthesize useCache;
@synthesize expireTime;
@synthesize DataType;
@synthesize isUseCacheOnError;

static NSOperationQueue *httpQueue = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        if (httpQueue == nil)
        {
            httpQueue = [[NSOperationQueue alloc] init];
            [httpQueue setMaxConcurrentOperationCount:2];
        }
        DataDict = [[NSMutableDictionary alloc] init];
        
        useCache = NO;
        expireTime = 0;
        DataType = hdtJson;
        isUseCacheOnError = NO;
    }
    return self;
}

-(id) initWithCode:(NSString *)code
{
    self.Code = [[NSString alloc] initWithString:code];
    
    return [self init];
}

/*
-(NSString *)ObjToStr:(NSObject *)obj
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

-(NSMutableDictionary *)StrToObj:(NSString *)str
{
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
  
}*/

//将post的数据拼成字符串
//不处理特殊字符串
-(NSString *)getPostDataStr
{
    NSString *returnData = nil;
    if([DataDict count] > 0)
    {
        returnData = [[NSString alloc] init];
        NSArray *tmpAry = [DataDict allKeys];
        for(NSString *key in tmpAry)
        {
            returnData = [returnData stringByAppendingFormat:@"&%@=%@",key, [DataDict objectForKey:key]];
        }
    }
    return returnData;
}

/*-(NSString *)getFileNameFromUrl:(NSString *)fileUrl
{
    NSArray *tmpArray = [fileUrl componentsSeparatedByString:@"/"];
    return [tmpArray lastObject];
}*/

-(BOOL)saveData:(NSString *)folderName FileName:(NSString *)fileName FileData:(NSData *)fileData
{
    return [HqewIO saveDataToFile:fileData toDir:folderName toFile:fileName];
}

//保存文件缓存时间信息
-(void)saveDataTime:(NSString *) folderName FileName:(NSString *)fileName
{
    NSDate *now = [[NSDate alloc] init];
    int tmpTime = [now timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"{\"stime\":%d, \"etime\":%d,\"sec\":%d}",tmpTime, tmpTime + self.expireTime, self.expireTime];
    [HqewIO saveStringToFile:str toDir:folderName toFile:fileName];
}

//FileName 只有文件名，没有目录
//FolderName 目录
-(NSData *)readData:(NSString *)folderName FileName:(NSString *)fileName
{
    //if (![self IsCacheExpired:folderName FileName:fileName])
    //{
        NSString *tfname = [NSString stringWithFormat:@"%@/%@/%@",[HqewIO getDocPath],folderName,fileName];
        NSData *returnData = [HqewIO readDataFromFile:tfname];
        return returnData;
    //}
    //else
    //    return nil;
}

-(NSString *)readStringData:(NSString *)folderName FileName:(NSString *)fileName
{
    NSData *tmpData = [self readData:folderName FileName:fileName];
    if (tmpData == nil)
        return nil;
    else
    {
        NSString *returnData = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
        return returnData;
    }
}

//验证缓存是否已过期 
//已过期返回yes 未过期返回no
-(BOOL)IsCacheExpired:(NSString *)folderName FileName:(NSString *)fileName
{
    NSString *tfname = [NSString stringWithFormat:@"%@/%@/%@",[HqewIO getDocPath],folderName,fileName];
    NSString *str = [HqewIO readStringFromFile:tfname];
    if (str == nil)
        return YES;
    NSMutableDictionary *cacheInfo = [HqewUtil StrToObj:str];
    if (cacheInfo == nil)
        return YES;
    //int stime = [[cacheInfo objectForKey:@"stime"] intValue];
    int etime = [[cacheInfo objectForKey:@"etime"] intValue];
    int sec = [[cacheInfo objectForKey:@"sec"] intValue];
    if (sec == 0)
        return YES;
    else if(sec == -1)
        return NO;
    else
    {
        int tmpTime = [HqewUtil GetUnixTime];
        if (tmpTime > etime)
            return YES;
        else
            return NO;
    }
}


/*-(NSString *)GetUrlFromCode:(NSString *)_code
{
    NSString *tmpUrl = [[NSString alloc] initWithString:@"http://szhq2.xianbey.com/common/NoWebAdapter.aspx"];
    tmpUrl = [tmpUrl stringByAppendingString:@"?NO="];
    tmpUrl = [tmpUrl stringByAppendingString:_code];
    return tmpUrl;

}*/

+ (NSOperationQueue *)httpQueue
{
    return httpQueue;
}

- (void) useCacheOnError:(NSString *)cacheFileName {
    NSString *cacheData = nil;
    NSObject *returnObj = nil;
    NSMutableDictionary *jsonDict = nil;
    
    if (self.useCache)
    {
        cacheData = [self readStringData:_CacheFolder FileName:cacheFileName];
    }
    if (cacheData != nil)
    {
        if (DataType == hdtJson)
        {
            jsonDict = [HqewUtil StrToObj:cacheData];
            if (jsonDict != nil)
                returnObj = jsonDict;
        }
        else {
            returnObj = cacheData;
        }
    }
    if (returnObj != nil)
    {
        if (delegate != nil)
            [delegate httpResponse:0 Code:self.Code Data:returnObj];
    }
    else {
        if (delegate) {
            [delegate httpResponse:-2 Code:self.Code Data:@""];
        }
    }
}


-(void)doGet
{
    NSString *rUrlStr = nil;
    NSURL *rUrl = nil;
    ASIHTTPRequest *request = nil;
    //SBJsonParser *json = nil;
    NSMutableDictionary *jsonDict = nil;
    NSString *cacheData = nil;
    NSObject *returnObj = nil;
    BOOL isExpired = YES;
    NSString *cacheFileName = @"";

    if (self.useCache)
    {
        cacheFileName = [NSString stringWithFormat:_CacheNameLabel,self.Code,@""];
        NSString *tmpTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,cacheFileName];
        
        cacheData = [self readStringData:_CacheFolder FileName:cacheFileName];
        isExpired = [self IsCacheExpired:_CacheFolder FileName:tmpTimeFileName];
    }
    if (cacheData != nil && !isExpired)
    {
        if (DataType == hdtJson)
        {
            jsonDict = [HqewUtil StrToObj:cacheData];
            if (jsonDict != nil)
                returnObj = [jsonDict objectForKey:@"Result"];
        }
        else {
            returnObj = cacheData;
        }
    }
    if (returnObj != nil)
    {
        if (delegate != nil)
            [delegate httpResponse:0 Code:self.Code Data:returnObj];
    }
    else
    {
        rUrlStr = [[NSString alloc] initWithString:self.Url];
        rUrl = [NSURL URLWithString:rUrlStr];
        request = [ASIHTTPRequest requestWithURL:rUrl];
        request.timeOutSeconds = 15;

        [request startSynchronous];
        int statusCode = request.responseStatusCode;
        NSError *error = [request error];
        if(!error)
        {
            NSString *response = [request responseString];
            [self doResponseString:statusCode ResponseData:response CacheObj:returnObj];
        }
        else
        {
            if (isUseCacheOnError) {
                [self useCacheOnError:cacheFileName];
                return ;
            }
            
            if (DataType == hdtJson)
            {
                jsonDict = [HqewUtil StrToObj:cacheData];
                if (jsonDict != nil)
                    returnObj = [jsonDict objectForKey:@"Result"];
            }
            else 
            {
                returnObj = cacheData;
            }
            if (delegate != nil)
            {
                if (returnObj != nil)
                {
                    [delegate httpResponse:0 Code:self.Code Data:returnObj];
                }
                else 
                {
                    [delegate httpResponse:-1 Code:self.Code Data:nil];
                }
            }
        }
    }
}

-(void)doPost
{
    NSString *rUrlStr = nil;
    NSURL *rUrl = nil;
    ASIFormDataRequest *request = nil;
    NSMutableDictionary *jsonDict = nil;
    NSString *cacheData = nil;
    NSObject *returnObj = nil;
    BOOL isExpired = YES;
    NSString *cacheFileName = @"";
    
    if (self.useCache)
    {
        cacheFileName = [NSString stringWithFormat:_CacheNameLabel,self.Code,[HqewUtil MD5Encode:[self getPostDataStr]]];
        NSString *tmpTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,cacheFileName];
        
        cacheData = [self readStringData:_CacheFolder FileName:cacheFileName];
        isExpired = [self IsCacheExpired:_CacheFolder FileName:tmpTimeFileName];
    }

    if (cacheData != nil && !isExpired)
    {
        if (DataType == hdtJson)
        {
            jsonDict = [HqewUtil StrToObj:cacheData];
            if (jsonDict != nil)
                returnObj = [jsonDict objectForKey:@"Result"];
        }
        else
        {
            returnObj = cacheData;
        }
    }
    if (returnObj != nil)
    {
        if (delegate != nil)
            [delegate httpResponse:0 Code:self.Code Data:returnObj];
    }
    else
    {
        rUrlStr = [[NSString alloc] initWithString:self.Url];
        rUrl = [NSURL URLWithString:rUrlStr];
        request = [ASIFormDataRequest requestWithURL:rUrl];
        request.timeOutSeconds = 15;
        if([DataDict count] > 0)
        {
            NSArray *tmpAry = [DataDict allKeys];
            for(NSString *key in tmpAry)
            {
                NSString *val = [DataDict objectForKey:key];
                [request addPostValue:val forKey:key];
            }
        }
        
        [request startSynchronous];
        int statusCode = request.responseStatusCode;
        
        NSError *error = [request error];
        if(!error)
        {
            NSString *response = [request responseString];
            [self doResponseString:statusCode ResponseData:response CacheObj:returnObj];
            
        }
        else
        {
            if (isUseCacheOnError) {
                [self useCacheOnError:cacheFileName];
                return ;
            }
            
            if (DataType == hdtJson)
            {
                jsonDict = [HqewUtil StrToObj:cacheData];
                if (jsonDict != nil)
                    returnObj = [jsonDict objectForKey:@"Result"];
            }
            else
            {
                returnObj = cacheData;
            }
            if (delegate != nil)
            {
                if (returnObj != nil)
                {
                    [delegate httpResponse:0 Code:self.Code Data:returnObj];
                }
                else 
                {
                    [delegate httpResponse:-1 Code:self.Code Data:nil];
                }
            }
        }  
    }

}

-(void)doPostStream
{
    NSString *rUrlStr = nil;
    NSURL *rUrl = nil;
    ASIFormDataRequest *request = nil;
    NSMutableDictionary *jsonDict = nil;
    NSString *cacheData = nil;
    NSObject *returnObj = nil;
    BOOL isExpired = YES;
    NSString *cacheFileName = @"";
    
    if (self.useCache)
    {
        NSString *strPostData = [[NSString alloc] initWithData:DataStream encoding:NSUTF8StringEncoding];
        cacheFileName = [NSString stringWithFormat:_CacheNameLabel,self.Code,[HqewUtil MD5Encode:strPostData]];
        NSString *tmpTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,cacheFileName];
        
        cacheData = [self readStringData:_CacheFolder FileName:cacheFileName];
        isExpired = [self IsCacheExpired:_CacheFolder FileName:tmpTimeFileName];
    }
    
    if (cacheData != nil && !isExpired)
    {
        if (DataType == hdtJson)
        {
            jsonDict = [HqewUtil StrToObj:cacheData];
            if (jsonDict != nil)
                returnObj = jsonDict;
        }
        else
        {
            returnObj = cacheData;
        }
    }
    if (returnObj != nil)
    {
        if (delegate != nil)
            [delegate httpResponse:0 Code:self.Code Data:returnObj];
    }
    else
    {
        rUrlStr = [[NSString alloc] initWithString:self.Url];
        rUrl = [NSURL URLWithString:rUrlStr];
        request = [ASIFormDataRequest requestWithURL:rUrl];
        request.timeOutSeconds = 15;
        if (DataStream != nil)
        {
            [request appendPostData:DataStream];
        }
        
        [request startSynchronous];
        int statusCode = request.responseStatusCode;
        
        NSError *error = [request error];
        if(!error)
        {
            NSString *response = [request responseString];
            [self doResponseString:statusCode ResponseData:response CacheObj:returnObj];
            
        }
        else
        {
            if (isUseCacheOnError) {
                [self useCacheOnError:cacheFileName];
                return ;
            }
            
            if (DataType == hdtJson)
            {
                jsonDict = [HqewUtil StrToObj:cacheData];
                if (jsonDict != nil)
                    returnObj = [jsonDict objectForKey:@"Result"];
            }
            else
            {
                returnObj = cacheData;
            }
            
            if (delegate != nil)
            {
                if (returnObj != nil)
                {
                    [delegate httpResponse:0 Code:self.Code Data:returnObj];
                }
                else
                {
                    [delegate httpResponse:-1 Code:self.Code Data:nil];
                }
            }
        }
    }
}

- (void) errorNotify:(NSInteger)errorCode CmdCode:(NSString *)code Data:(id)data
{
    if (delegate != nil)
    {
        [delegate httpResponse:0 Code:self.Code Data:data];
    }
}

-(int) Octal2Integer:(NSString *)OctalString {
    int result = 0;
    if ([OctalString length] >= 3) {
        int int1 = [[OctalString substringWithRange:NSMakeRange(0, 1)] intValue];
        int int2 = [[OctalString substringWithRange:NSMakeRange(1, 1)] intValue];
        int int3 = [[OctalString substringWithRange:NSMakeRange(2, 1)] intValue];
        
        result = int1 * 64 + int2 * 8 + int3;
    }
    return result;
}

-(NSString *) Octal2String:(NSString *)OctalString {
    NSArray *ary = [OctalString componentsSeparatedByString:@"\\"];
    NSString *result = @"";
    NSMutableData *data = [[NSMutableData alloc] init];
    
    @try {        
        for (NSString *str in ary) {
            if ([str isEqualToString:@""]) {
                continue;
            }
            int ret = [self Octal2Integer:str];
            [data appendBytes:&ret length:sizeof(ret)];
        }
        NSLog(@"%@", data);
    }
    @catch (NSException *exception) {
        NSLog(@"Octal2String except: %@", exception.description);
    }
    @finally {
        
    }        
    
    result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

-(NSMutableArray *) Octal2Array:(NSString *)OctalString {
    NSArray *ary = [OctalString componentsSeparatedByString:@"\\"];
    NSMutableArray *resultAry = [[NSMutableArray alloc] init];
    
    @try {
        for (NSString *str in ary) {
            if ([str isEqualToString:@""]) {
                continue;
            }
            int ret = [self Octal2Integer:str];
            [resultAry addObject:[NSNumber numberWithInt:ret]];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Octal2String except: %@", exception.description);
    }
    @finally {
        
    }
    
    return resultAry;
}

- (BOOL) isLogined:(NSString *)response {
    BOOL result = NO;
    NSRange locRange = [response rangeOfString:@"mikrotik hotspot > redirect"];
    result = locRange.location != NSNotFound;
    return result;
}

-(void)doFile
{
    NSString *downFileName = [HqewUtil getFileNameFromUrl:self.Url];//[self getFileNameFromUrl:@"/file/Images/ShopTouch/201205/18/201251893558715166.jpg"];
    NSString *fullName = [NSString stringWithFormat:@"%@/%@/%@",[HqewIO getDocPath], _CacheImagesFolder, downFileName];

    NSString *rUrlStr = nil;
    NSURL *rUrl = nil;
    ASIHTTPRequest *request = nil;
    BOOL ReGet = YES;
    BOOL isExpired = YES;
    if (self.useCache)
    {
        NSString *cacheTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,downFileName];
        isExpired = [self IsCacheExpired:_CacheImagesFolder FileName:cacheTimeFileName];
        if(!isExpired)
        {
            if ([HqewIO fileExists:fullName])
            {
                ReGet = NO;
                if (delegate != nil)
                    [delegate httpFileFinish:0 Code:self.Code FileName:downFileName FullName:fullName];
            } 
        }
    }
    
    if (ReGet)
    {
        rUrlStr = [[NSString alloc] initWithString:self.Url];
        rUrl = [NSURL URLWithString:rUrlStr];
        request = [ASIHTTPRequest requestWithURL:rUrl];
        request.timeOutSeconds = 15;
    
        [request startSynchronous];
        int statusCode = request.responseStatusCode;
        NSError *error = [request error];
        if(!error)
        {
            NSData *tmpData = [request responseData];
            [self doSaveResponse:statusCode ResponseData:tmpData];
        }
        else
        {
            if (delegate != nil)
            {
            if ([HqewIO fileExists:fullName])
            {
                [delegate httpFileFinish:0 Code:self.Code FileName:downFileName FullName:fullName];
            } 
            else 
            {
                [delegate httpFileFinish:-1 Code:self.Code FileName:downFileName FullName:fullName];
            }
            }
        }
    }
}

//处理返回的字符串内容
-(void)doResponseString:(int)statusCode ResponseData:(NSString *)rData CacheObj:(NSObject *)cacheObj
{
    NSMutableDictionary *jsonDict = nil;
    NSObject *returnObj = nil;
    BOOL isGetOK = NO;
    switch(statusCode)
    {
        case 200:
        case 304:
            if (DataType == hdtJson)
            {
                jsonDict = [HqewUtil StrToObj:rData];
                if (jsonDict != nil)
                {
                    returnObj = [jsonDict objectForKey:@"Result"];
                    if (returnObj == nil) {
                        if ([jsonDict objectForKey:@"data"]) {
                            returnObj = jsonDict;
                        }
                    }
                    if (returnObj != nil)
                    {
                        isGetOK = YES;
                    }
                    else 
                    {
                        if ([jsonDict objectForKey:@"rtn"]) {
                            isGetOK = YES;
                            returnObj = jsonDict;
                        } else {
                            isGetOK = NO;
                            NSLog(@"%s: %@", __func__, rData);
                        }
                        
                    }
                }
            }
            else
            {
                if (rData != nil)
                {
                    returnObj = rData;
                    isGetOK = YES;
                }
                else 
                {
                    returnObj = nil;
                }
            }
            break;
        //default:
        //    [delegate httpResponse:statusCode Code:self.Code Data:nil];
        //    break;
    }
    if (isGetOK)
    {
        if (delegate != nil)
            [delegate httpResponse:0 Code:self.Code Data:returnObj];
        
        if (self.useCache && jsonDict != nil)
        {
            NSData *tmpData = [rData dataUsingEncoding:NSUTF8StringEncoding];
            if ([self.Method isEqualToString:@"GET"])
            {
                NSString *tmpFileName = [NSString stringWithFormat:_CacheNameLabel,self.Code,@""];
                NSString *tmpTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,tmpFileName];
                
                if ([self saveData:_CacheFolder FileName:tmpFileName FileData:tmpData])
                    [self saveDataTime:_CacheFolder FileName:tmpTimeFileName];
            }
            else
            {
                NSString *tmpFileName;
                if ([self.Method isEqualToString:@"STREAM"]) {
                    NSString *strPostData = [[NSString alloc] initWithData:DataStream encoding:NSUTF8StringEncoding];
                    tmpFileName = [NSString stringWithFormat:_CacheNameLabel,self.Code,[HqewUtil MD5Encode:strPostData]];
                }
                else if ([self.Method isEqualToString:@"POST"]) {
                    tmpFileName = [NSString stringWithFormat:_CacheNameLabel,self.Code,[HqewUtil MD5Encode:[self getPostDataStr]]];
                }
                else {
                    return ;
                }
                
                NSString *tmpTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,tmpFileName];
                
                if ([self saveData:_CacheFolder FileName:tmpFileName FileData:tmpData])
                    [self saveDataTime:_CacheFolder FileName:tmpTimeFileName];
            }
        }
    }
    else 
    {
        NSLog(@"%s: %@", __func__, rData);
        if (delegate != nil)
        {
            if (cacheObj != nil)
                [delegate httpResponse:0 Code:self.Code Data:cacheObj];
            else {
                [delegate httpResponse:-1 Code:self.Code Data:rData];
            }
        }
    }
}

-(void)doResponseString:(int)statusCode ResponseData:(NSString *)rData
{
    NSMutableDictionary *jsonDict = nil;
    NSObject *returnObj = nil;
    BOOL isGetOK = NO;
    switch(statusCode)
    {
        case 200:
        case 304:
            
            jsonDict = [HqewUtil StrToObj:rData];
            if (jsonDict != nil)
            {
                isGetOK = YES;
                returnObj = jsonDict;
            }
            
            break;
    }
    if (isGetOK)
    {
        if (delegate != nil)
            [delegate httpResponse:0 Code:self.Code Data:returnObj];
    }
    else 
    {
        if (delegate != nil)
        {
            [delegate httpResponse:-1 Code:self.Code Data:nil];
        }
    }  
}

-(void)doSaveResponse:(int)statusCode ResponseData:(NSData *)data
{
    NSString *fname = [HqewUtil getFileNameFromUrl:self.Url];
    NSString *funame = [NSString stringWithFormat:@"%@/%@/%@",[HqewIO getDocPath], _CacheImagesFolder, fname];
    BOOL isGetOK = NO;
    
    switch(statusCode)
    {
        case 200:
        case 304:
            if ([HqewIO saveDataToFile:data toDir:_CacheImagesFolder toFile:fname])
            {
                isGetOK = YES;
            }
            break;
    } 
    if (isGetOK)
    {
        if (self.useCache)
        {
            NSString *tmpTimeFileName = [NSString stringWithFormat:_CacheTimeLabel,fname];
            [self saveDataTime:_CacheImagesFolder FileName:tmpTimeFileName];
        }
        if (delegate != nil) {
            [delegate httpFileFinish:0 Code:self.Code FileName:fname FullName:funame]; 
        }
        
    }
    else 
    {
        if (delegate != nil) {
            if ([HqewIO fileExists:funame])
                [delegate httpFileFinish:0 Code:self.Code FileName:fname FullName:funame]; 
            else 
            {
                [delegate httpFileFinish:-1 Code:self.Code FileName:fname FullName:funame]; 
            }
        }
        
    }
}

-(void)main{
    @try {
        if ([self.Method isEqualToString:@"GET"])
        {
            [self doGet];
        }
        else if ([self.Method isEqualToString:@"POST"])
        {
            [self doPost];
        }
        else if ([self.Method isEqualToString:@"STREAM"])
        {
            [self doPostStream];
        }
        else
        {
            [self doFile];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
    @finally {
        
    }
    
}

-(void)GetData
{
    self.Method = @"GET";
    [httpQueue addOperation:self];
}

//Get请求
-(void)GetData:(NSString *)code
{
    self.Code = code;
    self.Method = @"GET";
    [httpQueue addOperation:self];
}

//添加post时的数据
-(void)AddData:(NSString *)keyName Value:(NSString *)keyValue
{
    //NSString *tmpVal = [DataDict objectForKey:keyValue];
    [DataDict setObject:keyValue forKey:keyName];
}

//post请求
-(void)PostData
{
    self.Method = @"POST";
    [httpQueue addOperation:self];
}

-(void)PostData:(NSData *)pData
{
    self.Method = @"STREAM";
    DataStream = [[NSData alloc] initWithData:pData];
    [httpQueue addOperation:self];
}

-(void)PostData:(NSString *)code sData:(NSData *)pData
{
    self.Method = @"STREAM";
    self.Code = code;
    DataStream = [[NSData alloc] initWithData:pData];
    [httpQueue addOperation:self];   
}

/*
-(void)PostData:(NSString *)code Data:(NSString *)pData
{
    self.Code = code;
}*/

//下载文件
-(void)GetFile
{
    self.Method = @"FILE";
    //self.Code = @"";
    [httpQueue addOperation:self];
}

- (BOOL) isExistsInCache:(NSString *)fileName {
    NSString *fullName = [NSString stringWithFormat:@"%@/%@/%@",[HqewIO getDocPath], _CacheImagesFolder, fileName];
    return [HqewIO fileExists:fullName];
}

- (NSString *) getImageCachePath {
    return [NSString stringWithFormat:@"%@/%@/",[HqewIO getDocPath], _CacheImagesFolder];
}

@end
