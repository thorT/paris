//
//  JailBreak.m
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "JailBreak.h"
#import <UIKit/UIKit.h>

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

//1.
#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])
//5.
#define CYDIA_APP_PATH                @"/Applications/Cydia.app"
#include <sys/stat.h>
#include <unistd.h>
#import <dlfcn.h>
#import <sys/sysctl.h>

@implementation JailBreak

+ (BOOL)isJailBreak{
    if ([self hasJailBreakFile]||[self canOpenCydiaUrl]||[self getJailBreakEnv]||[self loadAllAppName]||[self youmi_IsJail]) {
        return YES;
    }
    return NO;
}
+ (BOOL)youmi_IsJail{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia:"]]) {
            return YES; }
    BOOL isJailbroken = NO;
    FILE *f = fopen("/bin/bash", "r"); if (!(errno == ENOENT)) {
        isJailbroken = YES; }
    fclose(f);
    return isJailbroken;
}

+ (BOOL)hasJailBreakFile{
    BOOL hasJailBreakFile=NO;
    const char* jailbreak_tool_pathes[] = {
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt"
    };
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]])
        {
            hasJailBreakFile=YES;
        }
    }
    return hasJailBreakFile;
}

+ (BOOL)canOpenCydiaUrl{
    //是否可以打开越狱的URL Scheme
    BOOL canOpenCydiaUrl=NO;
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        canOpenCydiaUrl=YES;
    }
    return canOpenCydiaUrl;
}

+ (BOOL)getJailBreakEnv{
    return [self getEnv];
}

+ (BOOL)loadAllAppName{
   return [[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"];
}

+ (BOOL)getEnv{
    if (getenv("DYLD_INSERT_LIBRARIES")) {
        return YES;
    }
    return NO;
}

#pragma mark - 通过判定cydia应用，但方法是用的stat函数，同时会判定是否有注入动态库。
int checkInject() {
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char*, struct stat*) = stat;
    char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
    if ((ret = dladdr(func_stat, &dylib_info)) && strncmp(dylib_info.dli_fname, dylib_name, strlen(dylib_name))) {
        return 0;
    }
    return 1;
}
int checkCydia() {
    struct stat stat_info;
    if (!checkInject()) {
        if (0 == stat("/Applications/Cydia.app", &stat_info)) {
            return 1;
        }
    } else {
        return 1;
    }
    return 0;
}

@end











