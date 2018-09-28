//
//  DKADSetBaiduBannerAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/3/24.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetBaiduBannerAdapter.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"


@interface DKADSetBaiduBannerAdapter()<BaiduMobAdViewDelegate>
@property (nonatomic, strong)BaiduMobAdView *bannerV;
@end

@implementation DKADSetBaiduBannerAdapter



- (void)loadBanner{
    
    [super loadBanner];
    
    //lp颜色配置
//    [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDarkBlue];
//    [BaiduMobAdSetting sharedInstance].supportHttps = YES;

    self.bannerV = [[BaiduMobAdView alloc] init];
    //把在mssp.baidu.com上创建后获得的代码位id写到这里
    self.bannerV.AdUnitTag = self.sid;
    self.bannerV.AdType = BaiduMobAdViewTypeBanner;
    self.bannerV.frame = self.superV.bounds;


    [self.superV addSubview:self.bannerV];
    self.bannerV.delegate = self;
    [self.bannerV start];
    
    
}

/**
 *  应用的APPID
 */
- (NSString *)publisherId{
    
    NSLog(@"%s",__func__);
    
    return self.pid;
}


/**
 *  广告将要被载入
 */
-(void) willDisplayAd:(BaiduMobAdView*) adview{
    [self.bannerAdapterDelegate DKADSetBannerAdapterLoadSuccess:adview];
    NSLog(@"%s",__func__);
}

/**
 *  广告载入失败
 */
-(void) failedDisplayAd:(BaiduMobFailReason) reason;
{

    [self.bannerAdapterDelegate DKADSetBannerAdapterLoadFailed:self.bannerV error:[NSString stringWithFormat:@"%u",reason]];
    NSLog(@"%s 百度横幅失败原因%d",__func__, reason);
}



/**
 *  本次广告展示成功时的回调
 */
-(void) didAdImpressed
{
    NSLog(@"%s",__func__);
    [self.bannerAdapterDelegate DKADSetBannerAdapterDidShow:self.bannerV];

}



/**
 *  本次广告展示被用户点击时的回调
 */
-(void) didAdClicked
{
    NSLog(@"%s",__func__);
    [self.bannerAdapterDelegate DKADSetBannerAdapterClicked:self.bannerV];

}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
    [self.bannerAdapterDelegate DKADSetBannerAdapterDidClose:self.bannerV];

}

- (void)dealloc{
    
    [self.bannerV removeFromSuperview];
    self.bannerV.delegate = nil;
    self.bannerV = nil;
    
}

@end
