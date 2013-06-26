//
//  HqewNet.h
//  HqewWorldShop
//
//  Created by GanLin Ye on 12-5-28.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqewNet : NSObject

//检测是否启用wifi
+ (BOOL)IsEnableWIFI;

//检测是否启用3G
+ (BOOL)IsEnable3G;

//检测新版本
//return 0:版本相同
//return 1:有新版本
//return -1:检测版本出错
+ (int)CheckVersion;

+ (NSString*)GetPublishVersion;

+ (NSString*)UrlEncode:(NSString *)data;

//获取设备ip地址
+ (NSString *)DeviceIPAdress;
//获取wifi连接的ssid
+ (NSString *) GetConnectSSID;
//检测当前网络类型, 0无连接 1 wifi网络 2 移动网络
+ (NSInteger) currentNetworkType;
//检测有无网络连接
+ (BOOL) networkIsAvailable;

@end
