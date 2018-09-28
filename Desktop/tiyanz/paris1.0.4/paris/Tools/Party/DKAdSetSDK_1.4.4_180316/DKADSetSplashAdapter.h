//
//  DKADSetSplashAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/3/31.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@protocol DKADSetSplashAdapterDelegate <NSObject>

@optional
/**
 *  广告展示成功
 */
- (void)DKADSetSplashAdapterSuccessPresentScreen:(id)splash;

/**
 *  广告展示失败
 */
- (void)DKADSetSplashAdapterFailPresentScreen:(id)splash withError:(id) error;

/**
 *  广告被点击
 */
- (void)DKADSetSplashAdapterDidClicked:(id)splash;

/**
 *  广告展示结束
 */
- (void)DKADSetSplashAdapterDidDismissScreen:(id)splash;

@end

@interface DKADSetSplashAdapter : NSObject

/**
 *  开屏适配器代理
 */
@property (nonatomic, weak)id<DKADSetSplashAdapterDelegate> splashAdapterDelegate;


@property (nonatomic, copy)NSString *pid;

@property (nonatomic, copy)NSString *sid;

/**
 *  广告参数配置
 */
- (void)configure;

/**
 *  全屏开屏加载广告
 */
- (void)load;


/**
 半屏开屏加载广告

 @param bottomView 自定义的view
 */
- (void)loadHalfSplash:(UIView *)bottomView;

@end
