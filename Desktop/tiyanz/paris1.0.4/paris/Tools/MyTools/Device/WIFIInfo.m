//
//  WIFIInfo.m
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "WIFIInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation WIFIInfo

+ (NSDictionary *)wifi_info{
    NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString *name in interFaceNames)
    {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        
        if (info[@"SSID"])
        {
            return info;
//            wifiName = info[@"SSID"];//SSID
//            wifiBSSID=info[@"BSSID"];//BSSID
        }
    }
    return nil;
}


+ (BOOL)getProxyStatus{
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //没有设置代理
        return NO;
    }else{
        //设置代理了
        return YES;
    }
}
@end
