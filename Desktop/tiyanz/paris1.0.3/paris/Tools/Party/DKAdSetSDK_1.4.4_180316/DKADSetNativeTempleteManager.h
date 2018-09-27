//
//  DKADSetNativeTempleteManager.h
//  DKADSet
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKADSetNativeTempleteManager;

@protocol DKADSetNativeTempleteManagerDelegate <NSObject>
@optional
/**
 *  请求失败将回调此方法
 */
- (void)DKADSetNativeTempleteManagerRequestAdFailWithManager:(DKADSetNativeTempleteManager *)manager error:(id)error;

/**
 *  请求成功的回调
 *
 *  @param nativeViewList 封装好的视图数组
 */
- (void)DKADSetNativeTempleteManagerRequestSuccessWithManager:(DKADSetNativeTempleteManager *)manager viewList:(NSArray *)nativeViewList;

/**
 *  被点击时，将回调此方法
 */
- (void)DKADSetNativeTempleteManagerAdClickedWithManager:(DKADSetNativeTempleteManager *)manager;

@end

@interface DKADSetNativeTempleteManager : NSObject

/**
 代理
 */
@property (nonatomic, weak)id<DKADSetNativeTempleteManagerDelegate> nativeTempleteManagerDelegate;
/**
 *  AD所在的控制器
 */
@property (nonatomic, weak)UIViewController *controller;

/**
 *  初始化
 *
 *  @param publishID   发布ID
 *  @param adSpaceID   广告位ID
 *  @param nativeFrame 一个模板信息流视图的frame
 */
- (instancetype)initWithPublishID:(NSString * )publishID
                        adSpaceID:(NSString *)adSpaceID
                      nativeFrame:(CGRect)nativeFrame;
/**
 *  加载广告（百度请求广告回来的数量会小于某个上限（请联系接入人员），广点通返回数量可通过此接口设置）
 *  在开发者需要聚合多个广告平台时，如果广告平台支持自定义请求广告数量，那么聚合内部使用开发者传入的数据；如果广告平台不支持，联系商务对应设置。
 *  @param adCount 数量
 */
- (void)loadNativeWithAdCount:(NSInteger)adCount;

// 展示广告需要开发者主动调用
- (void)DKADSetNativeShowAdWithView:(UIView *)view;

@end
