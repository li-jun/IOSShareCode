//
//  HqewNet.m
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-28.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "HqewNet.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
//#include "XMLParser.h"
//#import "IPAddress.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation HqewNet


+ (BOOL)IsEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)IsEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (BOOL) networkIsAvailable {
    BOOL isWifi = [self IsEnableWIFI];
    BOOL is3G = [self IsEnable3G];
    
    return isWifi || is3G;
}

+ (NSInteger) currentNetworkType {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com.cn"];
    return [r currentReachabilityStatus];
}

+ (NSString*)GetPublishVersion
{
    NSURL *url = [NSURL URLWithString:@"http://172.168.30.244:882/Version.xml"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if(!error)
    {
        /*NSString *response = [request responseString];
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        XMLParser *parse = [XMLParser sharedInstance];
        TreeNode *node = [parse parseXMLFromData:data];
        NSArray *path = [[NSArray alloc]initWithObjects:@"IPhoneVer",nil];
        NSString *ver = [node leafForKeys:path];
        
        return ver;*/
        
        //[HqewIO saveStringToFile:response toDir:@"version" toFile:@"version.dat"];
        
        //[self saveStringToFile:response toFile:@"version.dat"];
        //NSLog(response);
        //[self getAdContent];
        //return response;
        return nil;
    }
    else
        return nil; 
}

+ (int)CheckVersion
{
    //本地版本
    NSDictionary *confDict = [[NSBundle mainBundle] infoDictionary];
    //for (NSString *sk in [confDict allKeys])
    //    NSLog([NSString stringWithFormat:@"key: %@", sk]);
    NSString *appVersion = [confDict objectForKey:@"CFBundleVersion"];
    
    //网上正式发布的版本
    NSString *newVersion = [HqewNet GetPublishVersion];
    
    if (appVersion == nil || newVersion == nil)
    {
        return -1;
    }
    double appVer = [appVersion doubleValue];
    double newVer = [newVersion doubleValue];
    appVer = appVer * 1000;
    newVer = newVer * 1000;
    if (appVer < newVer)
        return 1;
    else
        return 0;
}

+ (NSString*)UrlEncode:(NSString *)data
{
    return [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)DeviceIPAdress {  
    /*InitAddresses();
    GetIPAddresses();  
    GetHWAddresses();  
    return [NSString stringWithFormat:@"%s", ip_names[1]]; */
    return @"";
}  

+ (id)FetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge_retained  CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
        //[info release];
    }
    //[ifs release];
    return info;
}

+ (NSString *) GetConnectSSID
{
    NSDictionary *ifs = [HqewNet FetchSSIDInfo];
    if (ifs != nil)
    {
        //NSArray *ary = ifs.allKeys;
        //for (NSString *kk in ary)
        //{
        //    NSLog(@"key:%@ %@", kk,[ifs objectForKey:kk]);
        //}
        NSString *ssid = [[ifs objectForKey:@"SSID"] lowercaseString];
        if (ssid != nil)
        {
            //NSLog(@"ssid：%@",ssid);
            return ssid;
        }
    }
    return nil;
}
@end
