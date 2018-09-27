//
//  DKADSetBaiduNormalIntAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/3/24.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetBaiduNormalIntAdapter.h"
#import "BaiduMobAdSDK/BaiduMobAdInterstitial.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"

@interface DKADSetBaiduNormalIntAdapter()<BaiduMobAdInterstitialDelegate>
@property (nonatomic, strong)BaiduMobAdInterstitial *interstitialV;
@property (nonatomic, strong) UIView *customAdView;
@end

@implementation DKADSetBaiduNormalIntAdapter



- (void)load{
    
    [super load];
    
    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    if (!self.interstitialV) {
        self.interstitialV = [[BaiduMobAdInterstitial alloc] init];
        self.interstitialV.delegate = self;
        //把在mssp.baidu.com上创建后获得的代码位id写到这里
        self.interstitialV.AdUnitTag = self.sid;
        
        /*
         * 5 插屏广告：其他场景中使用 BaiduMobAdViewTypeInterstitialOther
         * 7 插屏广告：视频图片前贴片 BaiduMobAdViewTypeInterstitialBeforeVideo 有倒计时5s
         * 8 插屏广告：视频暂停贴片 BaiduMobAdViewTypeInterstitialPauseVideo 没有倒计时
         */
        
        
        NSInteger type = self.BaiduInterstitialType.integerValue;
        
        switch (type) {
            case 7:
            {
                self.interstitialV.interstitialType = BaiduMobAdViewTypeInterstitialBeforeVideo;
                [self.interstitialV loadUsingSize:CGRectMake(0, 0, self.customRect.size.width, self.customRect.size.height)];
            }
                break;
                
            case 8:
            {
                self.interstitialV.interstitialType = BaiduMobAdViewTypeInterstitialPauseVideo;
                [self.interstitialV loadUsingSize:CGRectMake(0, 0, self.customRect.size.width, self.customRect.size.height)];
            }
                break;
                
            default:
            {
                self.interstitialV.interstitialType = BaiduMobAdViewTypeInterstitialOther;
                // 加载全屏插屏. 每次仅加载一个广告的物料,若需多次使用请在下次展示前重新执行load方法
                [self.interstitialV load];
            }
                break;
        }
    }
    

}

#pragma mark - aidu MobAd Interstitial Delegate

/**
 *  应用的APPID
 */
- (NSString *)publisherId{
    
//    NSLog(@"%s",__func__);
    
    return self.pid;
}
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial{
    
//    NSLog(@"%s",__func__);
    
    if (self.interstitialV.isReady){
        
 
        NSInteger type = self.BaiduInterstitialType.integerValue;
        
        switch (type) {
            case 7:
                [self customInterstitialPresent];
                break;
                
            case 8:
                [self customInterstitialPresent];
                break;
                
            default:
                [self.interstitialV presentFromRootViewController:self.controller];
                break;
        }
        
        [self.interstitialAdapterDelegate DKADSetInterstitialAdapterLoadAdSuccess:interstitial];
        
    }
    else{
        NSLog(@"not ready!");
    }
    

    

}

- (void)customInterstitialPresent{
    UIView *customAdView = [[UIView alloc]initWithFrame:self.customRect] ;
    customAdView.backgroundColor = [UIColor clearColor];
    [self.controller.view addSubview:customAdView];
    [self.interstitialV presentFromView:customAdView];
    self.customAdView = customAdView;
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial {
}
/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason{
    
    NSLog(@"%s 百度 全屏插屏 失败原因%d",__func__, reason);

    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterLoadAdFail:interstitial error:@(reason)];

}
/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial {
    //    NSLog(@"will show");
}
/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial{
    
    //    NSLog(@"%s",__func__);
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterAdDidShow:interstitial];
    
}


/**
 *  广告展示被用户点击时的回调
 */
- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial{
    
//    NSLog(@"%s",__func__);
    
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterAdClicked:interstitial];

}
/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial{
    if (self.BaiduInterstitialType.integerValue == 7 || self.BaiduInterstitialType.integerValue == 8) {
        [self.customAdView removeFromSuperview];
    }
//    NSLog(@"%s",__func__);
    
    [self.interstitialAdapterDelegate DKADSetInterstitialAdapterAdDidClose:interstitial];

}



- (void)dealloc{
    
    self.interstitialV.delegate = nil;
    self.interstitialV = nil;
    
}

@end
