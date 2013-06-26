//
//  HqewUIDevice.h
//  HqewWorldShop
//
//  Created by Jun Li on 12-5-26.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString(MD5Addition)

- (NSString *) stringFromMD5;

@end

@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

@end