//
//  WHDeviceParam.m
//  UZApp
//
//  Created by wuhao on 15/10/29.
//  Copyright © 2015年 APICloud. All rights reserved.
//


#import "DeviceParam.h"
#import <AdSupport/AdSupport.h> //idfa



#import <SystemConfiguration/CaptiveNetwork.h>
#import <Photos/Photos.h>


// vpn
#import <ifaddrs.h>
// 设备类型
#import "sys/utsname.h"

#import <dns_sd.h>
#import <resolv.h>
#include <arpa/inet.h>
#import <netdb.h>
#import <CoreTelephony/CTCellularData.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import "chain.h"
#import "JailBreak.h"
#import "WIFIInfo.h"
#import "VPN.h"
#import "PhoneInfo.h"
#import "HttpProxy.h"
#import "NetRequestClass.h"


@interface DeviceParam ()

@end

@implementation DeviceParam



#pragma mark - devive
//获取所有相关的参数
+(NSDictionary *)deviceParam
{
    //idfa
    NSString *idfa=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    BOOL idfaEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    //获取手机开机时间
    NSString *TimeDurationString=[PhoneInfo uptime];
    //获取硬盘的空间大小
    NSString *diskTotalSize = [PhoneInfo diskTotalSize];
    NSString *diskFreeSize = [PhoneInfo diskFreeSize];
    //获取屏幕亮度
    NSString *screenBrightness=[PhoneInfo screenBrightness];
    //获取电池百分比
    NSString *batterylevelString=[PhoneInfo batterylevel];
    [[UIDevice currentDevice]setBatteryMonitoringEnabled:YES];
    UIDeviceBatteryState deviceBatteryState = [UIDevice currentDevice].batteryState;
    
    //判断越狱
    BOOL hasJailBreakFile= [JailBreak hasJailBreakFile];
    BOOL canOpenCydiaUrl= [JailBreak canOpenCydiaUrl];
    BOOL getEnv= [JailBreak getJailBreakEnv];
    BOOL loadAllApp= [JailBreak loadAllAppName];
    BOOL isJailBreak= [JailBreak isJailBreak];
    
    // wifi
    NSDictionary *wifi_Info = [WIFIInfo wifi_info]!=nil?[WIFIInfo wifi_info]:@{};
    NSString *wifiName = wifi_Info[@"SSID"]!=nil?wifi_Info[@"SSID"]:@"";
    NSString *wifiBSSID=wifi_Info[@"BSSID"]!=nil?wifi_Info[@"BSSID"]:@"";
    
    // vpn
    BOOL isVPN = [VPN isVPNConnected];
   
    // 设备类型
  NSString * deviceVersion = [PhoneInfo deviceVersion];
    NSString *deviceModel = [UIDevice currentDevice].model;
    NSString *fetchHttpProxy = [HttpProxy fetchHttpProxy];
    
    NSString *dns = @"";//[self outPutDNSServers];
    if (dns == nil) {dns = @"";}
    NSString *simType = [PhoneInfo serviceProvider]!=nil?[PhoneInfo serviceProvider]:@"";
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"]!= nil?[infoDictionary objectForKey:@"CFBundleDisplayName"]:@"";
    // 版本
    NSString *appVer = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *keys = [Chain getChainKeys] !=nil?[Chain getChainKeys]:@"";
    
    NSInteger netStatus = [NetRequestClass netWorkStatus];
    NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
    NSString *uuid = currentDeviceUUID.UUIDString;
    if ([GB_ToolUtils isBlank:uuid]) {
        uuid = @"";
    }
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    if ([GB_ToolUtils isBlank:bid]) {bid = @"";}
    
   // keys = @"5a4yp3017c|1|7epx80oy14";
    return  @{@"WIFI_SSID":wifiName,@"WIFI_BSSID":wifiBSSID,@"Device_IDFA":idfa,@"fromStartDuration":TimeDurationString,@"totalDiskSpace":diskTotalSize,@"freeDiskSpace":diskFreeSize,@"screenBrightness":screenBrightness,@"batteryLevel":batterylevelString,@"hasJailBreakFile":@(hasJailBreakFile),@"canOpenCydiaUrl":@(canOpenCydiaUrl),@"getEnv":@(getEnv),@"loadAllApp":@(loadAllApp),@"isJailBreak":@(isJailBreak),@"batteryState":@(deviceBatteryState),@"VPN":@(isVPN),@"deviceVersion":deviceVersion,@"httpProxy":fetchHttpProxy,@"dns":dns,@"simType":simType,@"sysVer":@(sysVer),@"appName":appName,@"appVer":appVer,@"idfaEnabled":@(idfaEnabled),@"deviceModel":deviceModel,@"keys":keys,@"netStatus":@(netStatus),@"uuid":uuid,@"bid":bid};
}


static void queryCallback(DNSServiceRef sdRef, DNSServiceFlags flags, uint32_t interfaceIndex,
                          DNSServiceErrorType errorCode, const char *fullname, uint16_t rrtype,
                          uint16_t rrclass, uint16_t rdlen, const void *rdata, uint32_t ttl, void *context)
{
    
    if (errorCode == kDNSServiceErr_NoError && rdlen > 1) {
        
        
        NSMutableData *txtData = [NSMutableData dataWithCapacity:rdlen];
        
        char *p=(char*)rdata;
        for (uint16_t i = 0; i < rdlen; i++) {
            if (*p > 0x20) {
                [txtData appendBytes:p length:1];
            }
            p++;
        }
        
        NSString *theTXT = [[NSString alloc] initWithBytes:txtData.bytes length:txtData.length encoding:NSASCIIStringEncoding];
        TXT_record = theTXT;
    }
}

static NSString *TXT_record = @"";

-(void)txt_record_action:(NSString *)str{
    const char * txt =[str UTF8String];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     
        DNSServiceRef serviceRef;
    DNSServiceErrorType result = DNSServiceQueryRecord(&serviceRef, kDNSServiceFlagsTimeout, 0, txt, kDNSServiceType_TXT,kDNSServiceClass_IN, queryCallback, NULL);
            DNSServiceProcessResult(serviceRef);
            DNSServiceRefDeallocate(serviceRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.txt_recode(TXT_record);
       });
    });
}







+ (BOOL)isStringEmpty:(NSString *)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    return NO;
}





/// 获取本机DNS服务器
+ (NSString *)outPutDNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    NSMutableArray *dnsArray = @[].mutableCopy;
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            
            [dnsArray addObject:s];
        }
    }
    else{
        
    }
    
    res_nclose(res);
    
    return dnsArray.firstObject;
}









@end










