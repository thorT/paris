//
//  DKADSetBaiduNativeAdapter.m
//  DKADSet
//
//  Created by liuzhiyi on 16/4/23.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetBaiduNativeAdapter.h"

#import "DKADSetNativeDataModel.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "DKADSetNativeManager.h"

#import "UIImageView+WebCache.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DKADSetBaiduNativeAdapter()

@property (nonatomic, strong)NSMutableArray *viewListArray;

@end

@implementation DKADSetBaiduNativeAdapter

- (void)configure{
    
    [super configure];
    
}

- (void)load{
    
    [super load];
    self.viewListArray  = [NSMutableArray array];
    if (!self.native) {
        self.native = [[BaiduMobAdNative alloc]init];
        self.native.delegate = self;
    }
    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
    
    //请求原生广告
    [self.native requestNativeAds];
}

#pragma mark - baidu mobAd native Delegate

/**
 *  应用的APPID
 */
-(NSString*)publisherId
{
    return self.pid;
}

/**
 * 广告位id
 */
-(NSString*)apId
{
    return self.sid;
}
/**
 * 模版高度，仅用于信息流模版广告
 */
-(NSNumber*)baiduMobAdsHeight{
    return @(self.nativeFrame.size.height);
}

/**
 * 模版宽度，仅用于信息流模版广告
 */
-(NSNumber*)baiduMobAdsWidth{
    return @(self.nativeFrame.size.width);
    
}

/**
 blk被执行后，BaiduMobAdNativeAdView有值后的后续处理
 
 @param count 只有当所有blk都执行 view都封装完毕，才回调
 */
