//
//  UMPushHelper.h
//  laigou
//
//  Created by thor on 2016/12/9.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface UMPushHelper : NSObject

/** 初始化友盟推送 这个方法只能在launch方法中调用 */
+ (void)initUMPushWithOptions:(NSDictionary *)launchOptions delegate:(id)delegate;


///** 收到推送 app此刻在后台 */
//+ (void)remoteNotification_backgroundWtihUserInfo:(NSDictionary *)userInfo;
//
///** 收到推送 app此刻在前台 */
//+ (void)remoteNotification_activeWtihUserInfo:(NSDictionary *)userInfo;

@end
