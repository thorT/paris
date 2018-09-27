//
//  PhoneInfo.m
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "PhoneInfo.h"
#import <sys/sysctl.h>//屏幕亮度
#import "sys/utsname.h"//设备版本
#import <AdSupport/AdSupport.h> //idfa


// 手机运营商
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#if __has_feature(objc_arc)
#define YX_release(obj)
#define YX_autorelease(obj)
#else
#define YX_release(obj)      [obj release]
#define YX_autorelease(obj)  [obj autorelease]
#endif

@implementation PhoneInfo

+ (NSString *)idfa{
    //idfa
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (BOOL)idfaEnable{
    //idfa
   return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
}


//中国移动 00 02 07
//中国联通 01 06
//中国电信 03 05
//中国铁通 20
+ (NSString *)serviceProvider
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    // information about the user’s home cellular service provider
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil)
    {
        YX_release(carrier);
        carrier = nil;
        
        return @"";
    }
    
    // The mobile network code (MNC) for the user’s cellular service provider
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil)
    {
        YX_release(carrier);
        carrier = nil;
        
        return @"";
    }
    
    return code;
}


+ (NSString *)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if (nil == deviceString) {deviceString = @"";}
    　return deviceString;
}

+ (NSString *)uptime{
    time_t durationTime=[self uptimeFun];
    NSString *timeDurationString=[NSString stringWithFormat:@"%.2ld",durationTime];
    return timeDurationString;
}

+ (NSString *)diskTotalSize{
//    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:NSHomeDirectory() error:nil];
   NSString *diskTotalSize = [systemAttributes objectForKey:@"NSFileSystemSize"];
    return diskTotalSize!=nil?diskTotalSize:@"";
}

+ (NSString *)diskFreeSize{
//    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
  NSDictionary *systemAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:NSHomeDirectory() error:nil];
    NSString *diskFreeSize = [systemAttributes objectForKey:@"NSFileSystemFreeSize"];
    return diskFreeSize!=nil?diskFreeSize:@"";
}

+ (NSString *)screenBrightness{
    float brightness=[UIScreen mainScreen].brightness;
   return [NSString stringWithFormat:@"%.0f",brightness];
}

+ (NSString *)batterylevel{
    [[UIDevice currentDevice]setBatteryMonitoringEnabled:YES];
    float level=[[UIDevice currentDevice]batteryLevel];
    NSString *batterylevel=[NSString stringWithFormat:@"%.0f",level];
    return batterylevel;
}


+(time_t)uptimeFun
{
    struct timeval boottime;
    
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    
    size_t size = sizeof(boottime);
    
    time_t now;
    
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        
        uptime = now - boottime.tv_sec;
        
    }
    return uptime;
    
}

@end
