//
//  DKADSetBaseAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/3/23.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol DKADSetBannerAdapterDelegate <NSObject>

@optional

/**
 *  横幅适配器加载成功
 */
- (void)DKADSetBannerAdapterLoadSuccess:(UIView *)adView;

/**
 *  横幅适配器加载失败
 */
- (void)DKADSetBannerAdapterLoadFailed:(UIView *)adView error:(id)error;

/**
 *  横幅适配器被点击
 */
- (void)DKADSetBannerAdapterClicked:(UIView *)adView;

/**
 *  横幅适配器已经展示
 */
- (void)DKADSetBannerAdapterDidShow:(UIView *)adView;


/**
 *  横幅适配器关闭
 */
- (void)DKADSetBannerAdapterDidClose:(UIView *)adView;

@end


@interface DKADSetBannerAdapter : NSObject

/**
 *  横幅适配器代理
 */
@property (nonatomic, weak)id<DKADSetBannerAdapterDelegate> bannerAdapterDelegate;

/**
 *  横幅广告的父视图
 */
@property (nonatomic, strong)UIView *superV;


@property (nonatomic, copy)NSString *pid;


@property (nonatomic, copy)NSString *sid;

/**
 *  广告参数配置
 */
- (void)configure;

/**
 *  加载广告
 */
- (void)loadBanner;

/**
 *  父视图
 *  详解：需设置为显示广告的UIViewController
 */
@property (nonatomic, weak) UIViewController *currentViewController;

@end