- (void)handle:(BaiduMobAdNativeAdView *)nativeAdView object:(BaiduMobAdNativeAdObject *)object objectsCount:(NSInteger)count{
    
    nativeAdView.backgroundColor = [UIColor whiteColor];
    
    //根据广告object加载和显示广告内容
    [nativeAdView loadAndDisplayNativeAdWithObject:object
                                        completion:^(NSArray *errors) {
                                            if (errors) {
                                                NSLog(@" %s 百度loadAndDisplayNativeAdWithObject,error:%@", __func__, errors);
                                            }
                                            //                                        if (!errors) {
                                            //                                            [self.mainArray addObject:view];
                                            //                                            // 确定视图显示在window上之后再调用trackImpression，不要太早调用
                                            //                                            //在tableview或scrollview中使用时尤其要注意
                                            //                                            //本demo中在tableViewCell展现时调用了trackImpression
                                            //                                            [self.mainTableView reloadData];
                                            //                                        }
                                        }];
    
    if (nativeAdView) {
        
        [self.viewListArray addObject:nativeAdView];
    }else{
        NSLog(@"返回数据 不是BaiduMobAdNativeAdObject， 后台id绑定错误");
    }
    
    if (self.viewListArray.count == count) {
        [self.nativeAdapterDelegate DKADSetNativeAdapterRequestSuccessWithViewList:self.viewListArray];
    }
}
/**
 * 广告请求成功
 请求成功的BaiduMobAdNativeAdObject数组，如果只成功返回一条原生广告，数组大小为1
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds{
    NSLog(@"%s 百度信息流 返回总条数：%ld", __func__, nativeAds.count);
    /* lzy171108注:原生多图处理
     请通知我们的商务把这个广告位的返回数据条数调大。代码中还需要对返回数据做处理。
     法2：若多图信息返回没有多图数据，整条广告都不要了，那么请在初始化信息流时，给DKADSetNativeManager实例的self.showMorePic属性赋值为YES。并打开下面的注释：
     */

    if (self.showMorePic) {
        NSMutableArray *morePicsNativeAdsArr = [NSMutableArray array];
        for (BaiduMobAdNativeAdObject *object in nativeAds) {
            if (object.materialType == NORMAL) {
                if([object.morepics count] == 0 ){
                    continue;
                }else{
                    [morePicsNativeAdsArr addObject:object];
                }
            }

        }

        nativeAds = morePicsNativeAdsArr;
        NSLog(@"%s 百度信息流 多图信息流条数：%ld", __func__, nativeAds.count);
        if (!morePicsNativeAdsArr && [self.nativeAdapterDelegate respondsToSelector:@selector(DKADSetNativeAdapterRequestAdFail:)]) {
            [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:[NSString stringWithFormat:@"百度信息流 多图信息流数据为空"]];
            return;
        }
    }

    for (BaiduMobAdNativeAdObject *object in nativeAds) {
        
        //取到每一条广告object
        //展现前检查是否过期,30分钟广告过期,请放弃展示并重新请求
        if ([object isExpired]) {
            continue;
        }
        
        //创建每一条的广告view
        __block  BaiduMobAdNativeAdView *nativeAdView;
        __weak __typeof(self) weakSelf = self;
        CGRect frame = self.nativeFrame;
        
        if (object.materialType == VIDEO) {
            
            // 创建一个blk，赋值给adapter，
            self.blk = ^(UILabel *brandLb, UILabel *titleLb, UILabel *textLb, UIImageView *iconIv, UIImageView *mainIv, UIImageView *platformIv, UIImageView *adIv, NSArray *morePics) {
                
                // blk的大括号，只有在这个blk被调用的时候，会执行
                BaiduMobAdNativeVideoView *videoView = [[BaiduMobAdNativeVideoView alloc]initWithFrame:CGRectMake(0, 80, frame.size.width, frame.size.height * 0.5) andObject:object];
                
                mainIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(iconIv.frame), frame.size.width - 20, CGRectGetHeight(videoView.frame))];
                
                videoView.isAutoPlay = NO;
                //在大图上添加播放按钮引导用户点击视频
                UIImage *image = [weakSelf imageResoureForName:@"play_big_image"];
                UIImageView *playImage = [[UIImageView alloc ]initWithImage:image];
                playImage.alpha = 0.85;
                playImage.frame = CGRectMake(CGRectGetMaxX(iconIv.frame) + 16, CGRectGetMaxY(iconIv.frame) - 16, 120, 120);
                [mainIv addSubview:playImage];
                
                
                nativeAdView = [[BaiduMobAdNativeAdView alloc] initWithFrame:frame
                                                                   brandName:brandLb
                                                                       title:titleLb
                                                                        text:textLb
                                                                        icon:iconIv
                                                                   mainImage:mainIv
                                                                   videoView:videoView
                                ];
                nativeAdView.baiduLogoImageView = platformIv;
                [nativeAdView addSubview:platformIv];
                nativeAdView.adLogoImageView = adIv;
                [nativeAdView addSubview:adIv];
                
                [weakSelf handle:nativeAdView object:object objectsCount:nativeAds.count];
            };
            
            if ([self.nativeAdapterDelegate respondsToSelector:@selector(DkAdSetNativeAdapterPrepareViewWithModel:)]) {
                [self.nativeAdapterDelegate DkAdSetNativeAdapterPrepareViewWithModel:nil];
            }
            
            
        } else if (object.materialType == NORMAL) {
            
            
            self.blk = ^(UILabel *brandLb, UILabel *titleLb, UILabel *textLb, UIImageView *iconIv, UIImageView *mainIv, UIImageView *platformIv, UIImageView *adIv, NSArray *morePics) {
                                NSLog(@"%s 百度信息流 执行了blk", __func__);
                
                nativeAdView = [[BaiduMobAdNativeAdView alloc]initWithFrame:frame
                                                                  brandName:brandLb
                                                                      title:titleLb
                                                                       text:textLb
                                                                       icon:iconIv
                                                                  mainImage:mainIv];
                
                nativeAdView.baiduLogoImageView = platformIv;
                [nativeAdView addSubview:platformIv];
                nativeAdView.adLogoImageView = adIv;
                [nativeAdView addSubview:adIv];
                
                /* lzy171108注:
                 多图广告的填充的数据有小概率出现广告数据返回中，没有多图物料。
                 可能的解决方式，1是用大图占位，2是配置多图广告位广告返回条数，从多个放回的广告里，把有多图数据的挑出来展示。
                 
                  法1：在- (void)DkAdSetNativeManagerPrepareForViewWithBlock:(NativeBlk)blk model:(DKADSetNativeDataModel *)model方法设置 传入大图UI,在DKADSetBaiduNativeAdapter类中此处做下处理
                 
                 如果返回数据中多图数组数据为空，mainIv.hidden = NO;
                 否则，                    mainIv.hidden = YES;

                

                 */
  
                

                
                if([object.morepics count]>0 ){
                    for (NSInteger i = 0; i < object.morepics.count; i++) {
                        
                        UIImageView *iv = nil;
                        if (i < morePics.count) {
                            iv = morePics[i];
                        }else{
                            continue;
                        }
                        
                        [nativeAdView addSubview:iv];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object.morepics[i]]]];
                            
                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                iv.image = img;
                            });
                        });
                        
                    }
                }
                
                
                [weakSelf handle:nativeAdView object:object objectsCount:nativeAds.count];
                
                
            };
            //            NSLog(@"%s 百度信息流blk 通知执行", __func__);
            if ([self.nativeAdapterDelegate respondsToSelector:@selector(DkAdSetNativeAdapterPrepareViewWithModel:)]) {
                [self.nativeAdapterDelegate DkAdSetNativeAdapterPrepareViewWithModel:nil];
            }
            
            
        }else if (object.materialType == HTML) {
            //        NSLog(@"--------------------%@", NSStringFromCGRect(frame));
            // 模板广告内部已添加百度广告logo和熊掌，开发者无需添加
            
            BaiduMobAdNativeWebView *webview = [[BaiduMobAdNativeWebView alloc]initWithFrame:frame andObject:object];
            nativeAdView = [[BaiduMobAdNativeAdView alloc]initWithFrame:frame
                                                                webview:webview];
            
            [weakSelf handle:nativeAdView object:object objectsCount:nativeAds.count];
            
            
        }
        
        
        
    }
    
    
    
    
    
    
}


