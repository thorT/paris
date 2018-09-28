//
//  DKADSetGDTSplashAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/4/20.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetGDTSplashAdapter.h"

@implementation DKADSetGDTSplashAdapter

- (void)load{
    
    [super load];
    
    [self commonInit];
    
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];

    //拉取并展示
    [self.splash loadAdAndShowInWindow:fK];
}


- (void)loadHalfSplash:(UIView *)bottomView{
    [super loadHalfSplash:bottomView];
    
    [self commonInit];
    
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, [[UIScreen mainScreen] bounds].size.width - 100, 200)];
//    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashBottomLogo"]];
//    [_bottomView addSubview:logo];
//    logo.center = _bottomView.center;
//    _bottomView.backgroundColor = [UIColor whiteColor];
     UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [self.splash loadAdAndShowInWindow:fK withBottomView:bottomView];
}


- (void)commonInit{
    
    self.splash = [[GDTSplashAd alloc] initWithAppkey:self.pid placementId:self.sid];
    
    self.splash.delegate = self;
    //拉取广告等待时间会展示该默认图片。
    self.splash.backgroundColor = [UIColor colorWithPatternImage:[self launchImg]];
    
    //设置开屏拉取时长限制，若超时则不再展示广告
    self.splash.fetchDelay = 3;
}

#pragma mark - GDT SplashAd  Delegate

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    [self.splashAdapterDelegate DKADSetSplashAdapterSuccessPresentScreen:splashAd];
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s gdt 开屏 失败原因%@",__func__, error);

    [self.splashAdapterDelegate DKADSetSplashAdapterFailPresentScreen:splashAd withError:error];
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
    }
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    [self.splashAdapterDelegate DKADSetSplashAdapterDidClicked:splashAd];
}


-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    [self.splashAdapterDelegate DKADSetSplashAdapterDidDismissScreen:splashAd];
    
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
    [self.splashAdapterDelegate DKADSetSplashAdapterDidDismissScreen:splashAd];
    
}


- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    [self.splashAdapterDelegate DKADSetSplashAdapterDidDismissScreen:splashAd];
    
}
- (void)cleanSplash{
    
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
    }

}

- (void)dealloc
{
    
    [self cleanSplash];
    
}

- (UIImage *)launchImg{
    
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
        
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, [UIApplication sharedApplication].keyWindow.bounds.size) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
        
    }
    UIImage *img = [UIImage imageNamed:launchImageName];
    return img;
}

@end
