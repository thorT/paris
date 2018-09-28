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

//static NSString *js_main        = @"http://10.0.0.139:8085";
//static NSString *js_main        = @"http://192.168.199.137:8085";
static NSString *js_main        = @"https://t.dijiadijia.com/dist/";


// 新版
static NSString *js_startTask        = @"js_startTask";// 开始任务 type  0:未安装；1：打开目标app，返回YES；2：有任务正在进行中；参数limit/bid
static NSString *js_music        = @"js_music";
static NSString *js_taskinfo       = @"js_taskinfo";
static NSString *js_clearTask        = @"js_clearTask";// 取消任务
static NSString *js_service          = @"js_service";// 客服 type 1：QQ客服 2：微信客服；url;返回参数：success 1，正常；0，客户端未安装
static NSString *js_openUrl          = @"js_openUrl";// 打开url
static NSString *js_safari            = @"js_safari";// 进入tctask详情
static NSString *js_wkWeb            = @"js_wkWeb";
static NSString *js_openApp            = @"js_openApp";// 打开app
static NSString *js_taskTime            = @"js_taskTime";// 打开app
static NSString *js_getTaskList        = @"js_getTaskList";// 获取任务列表
static NSString *js_net                = @"js_net";// 获取任务列表
static NSString *js_getPasteboard      = @"js_getPasteboard";
static NSString *js_setPasteboard      = @"js_setPasteboard";
static NSString *js_saveData      = @"js_saveData";
static NSString *js_localData      = @"js_localData";
static NSString *js_saveQRUrlImage      = @"js_saveQRUrlImage";
static NSString *js_saveFullScreen      = @"js_saveFullScreen";
static NSString *js_wxLogin             = @"js_wxLogin";
static NSString *js_share            = @"js_share";          // 分享
static NSString *js_curVer            = @"js_curVer";          //当前版本
static NSString *js_netFull            = @"js_netFull";
static NSString *js_veriDev            = @"js_veriDev";


static NSString *kEncode              = @"encode";            //加密
static NSString *kDecode              = @"decode";            //解密














#endif /* HtmlAPI_h */










