//
//  JailBreak.h
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailBreak : NSObject

// 有越狱文件
+ (BOOL)hasJailBreakFile;

// 可以打开 CydiaUrl
+ (BOOL)canOpenCydiaUrl;

// 获取到越狱环境
+ (BOOL)getJailBreakEnv;

// 可以获取到所有应用名称
+ (BOOL)loadAllAppName;

+ (BOOL)isJailBreak;

@end
