//
//  DKADSetSplashManager.h
//  DKADSet
//
//  Created by liuzhiyi on 16/3/31.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKADSetSplashManager;

@protocol DKADSetSplashManagerDelegate <NSObject>

@optional

/**
 *  广告展示成功
 */
- (void)DKADSetSplashManagerSuccessPresentScreen:(DKADSetSplashManager *)splash;

/**
 *  广告展示失败
 */
- (void)DKADSetSplashManagerFailPresentScreen:(DKADSetSplashManager *)splash withError:(id) error;

/**
 *  广告被点击
 */
- (void)DKADSetSplashManagerDidClicked:(DKADSetSplashManager *)splash;

/**
 *  广告展示结束
 */
- (void)DKADSetSplashManagerDidDismissScreen:(DKADSetSplashManager *)splash;

@end


@interface DKADSetSplashManager : NSObject

/**
 *  开屏广告代理
 */
@property (nonatomic, weak)id<DKADSetSplashManagerDelegate> delegate;



/**
【可选】若需要加载半屏开屏，请传入底部视图
 百度要求半屏ad尺寸必须大于200*200；广点通要求半屏ad高度必须大于360；
 */
@property (nonatomic, strong)UIView *bottomView;

/**
 *  开屏广告初始化方法
 *
 *  @param publishID 发布ID
 *  @param adSpaceID 广告位ID
 *
 */
- (instancetype)initWithPublishID:( NSString * )publishID adSpaceID:(NSString *)adSpaceID;


// 加载并展示广告
- (void)loadAdAndShow;


@end
