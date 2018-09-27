//
//  UMShare.m
//  laigou
//
//  Created by thor on 2016/12/9.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "UMShareHelper.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialManager.h>

// 微信
#define kWXAppKey           @"wx005c3ca9cf1b50f8"
#define kWXAppSecret        @"740f822e026f6e83a761932e0b478e93"
// QQ
#define kQQAppKey           @"1107827614"
#define kQQAppSecret        @""
// sina
#define kSinaAppKey         @"316775107"
#define kSinaAppSecret      @"380d1fbc12edfe2791357ed2f7cde253"




@implementation UMShareHelper

/** 初始化友盟分享及各个平台参数 */
+ (void)initUMShare{
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:NO];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"597ffa36ae1bf8200900063a"];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kWXAppKey
                                       appSecret:kWXAppSecret
                                     redirectURL:@"http://mobile.umeng.com/social"];
    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:kQQAppKey
                                       appSecret:nil
                                     redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:kSinaAppKey
                                       appSecret:kSinaAppSecret
                                     redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}


/** 是否安装QQ */
+ (BOOL)isQQInstalled{
    return  [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
}

/** 是否安装新浪微博 */
+ (BOOL)isSinaInstalled{
    return  [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina];
}

/** 是否安装微信 */
+ (BOOL)isWXInstalled{
    return  [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
}

/**  弹出分享面板 */
+ (void)shareMenu:(UIViewController *)viewController model:(UMShareMode *)model platforms:(NSArray *)platforms{
    //加入copy的操作
    //@see http://dev.umeng.com/social/ios/进阶文档#6
    //    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
    //                                     withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
    //                                     withPlatformName:@"演示icon"];
    
    [UMSocialUIManager setPreDefinePlatforms:platforms];
    
    //    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    //    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"邀请好友";
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.shareContainerMarginTop = 15;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            NSLog(@"点击演示添加Icon后该做的操作");
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加自定义icon"
            //                                                                message:@"具体操作方法请参考UShareUI内接口文档"
            //                                                               delegate:nil
            //                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
            //                                                      otherButtonTitles:nil];
            //                [alert show];
            //
            //            });
        }
        else{
            switch (platformType) {
                case UMSocialPlatformType_Sina:
                    [self shareToSina:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_WechatSession:
                    [self shareToWX:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_WechatTimeLine:
                    [self shareToWXZone:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_QQ:
                    [self shareToQQ:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_Qzone:
                    [self shareToQQZone:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_Sms:
                    [self shareToSms:viewController model:model callback:nil];
                    break;
                    
                default:
                    break;
            }
            
            // [self runShareWithType:platformType];
        }
    }];
}
/**  弹出分享面板 */
+ (void)shareMenu:(UIViewController *)viewController model:(UMShareMode *)model block:(ShareBack)block{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sms),@(UMSocialPlatformType_Sina)]];
    
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享有奖-徒弟做任务，你有提成哦";
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.shareContainerMarginTop = 15;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
        }
        else{
            switch (platformType) {
                case UMSocialPlatformType_Sina:
                    [self shareToSina:viewController model:model callback:block];
                    break;
                case UMSocialPlatformType_WechatSession:
                    [self shareToWX:viewController model:model callback:block];
                    break;
                case UMSocialPlatformType_WechatTimeLine:
                    [self shareToWXZone:viewController model:model callback:block];
                    break;
                case UMSocialPlatformType_QQ:
                    [self shareToQQ:viewController model:model callback:block];
                    break;
                case UMSocialPlatformType_Qzone:
                    [self shareToQQZone:viewController model:model callback:block];
                    break;
                case UMSocialPlatformType_Sms:
                    [self shareToSms:viewController model:model callback:block];
                    break;
                    
                default:
                    break;
            }
            
            // [self runShareWithType:platformType];
        }
    }];
}

