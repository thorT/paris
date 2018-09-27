//
//  PhoneInfo.h
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneInfo : NSObject

+ (NSString *)idfa;
+ (BOOL)idfaEnable;

+ (NSString *)serviceProvider;// 手机运营商

+ (NSString *)deviceVersion;//设备版本


+ (NSString *)uptime;// 开机时间

+ (NSString *)diskTotalSize;

+ (NSString *)diskFreeSize;

+ (NSString *)screenBrightness;//屏幕亮度

+ (NSString *)batterylevel;//电池电量




@end
