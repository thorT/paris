//
//  DKADSetGDTNativeAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/4/23.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetGDTNativeAdapter.h"
#import "DKADSetNativeDataModel.h"
#import "DKADSetNativeView.h"

#import "GDTNativeAd.h"


@interface DKADSetGDTNativeAdapter()<GDTNativeAdDelegate>
{
    GDTNativeAd *_nativeAd;
}

@end

@implementation DKADSetGDTNativeAdapter


- (void)configure{
    
    [super configure];
    
    
}

- (void)load{
    [super load];
    
    _nativeAd =[[GDTNativeAd alloc] initWithAppkey:self.pid placementId:self.sid];
    _nativeAd.controller = self.currentVC;
    _nativeAd.delegate = self;
    
    //  广点通原生广告可以设置请求广告数量
    [_nativeAd loadAd:(int)self.adCount];
    
}

- (void)DKADSetNativeAdapterClickAdWithModel:(DKADSetNativeDataModel *)dataModel{
    
    [super DKADSetNativeAdapterClickAdWithModel:dataModel];
    
    /*点击发生，调用点击接口*/
    [_nativeAd clickAd:dataModel.originData];
    
    
}

- (void)DKADSetNativeAdapterShowAdWithView:(UIView *)view{
    

    [super DKADSetNativeAdapterShowAdWithView:view];
    if ([view isKindOfClass:[DKADSetNativeView class]]) {
        DKADSetNativeView *currentAd = (DKADSetNativeView *)view;
        GDTNativeAdData *currentAdData = currentAd.model.originData;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [_nativeAd attachAd:currentAdData toView:view];
            
        });
    }

}

#pragma mark --GDTNativeAdDelegate
/**
 *  原生广告加载广告数据成功回调，返回为GDTNativeAdData对象的数组
 */
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
    
    NSLog(@"%s 广点通信息流原生返回条数：%ld", __func__, nativeAdDataArray.count);
    
    NSMutableArray * array =[[NSMutableArray alloc] init];
    for (GDTNativeAdData *gdtData in nativeAdDataArray) {
        NSDictionary *gdt_dic = gdtData.properties;
        
        DKADSetNativeDataModel *nativeDataModel = [[DKADSetNativeDataModel alloc] init];
        nativeDataModel.nativeTitle = [gdt_dic objectForKey:GDTNativeAdDataKeyTitle];
        nativeDataModel.nativeDesc = [gdt_dic objectForKey:GDTNativeAdDataKeyDesc];
        nativeDataModel.nativeIconURLStr = [gdt_dic objectForKey:GDTNativeAdDataKeyIconUrl];
        nativeDataModel.nativeMainImgURLStr = [gdt_dic objectForKey:GDTNativeAdDataKeyImgUrl];
        nativeDataModel.originData = gdtData;
        [array addObject:nativeDataModel];

    }
    
    if (array.count == 0) {
        [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:@"适配出错，数组为空"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.nativeAdapterDelegate DKADSetNativeAdapterRequestSuccessWithDataArray:array];
        });
    }
}

/**
 *  原生广告加载广告数据失败回调
 */
- (void)nativeAdFailToLoad:(NSError *)error{
    NSLog(@"%s gdt 信息流原生 失败原因%@",__func__, error);

    _nativeAd.controller = nil;
    _nativeAd.delegate = nil;
    _nativeAd = nil;
    [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:error];

}


/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen{
    
}

/**
 *  原生广告点击之后应用进入后台时回调
 */
- (void)nativeAdApplicationWillEnterBackground{
    
}

/**
 * 原生广告点击以后，内置AppStore或是内置浏览器被关闭时回调
 */
- (void)nativeAdClosed{
    
}

- (void)dealloc
{

    
//    NSLog(@"%s", __func__);
    _nativeAd.delegate = nil;
    _nativeAd = nil;
    
    
}


@end