/**  弹出分享面板 */
+ (void)shareMenu:(UIViewController *)viewController model:(UMShareMode *)model{
    //加入copy的操作
    //@see http://dev.umeng.com/social/ios/进阶文档#6
    //    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
    //                                     withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
    //                                     withPlatformName:@"演示icon"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                     withPlatformIcon:[UIImage imageNamed:@"tx01"]
                                     withPlatformName:@"复制链接"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+3
                                     withPlatformIcon:[UIImage imageNamed:@"tx01"]
                                     withPlatformName:@"保存二维码"];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sms),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_UserDefine_Begin+2),@(UMSocialPlatformType_UserDefine_Begin+3)]];
    
    //    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    //    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享-好友";
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.shareContainerMarginTop = 15;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            NSLog(@"点击演示添加Icon后该做的操作");
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加自定义icon"
            //                                                                message:@"具体操作方法请参考UShareUI内接口文档"
            //                                                               delegate:nil
            //                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
            //                                                      otherButtonTitles:nil];
            //                [alert show];
            //
            //            });
        }
        else{
            switch (platformType) {
                case UMSocialPlatformType_Sina:
                    [self shareToSina:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_WechatSession:
                    [self shareToWX:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_WechatTimeLine:
                    [self shareToWXZone:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_QQ:
                    [self shareToQQ:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_Qzone:
                    [self shareToQQZone:viewController model:model callback:nil];
                    break;
                case UMSocialPlatformType_Sms:
                    [self shareToSms:viewController model:model callback:nil];
                    break;
                    
                default:
                    break;
            }
            
            // [self runShareWithType:platformType];
        }
    }];
}

/** 分享到QQ */
+ (void)shareToQQ:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    [self shareTo:UMSocialPlatformType_QQ viewController:viewController model:model callback:callback];
}

/** 分享到QQ空间 */
+ (void)shareToQQZone:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    [self shareTo:UMSocialPlatformType_Qzone viewController:viewController model:model callback:callback];
}

/** 分享到微信 */
+ (void)shareToWX:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    [self shareTo:UMSocialPlatformType_WechatSession viewController:viewController model:model callback:callback];
}

/** 分享到微信朋友圈 */
+ (void)shareToWXZone:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    [self shareTo:UMSocialPlatformType_WechatTimeLine viewController:viewController model:model callback:callback];
}

/** 分享到新浪微博 */
+ (void)shareToSina:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    [self shareTo:UMSocialPlatformType_Sina viewController:viewController model:model callback:callback];
}

/** 分享到短信 */
+ (void)shareToSms:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    [self shareTo:UMSocialPlatformType_Sms viewController:viewController model:model callback:callback];
}

// 分享web
+ (void)shareTo:(UMSocialPlatformType)platformType viewController:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    NSString* title =  model.title;
    NSString* thumbURL = model.thumbURL;
    // NSURL *imageUrl = [NSURL URLWithString:thumbURL];
    
    id data;
    if ([GB_ToolUtils isNotBlank:thumbURL]) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]];
    }else{
        data = [UIImage imageNamed:@"icon_20"];
    }
    NSString *link = model.webpageUrl;
    NSString* descr =  model.descr;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:data];
    //设置网页地址
    shareObject.webpageUrl = link; //;
    
    //    if (platformType == UMSocialPlatformType_Sina) {
    //        shareObject.thumbImage = [UIImage imageNamed:@"icon_20"];
    //    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:viewController
                                           completion:^(id data, NSError *error) {
                                               if (!error) {
                                                   NSLog(@"分享成功");
                                                   if (callback) {
                                                       callback(YES,@"分享成功");
                                                   }
                                               } else {
                                                   NSLog(@"分享失败");
                                                   if (callback) {
                                                       callback(NO,@"分享失败");
                                                   }
                                               }
                                           }];
    
}

//
//+ (void)recodeShareModel:(UMShareMode *)model{
//
//    // 参数
//    DataSingleton *dh = [DataSingleton sharedDataSingleton];
//    NSString *uid = [dh getLocalData:kuid];
//
//    // 没有登录，就不再调下面的接口
//    if ([GB_ToolUtils isBlank:uid] ) {
//        NSLog(@"==>/n 邀请接口，不调用 uid = %@",uid);
//        return;
//    }
//
//    NSString *num_iid = model.num_iid;
//    if ([GB_ToolUtils isBlank:num_iid]) {
//        num_iid = @"";
//    }
//
//    // 发送给后台
//    NSString *url = [NSString stringWithFormat:@"%@%@",APIMain_test,API_GoodsShow_share];
//
//    NSDictionary *param = @{@"user_id":uid,
//                            @"num_iid":num_iid,
//                            @"type":@"0"
//                            };
//
//    [NetRequestClass NetRequestNotEncryPOSTWithRequestURL:url
//                                    WithParameter:param
//                             WithReturnValeuBlock:^(NSDictionary *returnValue) {
//
//                             }WithErrorCodeBlock:^(NSDictionary *errorCode) {
//
//                             }WithFailureBlock:^(NSString *errorMsg){
//
//                             }];
//
//
//
//}


@end




































