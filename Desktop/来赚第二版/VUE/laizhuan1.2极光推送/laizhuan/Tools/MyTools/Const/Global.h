//
//  HtmlAPI.h
//  laigou
//
//  Created by thor on 2016/11/25.
//  Copyright © 2016年 thor. All rights reserved.
//

#ifndef Global_h
#define Global_h


#pragma mark js与oc 交互


#import "GB_ToolUtils.h"
#import "DataSingleton.h"
#import "NetRequestClass.h"
#import "ServerAPI.h"
#import "HtmlAPI.h"


//// weak
#define Weakify(obj) __weak __typeof__(obj) weakSelf = (obj)
//
//// strong
#define Strongify(obj) __strong __typeof__(obj) strongSelf = obj

// 新版
static NSString *g_taskTime          = @"g_taskTime";// 开始任务
static NSString *g_firstLaunch          = @"g_firstLaunch";// 第一次运行程序
static NSString *g_updateHome          = @"g_updateHome";// 第一次运行程序

//
//static NSString *umAppKey          = @"5b2b045d8f4a9d14ab00001e";
static NSString *umAppKey          = @"5b32fdcf8f4a9d5ca8000030";





#endif /* Global_h */










