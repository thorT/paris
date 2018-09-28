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
#import "Const.h"


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

#import "JailBreak.h"
#import "WIFIInfo.h"
#import "VPN.h"
#import "PhoneInfo.h"
#import "HttpProxy.h"
#import "NetRequestClass.h"
#import "SimulateIDFA.h"


@interface DeviceParam ()

@end

@implementation DeviceParam

//保存网络图片至本地
-(void)saveImage:(NSString *)str{
    
    // 是否同意向本地存图片
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        { // 未授权,弹出授权框
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                // 用户选择完毕就会调用—选择允许,直接保存
                if (status == PHAuthorizationStatusAuthorized) {
                    [self save:str];
                }
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        { // 授权,就直接保存
            [self save:str];
            break;
        }
        default:
        {// 拒绝   告知用户去哪打开授权
            self.SaveImage(NO, NO);
            break;
        }
    }
}

- (void)save:(NSString *)str{
    NSURL *url = [NSURL URLWithString:str];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    if (nil != error){
        //1. 路径无效
        NSLog(@"error == %@",error);
        self.SaveImage(YES,NO);
    }
    else{
        UIImage *image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (!error) {
        self.SaveImage(YES,YES);
    }else
    {// 2. 保存失败， （用户未打开隐私）
        self.SaveImage(NO,YES);
        NSLog(@"imageSave error%@",error.description);
    }
}

#pragma mark - devive
//获取所有相关的参数
+(NSDictionary *)deviceParam
{
    //idfa
    NSString *idfa=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    BOOL idfaEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    if (!idfaEnabled) {
        [Const alertWith:@"前往系统设置->隐私->广告->关闭限制广告跟踪"];
    }
    
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
    
    NSString *dns = [self outPutDNSServers];
    if (dns == nil) {dns = @"";}
    NSString *simType = [PhoneInfo serviceProvider]!=nil?[PhoneInfo serviceProvider]:@"";
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"]!= nil?[infoDictionary objectForKey:@"CFBundleDisplayName"]:@"";
    // 版本
    NSString *appVer = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
    NSString *uuid = currentDeviceUUID.UUIDString;
    if ([GB_ToolUtils isBlank:uuid]) {uuid = @"";}
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    if ([GB_ToolUtils isBlank:bid]) {bid = @"";}
    NSInteger netStatus = [NetRequestClass netWorkStatus];
    NSString *plid = [DataSingleton sharedDataSingleton].plid;
    if ([GB_ToolUtils isBlank:plid]) { plid = @"";}
   // plid = @"20076BA4-A6E7-441f-9f74-4er1631B6143";
    //NSString *keys = [Chain getChainKeys];
    NSString *uid = [Const DataSGet:s_uid];
    if ([GB_ToolUtils isBlank:uid]) { uid = @"";}
    NSString *languages = [NSLocale preferredLanguages][0];
    if ([GB_ToolUtils isBlank:languages]) { languages = @"";}
    NSString *simulateIDFA = [SimulateIDFA createSimulateIDFA];
    if ([GB_ToolUtils isBlank:simulateIDFA]) { simulateIDFA = @"";}
    
    return  @{@"WIFI_SSID":wifiName,@"WIFI_BSSID":wifiBSSID,@"Device_IDFA":idfa,@"fromStartDuration":TimeDurationString,@"totalDiskSpace":diskTotalSize,@"freeDiskSpace":diskFreeSize,@"screenBrightness":screenBrightness,@"batteryLevel":batterylevelString,@"hasJailBreakFile":@(hasJailBreakFile),@"canOpenCydiaUrl":@(canOpenCydiaUrl),@"getEnv":@(getEnv),@"loadAllApp":@(loadAllApp),@"isJailBreak":@(isJailBreak),@"batteryState":@(deviceBatteryState),@"VPN":@(isVPN),@"deviceVersion":deviceVersion,@"httpProxy":fetchHttpProxy,@"dns":dns,@"simType":simType,@"sysVer":@(sysVer),@"appName":appName,@"appVer":appVer,@"idfaEnabled":@(idfaEnabled),@"deviceModel":deviceModel,@"uuid":uuid,@"bid":bid,@"netStatus":@(netStatus),@"plid":plid,@"uid":uid,@"ptype":@"1",@"languages":languages,@"simulateIDFA":simulateIDFA};
    
    //ptype 1.iphone，2.安卓
}



static void queryCallback(DNSServiceRef sdRef, DNSServiceFlags flags, uint32_t interfaceIndex,
                          DNSServiceErrorType errorCode, const char *fullname, uint16_t rrtype,
                          uint16_t rrclass, uint16_t rdlen, const void *rdata, uint32_t ttl, void *context)
{
    
    NSLog(@"124");
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
        NSLog(@"%@", theTXT);
        TXT_record = theTXT;
    }
}

static NSString *TXT_record = @"";

-(void)txt_record_action:(NSString *)str{
    const char * txt =[str UTF8String];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"123");
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
        NSLog(@"%@",@" res_init result != 0");
    }
    
    res_nclose(res);
    
    return dnsArray.firstObject;
}



@end










