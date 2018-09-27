//
//  DKADSetBaiduCpuAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/9/29.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetBaiduCpuAdapter.h"
#import "BaiduMobAdSDK/BaiduMobCpuInfoManager.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
@implementation DKADSetBaiduCpuAdapter


- (NSString *)load{
    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    BaiduMobCpuInfoManager *manager = [BaiduMobCpuInfoManager shared];
    
    NSString *urlStr = [manager getCpuInfoUrlWithChannelId:self.channelId appId:self.appId];
    if (urlStr) {
        return urlStr;
        
    }
    return nil;
}

- (void)dealloc{
    
}

@end
