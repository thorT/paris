//
//  DKADSetBaiduSplashAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/4/1.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetBaiduSplashAdapter.h"
#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"


@interface DKADSetBaiduSplashAdapter()<BaiduMobAdSplashDelegate>
@property (nonatomic, strong)BaiduMobAdSplash *baiduSplash;
@property (nonatomic, retain) UIView *customSplashView;
@end

@implementation DKADSetBaiduSplashAdapter




- (void)load{
    
    [super load];
    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
    self.baiduSplash = [[BaiduMobAdSplash alloc] init];
    self.baiduSplash.delegate = self;
    self.baiduSplash.AdUnitTag = self.sid;
    self.baiduSplash.canSplashClick = YES;
    [self.baiduSplash loadAndDisplayUsingKeyWindow:[[[UIApplication sharedApplication] delegate] window]];

}

- (void)loadHalfSplash:(UIView *)bottomView{
    [super loadHalfSplash:bottomView];
    
    
    self.baiduSplash = [[BaiduMobAdSplash alloc] init];
    self.baiduSplash.delegate = self;
    self.baiduSplash.AdUnitTag = self.sid;
    self.baiduSplash.canSplashClick = YES;
    
    
    
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.customSplashView];
//
    CGFloat screenWidth = [UIApplication sharedApplication].keyWindow.frame.size.width;
    CGFloat screenHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
//
//    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - bottomView.frame.size.height)];
    [self.customSplashView addSubview:baiduSplashContainer];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight - 40, screenWidth, 20)];
//    label.text = @"上方为开屏广告位";
//    label.textAlignment = NSTextAlignmentCenter;
    [self.customSplashView addSubview:bottomView];
    //
    //在的baiduSplashContainer里展现百度广告
    [self.baiduSplash loadAndDisplayUsingContainerView:baiduSplashContainer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeSplash];
    });
}

/**
 *  应用的APPID
 */
- (NSString *)publisherId{
    
//    NSLog(@"%s",__func__);
    
    return self.pid;
}



/**
 *  广告成功展示
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    
    [self.splashAdapterDelegate DKADSetSplashAdapterSuccessPresentScreen:splash];
}

/**
 *   广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason{
    NSLog(@"%s 百度开屏 失败原因%d",__func__, reason);

    [self.splashAdapterDelegate DKADSetSplashAdapterFailPresentScreen:splash withError:@(reason)];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self removeSplash];
    });
}

/**
 *  广告被点击
 */
- (void)splashDidClicked:(BaiduMobAdSplash *)splash{
    
    [self.splashAdapterDelegate DKADSetSplashAdapterDidClicked:splash];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash{
    
    [self.splashAdapterDelegate DKADSetSplashAdapterDidDismissScreen:splash];
}

/**
 *  广告详情页消失
 */
- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash{
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self removeSplash];
    });
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash {
    if (self.baiduSplash) {
        self.baiduSplash.delegate = nil;
        self.baiduSplash = nil;
        [self.customSplashView removeFromSuperview];
    }
}
- (void)dealloc
{
    [self removeSplash];
    
}

@end
