//
//  DKADSetGDTBannerAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/4/20.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetGDTBannerAdapter.h"

@implementation DKADSetGDTBannerAdapter

- (void)loadBanner{
    
    [super loadBanner];
    
    bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake( 0, (self.superV.bounds.size.height - 50) * 0.5, self.superV.bounds.size.width, 50) appkey:self.pid placementId:self.sid];
    

    bannerView.delegate = self;
    
    bannerView.currentViewController = self.currentViewController;
    
    bannerView.interval = 30;
    
    bannerView.showCloseBtn = YES;
    
    bannerView.isAnimationOn = YES;
    
    [self.superV addSubview:bannerView];
    
    [bannerView loadAdAndShow];

}

#pragma mark - GDTMob BannerView Delegate
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"%s", __func__);
    [self.bannerAdapterDelegate DKADSetBannerAdapterLoadSuccess:nil];
    
    
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    NSLog(@"%s gdt横幅失败原因%@",__func__, error);

    [self.bannerAdapterDelegate DKADSetBannerAdapterLoadFailed:nil error:error];
    
}


/**
 *  banner条曝光回调
 */
- (void)bannerViewWillExposure{
    NSLog(@"%s", __func__);
    [self.bannerAdapterDelegate DKADSetBannerAdapterDidShow:nil];
}
/**
 *  banner条点击回调
 */
- (void)bannerViewClicked{
    NSLog(@"%s", __func__);
    [self.bannerAdapterDelegate DKADSetBannerAdapterClicked:nil];
}

/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)bannerViewWillClose{
    
    [self.bannerAdapterDelegate DKADSetBannerAdapterDidClose:nil];
}

- (void)dealloc{
    
    
    [bannerView removeFromSuperview];
    bannerView.delegate = nil;
    bannerView.currentViewController = nil;
    bannerView = nil;
}

@end
