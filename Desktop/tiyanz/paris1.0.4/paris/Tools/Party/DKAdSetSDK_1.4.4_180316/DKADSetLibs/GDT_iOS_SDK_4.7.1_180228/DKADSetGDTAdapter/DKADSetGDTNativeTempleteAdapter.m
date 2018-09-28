//
//  DKADSetGDTNativeTempleteAdapter.m
//  DKADSet
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 liuzhiyi. All rights reserved.
//

#import "DKADSetGDTNativeTempleteAdapter.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

@interface DKADSetGDTNativeTempleteAdapter()<GDTNativeExpressAdDelegete>
// 用于请求原生模板广告，注意：不要在广告打开期间释放！
@property (nonatomic, retain)   GDTNativeExpressAd *nativeExpressAd;

// 存储返回的GDTNativeExpressAdView
@property (nonatomic, retain)       NSArray *expressAdViews;

@end

@implementation DKADSetGDTNativeTempleteAdapter

- (void)configure{
    [super configure];
}
- (void)load{
    [super load];
    
    NSString *sid = self.sid;
    NSString *pid = self.pid;

//    // 用于返回GDT demo中的信息流 模板广告请求
//    sid = @"1105344611";
//    pid = @"9090529359814184";
    
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppkey:pid placementId:sid adSize:self.nativeFrame.size];
    NSLog(@"3:2 is %@, nativeFrameSize is %@", NSStringFromCGSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 1.5)), NSStringFromCGSize(self.nativeFrame.size));

    self.nativeExpressAd.delegate = self;
    
    // 拉取5条广告
    [self.nativeExpressAd loadAd:5];

}

/**
 * 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    NSLog(@"%s 广点通信息流 模板返回条数：%ld", __func__, views.count);

    [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDTNativeExpressAdView *adView = (GDTNativeExpressAdView *)obj;
        [adView removeFromSuperview];
    }];
    
    self.expressAdViews = [NSArray arrayWithArray:views];
#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunused-variable"
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    //vc = [self navigationController];
//#pragma clang diagnostic pop
    
//    if (self.expressAdViews.count) {
//        
//        // 取一个GDTNativeExpressAdView
//        GDTNativeExpressAdView *expressView =  [self.expressAdViews objectAtIndex:0];
//        // 设置frame，开发者自己设置
//        
//        expressView.frame = CGRectMake(0, 0, self.nativeFrame.size.width, self.nativeFrame.size.height);
//        
//        expressView.controller = rootViewController;
//        
//        [expressView render];
//
//        
//    }
    
    NSMutableArray *array = [@[] mutableCopy];
    for (GDTNativeExpressAdView *exView in self.expressAdViews) {
        // 取一个GDTNativeExpressAdView

        exView.controller = self.currentVC;
        // 设置frame，开发者自己设置

        exView.frame = self.nativeFrame;
        [exView render];
        [array addObject:exView];
    }
    
    if (array.count == 0) {
        [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:@"适配出错，数组为空"];
    }else{
        [self.nativeAdapterDelegate DKADSetNativeAdapterRequestSuccessWithViewList:array];
    }
    
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error {
    NSLog(@"%s gdt 信息流模板 失败原因%@",__func__, error);

    
    nativeExpressAd.delegate = nil;
    nativeExpressAd = nil;
    [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:error];
}

- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:@"render fail"];

}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.nativeAdapterDelegate DKADSetNativeAdapterClicked];

}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"--------%s-------",__FUNCTION__);
    //    if ([nativeExpressAdView superview]) {
    //        [nativeExpressAdView removeFromSuperview];
    //    }
}

@end
