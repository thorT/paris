//
//  DKADSetInterstitialAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/3/24.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DKADSetInterstitialAdapterDelegate <NSObject>
@optional

/**
 *  插屏适配器加载成功
 */
- (void)DKADSetInterstitialAdapterLoadAdSuccess:(id)interstitial;

/**
 *  插屏适配器加载失败
 */
- (void)DKADSetInterstitialAdapterLoadAdFail:(id)interstitial error:(id)error;

/**
 *  插屏适配器已经展示
 */
- (void)DKADSetInterstitialAdapterAdDidShow:(id)interstitial;

/**
 *  插屏适配器已经关闭
 */
- (void)DKADSetInterstitialAdapterAdDidClose:(id)interstitial;

/**
 *  插屏适配器被点击
 */
- (void)DKADSetInterstitialAdapterAdClicked:(id)interstitial;

@end

@interface DKADSetInterstitialAdapter : NSObject

/**
 *  插屏适配器代理
 */
@property (nonatomic, weak)id<DKADSetInterstitialAdapterDelegate> interstitialAdapterDelegate;


@property (nonatomic, copy)NSString *pid;
@property (nonatomic, strong)UIViewController *controller;

@property (nonatomic, copy)NSString *sid;
/**
 【可选】若需要加载百度自定义插屏，请选择插屏种类
 * 5 插屏广告：其他场景中使用 BaiduMobAdViewTypeInterstitialOther 【默认为全屏的插屏】
 * 7 插屏广告：视频图片前贴片 BaiduMobAdViewTypeInterstitialBeforeVideo 有倒计时5s
 * 8 插屏广告：视频暂停贴片 BaiduMobAdViewTypeInterstitialPauseVideo 没有倒计时
 */
@property (nonatomic, copy) NSString *BaiduInterstitialType;

/**
 【可选】若需要加载百度自定义frame插屏，设置此参数
 */
@property (nonatomic, assign)CGRect customRect;
/**
 *  广告参数配置
 */
- (void)configure;

/**
 *  加载广告
 */
- (void)load;



@end
