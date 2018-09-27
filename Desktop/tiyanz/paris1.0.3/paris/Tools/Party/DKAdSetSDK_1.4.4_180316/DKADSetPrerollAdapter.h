//
//  DKADSetPrerollAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 17/4/12.
//  Copyright © 2017年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DKADSetPrerollAdapterDelegate <NSObject>
@optional
/**
 *  广告准备播放
 */
- (void)DKADSetPrerollAdapterDidAdReady:(id)preroll;

/**
 *  广告展示失败
 */
- (void)DKADSetPrerollAdapterDidAdFailed:(id)preroll withError:(id) reason;

/**
 *  广告展示成功
 */
- (void)DKADSetPrerollAdapterDidAdStart:(id)preroll;

/**
 *  广告展示结束
 */
- (void)DKADSetPrerollAdapterDidAdFinish:(id)preroll;

/**
 *  广告点击
 */
- (void)DKADSetPrerollAdapterDidAdClicked:(id)preroll;

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)DKADSetPrerollAdapterDidDismissLandingPage;
@end

@interface DKADSetPrerollAdapter : NSObject
/**
 *  适配器代理
 */
@property (nonatomic, weak)id<DKADSetPrerollAdapterDelegate> prerollAdapterDelegate;


@property (nonatomic, copy)NSString *pid;

@property (nonatomic, copy)NSString *sid;

/**
 *  加载百度广告设置前贴baseview
 */
@property(nonatomic, strong) UIView *renderBaseView;

/**
 *  广告参数配置
 */
- (void)configure;

/**
 *  加载广告
 */
- (void)load;

@end
