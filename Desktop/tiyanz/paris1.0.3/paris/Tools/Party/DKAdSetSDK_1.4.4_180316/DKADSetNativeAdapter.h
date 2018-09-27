//
//  DKADSetNativeAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/23.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DKADSetNativeManager.h"
@class DKADSetNativeDataModel;
@protocol DKADSetNativeAdapterDelegate <NSObject>

@optional

/**
 适用于 像百度信息流 原生代码控制元素（video和normal） 的适配器。
 通过这个代理，通知manager进而通知 开发者实现manager的代理方法
 - (void)DkAdSetNativeManagerPrepareForViewWithBlock:model:并调用blk传入UI元素
 进行UI的控制，适配器之后的逻辑将在 blk内部。
 */
- (void)DkAdSetNativeAdapterPrepareViewWithModel:(DKADSetNativeDataModel *)model;

// 出错委托通用
- (void)DKADSetNativeAdapterRequestAdFail:(id)error;

// 适用于提供视图拼接的产品
- (void)DKADSetNativeAdapterRequestSuccessWithViewList:(NSArray *)nativeViewList;

// 适用于提供视图拼接的产品，内部先知道点击，对点击做了处理
- (void)DKADSetNativeAdapterClicked;

// 适用于只提供数据模型回调的产品
- (void)DKADSetNativeAdapterRequestSuccessWithDataArray:(NSArray *)dataArray;


@end


@class DKADSetNativeDataModel;


@interface DKADSetNativeAdapter : NSObject

/**
 *  适配器代理
 */
@property (nonatomic, weak)id<DKADSetNativeAdapterDelegate> nativeAdapterDelegate;


@property (nonatomic, copy)NSString *pid;


@property (nonatomic, copy)NSString *sid;

@property (nonatomic, copy) NSString *pickedPlatformAid;

@property (nonatomic, copy) NSString *pickedRandom;

@property (nonatomic, weak)UIViewController *currentVC;


@property (nonatomic, assign)CGRect nativeFrame;
@property (nonatomic, assign)NSUInteger adCount;

@property (nonatomic, copy) NativeBlk blk;
@property (nonatomic, assign)BOOL showMorePic;

/**
 *  广告参数配置
 */
- (void)configure;

/**
 *  加载广告
 */
- (void)load;



//展示广告
-(void)DKADSetNativeAdapterShowAdWithView:(UIView *)view;

//点击广告
-(void)DKADSetNativeAdapterClickAdWithModel:(DKADSetNativeDataModel *)dataModel;
@end
