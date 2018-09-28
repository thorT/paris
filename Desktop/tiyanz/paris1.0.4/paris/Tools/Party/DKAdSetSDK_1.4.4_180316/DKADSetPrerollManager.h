//
//  DKADSetPrerollManager.h
//  DKADSet
//
//  Created by liuzhiyi on 17/4/12.
//  Copyright © 2017年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DKADSetPrerollManager;


@protocol DKADSetPrerollManagerDelegate <NSObject>

@optional

/**
 *  广告准备播放
 */
- (void)DKADSetPrerollManagerDidAdReady:(DKADSetPrerollManager *)preroll;

/**
 *  广告展示失败
 */
- (void)DKADSetPrerollManagerDidAdFailed:(DKADSetPrerollManager *)preroll withError:(id) reason;

/**
 *  广告展示成功
 */
- (void)DKADSetPrerollManagerDidAdStart:(DKADSetPrerollManager *)preroll;

/**
 *  广告展示结束
 */
- (void)DKADSetPrerollManagerDidAdFinish:(DKADSetPrerollManager *)preroll;

/**
 *  广告点击
 */
- (void)DKADSetPrerollManagerDidAdClicked:(DKADSetPrerollManager *)preroll;

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)DKADSetPrerollManagerDidDismissLandingPage;
@end

@interface DKADSetPrerollManager : NSObject
/**
 *  加载百度广告设置前贴baseview
 */
@property(nonatomic, strong) UIView *renderBaseView;


/**
 *  视频贴片代理
 */
@property (nonatomic, weak)id<DKADSetPrerollManagerDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param publishID 发布ID
 *  @param adSpaceID 广告位ID
 */
- (instancetype)initWithPublishID:( NSString * )publishID adSpaceID:(NSString *)adSpaceID;



// 加载并展示广告
- (void)loadAdAndShow;

@end
