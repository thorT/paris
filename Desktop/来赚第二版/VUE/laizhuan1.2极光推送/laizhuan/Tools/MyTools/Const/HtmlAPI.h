//
//  HtmlAPI.h
//  laigou
//
//  Created by thor on 2016/11/25.
//  Copyright © 2016年 thor. All rights reserved.
//

#ifndef HtmlAPI_h
#define HtmlAPI_h


#pragma mark js与oc 交互

//static NSString *js_main        = @"http://10.0.0.51:8081/#/";
//static NSString *js_main       = @"http://10.0.0.19:8081/#/";
static NSString *js_main        = @"http://106.15.157.173/laizhuan/dist/#/";
//static NSString *js_main        = @"http://www.baidu.com";
//static NSString *js_main        = @"http://10.0.0.126:8081/#/";


// 新版
static NSString *js_startTask          = @"js_startTask";// 开始任务 type  0:未安装；1：打开目标app，返回YES；2：有任务正在进行中；参数limit/bid
static NSString *js_finishTask         = @"js_finishTask";// 完成任务 type  0:当前没有任务进行；1：任务完成；2：任务未完成
static NSString *js_resetTask         = @"js_resetTask";// 取消任务

static NSString *js_service         = @"js_service";// 客服 type 1：QQ客服 2：微信客服；url;返回参数：success 1，正常；0，客户端未安装

static NSString *js_openUrl            = @"js_openUrl";// 打开url
static NSString *js_openApp            = @"js_openApp";// 打开app
static NSString *js_taskTime            = @"js_taskTime";// 打开app

static NSString *js_getTaskList        = @"js_getTaskList";// 获取任务列表
static NSString *js_net                = @"js_net";// 获取任务列表

static NSString *js_getPasteboard      = @"js_getPasteboard";
static NSString *js_setPasteboard      = @"js_setPasteboard";
static NSString *js_saveQRUrlImage      = @"js_saveQRUrlImage";
static NSString *js_saveFullScreen      = @"js_saveFullScreen";
static NSString *js_wxLogin             = @"js_wxLogin";
static NSString *js_share            = @"js_share";          // 分享
static NSString *js_curVer            = @"js_curVer";          //当前版本
static NSString *js_netFull            = @"js_netFull";
static NSString *js_veriDev            = @"js_veriDev";


static NSString *kEncode              = @"encode";            //加密
static NSString *kDecode              = @"decode";            //解密




// 提示
static NSString *tVPN              = @"请关闭VPN连接";
static NSString *tProxt              = @"请关闭wifi代理";    







#endif /* HtmlAPI_h */










