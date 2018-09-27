//
//  DKADSetBaiduPrerollAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 17/4/12.
//  Copyright © 2017年 liuzhiyi. All rights reserved.
//

#import "DKADSetBaiduPrerollAdapter.h"
#import "BaiduMobAdSDK/BaiduMobAdPrerollDelegate.h"
#import "BaiduMobAdSDK/BaiduMobAdPreroll.h"

@interface DKADSetBaiduPrerollAdapter ()<BaiduMobAdPrerollDelegate>
@property (nonatomic, strong) BaiduMobAdPreroll *prerollAd;

@end

@implementation DKADSetBaiduPrerollAdapter


- (void)load{
    [super load];
    
    self.prerollAd = [[BaiduMobAdPreroll alloc]init];
    
    self.prerollAd.publisherId = self.pid;
    self.prerollAd.adId = self.sid;
    
    self.prerollAd.renderBaseView = self.renderBaseView;
    self.prerollAd.delegate = self;
    // 是否有倒计时和点击描述按钮
    self.prerollAd.supportActImage = YES;
    self.prerollAd.supportTimeLabel = YES;
    
    [self.prerollAd request];
    
}

-(void)dealloc{
    self.prerollAd.delegate = nil;
    self.prerollAd = nil;
    
}

#pragma mark -  BaiduMobAdPrerollDelegate


//-(BOOL) enableLocation {
//    return YES;
//}

- (void)didAdReady:(BaiduMobAdPreroll *)preroll {
    [self.prerollAdapterDelegate DKADSetPrerollAdapterDidAdReady:preroll];
}

- (void)didAdFailed:(BaiduMobAdPreroll *)preroll withError:(BaiduMobFailReason) reason{
    NSLog(@"%s 百度 视频贴片 失败原因%d",__func__, reason);

    [self.prerollAdapterDelegate DKADSetPrerollAdapterDidAdFailed:preroll withError:@(reason)];
    
}

- (void)didAdStart:(BaiduMobAdPreroll *)preroll {
    [self.prerollAdapterDelegate DKADSetPrerollAdapterDidAdStart:preroll];
}

- (void)didAdFinish:(BaiduMobAdPreroll *)preroll {
    [self.prerollAdapterDelegate DKADSetPrerollAdapterDidAdFinish:preroll];
    
}

- (void)didAdClicked:(BaiduMobAdPreroll *)preroll {
    [self.prerollAdapterDelegate DKADSetPrerollAdapterDidAdClicked:preroll];
    
}

- (void)didDismissLandingPage {
    [self.prerollAdapterDelegate DKADSetPrerollAdapterDidDismissLandingPage];
    
}

@end
