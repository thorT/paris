//
//  DKADSetNativeManager.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/23.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DKADSetNativeDataModel.h"

typedef void (^NativeBlk)(UILabel *brandLb, UILabel *titleLb, UILabel *textLb, UIImageView *iconIv, UIImageView *mainIv, UIImageView *platformIv, UIImageView *adIv, NSArray *morePics);


@class DKADSetNativeManager;

@protocol DKADSetNativeManagerDelegate <NSObject>

@optional
/** 原生代码实现UI的信息流，控制信息样式的回调，必须实现
 模板信息流不必实现。
 
 
 1、各控件都是添加到信息流容器试图中的，frame请以 nativeManager初始化时的nativeFrame为参照

 2、UILabel、UIImageView的样式之类可自由定制
 3、model存在的，开发者自己对label的text、ImageView的image进行控制；
 model不存在的，由其SDK本身进行赋值
 
 @param blk 开发者通过这个block控制想显示的广告样式
 @param model 当这个参数有值时，开发者自己对UILabel实例的text和UIImageView的image属性进行赋值；没有值时，sdk自己处理赋值
 */
- (void)DkAdSetNativeManagerPrepareForViewWithManager:(DKADSetNativeManager *)manager block:(NativeBlk)blk model:(DKADSetNativeDataModel *)model;
/**
 *  请求失败将回调此方法
 */
- (void)DKADSetNativeManagerRequestAdFailWithManager:(DKADSetNativeManager *)manager error:(id)error;

/**
 *  请求成功的回调
 *
 *  @param nativeViewList 封装好的视图数组
 */
- (void)DKADSetNativeManagerRequestSuccessWithManager:(DKADSetNativeManager *)manager viewList:(NSArray *)nativeViewList;

/**
 *  被点击时，将回调此方法
 */
- (void)DKADSetNativeManagerAdClickedWithManager:(DKADSetNativeManager *)manager;

@end



@interface DKADSetNativeManager : NSObject


/**
 信息流管理者代理
 */
@property (nonatomic, weak)id<DKADSetNativeManagerDelegate> delegate;

/**
 *  Ad所在的控制器
 */
@property (nonatomic, weak)UIViewController *controller;


/**
 用于当广告位配置的是多图信息流，但是广告数据有小概率不返回多图数据的情况，若需要过滤数据，只显示有多图信息的数据。
 此情况下，请设置此标志为YES。
 */
@property (nonatomic, assign)BOOL showMorePic;

/**
 *  初始化
 *
 *  @param publishID   发布ID
 *  @param adSpaceID   广告位ID
 *  @param nativeFrame 信息流视图的frame
 *
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

// 展示广告
- (void)DKADSetNativeShowAdWithView:(UIView *)view;


@end
