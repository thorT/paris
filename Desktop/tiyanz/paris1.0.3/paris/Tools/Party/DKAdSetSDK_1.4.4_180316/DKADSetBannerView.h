//
//  DKADSetBannerView.h
//  DKADSet
//
//  Created by liuzhiyi on 16/3/24.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKADSetBannerView;

@protocol DKADSetBannerViewDelegate <NSObject>


@optional

/**
 *  横幅广告视图加载成功
 */
- (void)DKADSetBannerLoadSuccess:(DKADSetBannerView *)adView;

/**
 *  横幅广告视图加载失败
 */
- (void)DKADSetBannerLoadFailed:(DKADSetBannerView *)adView error:(id)error;

/**
 *  横幅广告视图被点击
 */
- (void)DKADSetBannerClicked:(DKADSetBannerView *)adView;

/**
 *  横幅广告视图已经展示
 */
- (void)DKADSetBannerDidShow:(DKADSetBannerView *)adView;

@end

@interface DKADSetBannerView : UIView
/**
 *  SDK版本
 */
@property(nonatomic, readonly) NSString *sdkVersion;

/**
 添加广告的控制器
 */
@property (nonatomic, weak)UIViewController *controller;



/**
 *  横幅代理
 */
@property (nonatomic, weak)id<DKADSetBannerViewDelegate> delegate;

/**
 *  横幅初始化方法
 *
 *  @param publishID 发布ID
 *  @param adSpaceID 广告位ID
 *  @param frame     横幅frame，广告尺寸和展示必须符合规范，被判作弊将无收益
 *  聚合SDK横幅广告的尺寸比例是 w:h = 6.4 : 1。
 横幅广告是会自动轮换的，一个横幅广告展示完毕，不用再创建新的横幅实例，也不用手动调用loadAdAndShow方法。同一个管理者的loadAdAndShow多次重复调用可能会导致数据错乱。
 */
- (instancetype)initWithPublishID:( NSString * )publishID adSpaceID:(NSString *)adSpaceID frame:(CGRect)frame;




/**
 加载并展示广告
 */
- (void)loadAdAndShow;

@end
