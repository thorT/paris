//
//  UMPushHelper.m
//  laigou
//
//  Created by thor on 2016/12/9.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "UMPushHelper.h"

// 推送
#import "UMessage.h"

@implementation UMPushHelper

+ (void)initUMPushWithOptions:(NSDictionary *)launchOptions delegate:(id)delegate{
    
    // 友盟推送
    [UMessage startWithAppkey:umAppKey launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=delegate;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10   completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    // 不允许自动弹框
    [UMessage setAutoAlert:NO];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    // 是否接收到了推送开启的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
    if ([GB_ToolUtils isNotBlank:launchOptions]) {
        NSDictionary *userInfo = launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if ([GB_ToolUtils isNotBlank:userInfo]) {
//            [NotificationCenter postNotificationName:kRemoteNotificationsTypeBackground object:self userInfo:userInfo];
        }
    }
        // 执行
    });
}

///** 收到推送 app此刻在后台 */
//+ (void)remoteNotification_backgroundWtihUserInfo:(NSDictionary *)userInfo{
//     [NotificationCenter postNotificationName:kRemoteNotificationsTypeBackground object:self userInfo:userInfo];   
//}
//
///** 收到推送 app此刻在前台 */
//+ (void)remoteNotification_activeWtihUserInfo:(NSDictionary *)userInfo{
//     [NotificationCenter postNotificationName:kRemoteNotificationsTypeActive object:self userInfo:userInfo];
//}




@end






