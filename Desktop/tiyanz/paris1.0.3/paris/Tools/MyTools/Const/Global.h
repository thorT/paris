//
//  HtmlAPI.h
//  laigou
//
//  Created by thor on 2016/11/25.
//  Copyright © 2016年 thor. All rights reserved.
//

#ifndef Global_h
#define Global_h

#import "GB_ToolUtils.h"
#import "BaseViewController.h"
#import "DataSingleton.h"
#import "NetRequestClass.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+BWMExtension.h"
#import "HtmlAPI.h"
#import "ServerAPI.h"
#import "Global_ui.h"
#import "TimeLimit.h"


static NSString *s_needVarUdid           = @"s_needVarUdid";// 需要验证udid
static NSString *s_uid               = @"s_user_id";
static NSString *s_keys              = @"s_keys";
static NSString *s_phone                 = @"phone";
static NSString *s_nickname              = @"nickname";
static NSString *s_head_img              = @"head_img";
static NSString *s_price                 = @"price";
static NSString *s_openid                = @"openid";
static NSString *s_allow_push            = @"allow_push";


// 全局关键字
static NSString *g_taskMonitor          = @"g_taskMonitor";// 开始任务
static NSString *g_firstLaunch          = @"g_firstLaunch";// 第一次运行程序
static NSString *g_updateHome          = @"g_updateHome";// 更新首页
static NSString *g_activityUrl_success          = @"g_activityUrlSuccess";//已经激活

static NSString *wanpApp_id          = @"5f07816be40db714ba6957079781ab22";
static NSString *umAppKey            = @"5b246524f43e4829a4000165";


// 商务
static NSString *tcAppKey             = @"com.tiantao.tiyanke";
static NSString *tcUserName           = @"tiantao";
static NSString *tcCoopid             = @"1218";


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



#endif /* Global_h */










