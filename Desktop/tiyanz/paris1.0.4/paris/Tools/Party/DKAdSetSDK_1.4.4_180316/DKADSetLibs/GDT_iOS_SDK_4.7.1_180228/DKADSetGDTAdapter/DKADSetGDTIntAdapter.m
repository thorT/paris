//
//  DKADSetGDTIntAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/4/20.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetGDTIntAdapter.h"

@implementation DKADSetGDTIntAdapter

- (void)configure{
    [super configure];
    
}

- (void)load{
    
    [super load];
    
    self.interstitial = [[GDTMobInterstitial alloc] initWithAppkey:self.pid placementId:self.sid];
    
    self.interstitial.delegate = self;
    
    [self.interstitial loadAd];
    

    
}

#pragma mark - GDTMob Interstitial Delegate

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterLoadAdSuccess:interstitial];
    
    if (interstitial.isReady) {
        [interstitial presentFromRootViewController:self.controller];
    }
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    NSLog(@"%s gdt 插屏 失败原因%@",__func__, error);

    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterLoadAdFail:interstitial error:error];
}

/**
 *  插屏广告曝光时回调
 *  详解: 插屏广告曝光时回调
 */
-(void)interstitialWillExposure:(GDTMobInterstitial *)interstitial
{
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterAdDidShow:interstitial];
}
/**
 *  插屏广告点击时回调
 *  详解: 插屏广告点击时回调
 */
-(void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterAdClicked:interstitial];
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterAdDidClose:interstitial];
}

- (void)dealloc{
    
    self.interstitial.delegate = nil;
    self.interstitial = nil;
    
}

@end