- (UIImage *)imageResoureForName:(NSString*)name
{
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"baidumobadsdk" ofType:@"bundle"];
    NSBundle* b=  [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageWithContentsOfFile: [b pathForResource:name ofType:@"png"]];
}

#pragma mark - DKADSet native adapter delegate

/**
 *  广告请求失败
 */
- (void)nativeAdsFailLoad:(BaiduMobFailReason) reason{
    NSLog(@"%s 百度 信息流 失败原因%d",__func__, reason);
    
    if ([self.nativeAdapterDelegate respondsToSelector:@selector(DKADSetNativeAdapterRequestAdFail:)]) {
        [self.nativeAdapterDelegate DKADSetNativeAdapterRequestAdFail:[NSString stringWithFormat:@"%d",reason]];
        
    }
}

/**
 展示曝光
 */
- (void)DKADSetNativeAdapterShowAdWithView:(UIView *)view{
    
    [super DKADSetNativeAdapterShowAdWithView:view];
    // 确定视图显示在window上之后再调用trackImpression，不要太早调用
    //在tableview或scrollview中使用时尤其要注意
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        if ([view isKindOfClass:[BaiduMobAdNativeAdView class]]) {
            [(BaiduMobAdNativeAdView *)view trackImpression];
            
        }
        
    });
    
}



//对于视频广告，展现一张视频预览大图，点击开始播放视频
- (void)nativeAdVideoAreaClick:(BaiduMobAdNativeAdView*)nativeAdView {
    if ([nativeAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
        [(BaiduMobAdNativeVideoView *)nativeAdView.videoView play];
    }
}

//广告被点击，打开后续详情页面，如果为视频广告，可选择暂停视频
-(void)nativeAdClicked:(BaiduMobAdNativeAdView *)nativeAdView
{
    if ([nativeAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
        [(BaiduMobAdNativeVideoView *)nativeAdView.videoView pause];
    }
    // 广告被点击的回调
    [self.nativeAdapterDelegate DKADSetNativeAdapterClicked];
    
}

//广告详情页被关闭，如果为视频广告，可选择继续播放视频
-(void)didDismissLandingPage:(BaiduMobAdNativeAdView *)nativeAdView
{
    if ([nativeAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
        [(BaiduMobAdNativeVideoView *)nativeAdView.videoView play];
    }
}

- (void)dealloc
{
    self.native.delegate = nil;
    self.native = nil;
    
}

@end
