//
//  DKADSetInterstitialManager.h
//  DKADSet
//
//  Created by liuzhiyi on 16/3/24.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

@class DKADSetInterstitialManager;

@protocol DKADSetInterstitialManagerDelegate <NSObject>

@optional

/**
 *  插屏广告加载成功
 */
- (void)DKADSetInterstitialManagerLoadAdSuccess:(DKADSetInterstitialManager *)interstitial;

/**
 *  插屏广告加载失败
 */
- (void)DKADSetInterstitialManagerLoadAdFail:(DKADSetInterstitialManager *)interstitial error:(id)error;

/**
 *  插屏广告已经展示
 */
- (void)DKADSetInterstitialManagerAdDidShow:(DKADSetInterstitialManager *)interstitial;

/**
 *  插屏广告已经关闭
 */
- (void)DKADSetInterstitialManagerAdDidClose:(DKADSetInterstitialManager *)interstitial;

/**
 *  插屏广告被点击
 */
- (void)DKADSetInterstitialManagerAdClicked:(DKADSetInterstitialManager *)interstitial;


@end

@interface DKADSetInterstitialManager : NSObject

/**
 *  插屏代理
 */
@property (nonatomic, weak)id<DKADSetInterstitialManagerDelegate> delegate;

/**
 *  添加广告的控制器
 */
@property (nonatomic, strong)UIViewController *controller;

/**
 【可选】若需要加载百度自定义插屏，请选择插屏种类
* 5 插屏广告：其他场景中使用 BaiduMobAdViewTypeInterstitialOther  【默认为全屏的插屏】
* 7 插屏广告：视频图片前贴片 BaiduMobAdViewTypeInterstitialBeforeVideo 有倒计时5s
* 8 插屏广告：视频暂停贴片 BaiduMobAdViewTypeInterstitialPauseVideo 没有倒计时
*/

@property (nonatomic, copy) NSString *BaiduInterstitialType;
/**
 【可选】若需要加载百度自定义frame插屏，设置此参数
 */
@property (nonatomic, assign)CGRect customRect;

/**
 *  插屏初始化方法
 *
 *  @param publishID 发布ID
 *  @param adSpaceID 广告位ID
 */
- (instancetype)initWithPublishID:( NSString * )publishID adSpaceID:(NSString *)adSpaceID;



// 加载并展示广告
- (void)loadAdAndShow;
@end
