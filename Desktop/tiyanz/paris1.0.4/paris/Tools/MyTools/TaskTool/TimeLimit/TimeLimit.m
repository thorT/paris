//
//  TimeLimit.m
//  laizhuan
//
//  Created by thor on 2018/5/14.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "TimeLimit.h"
#import <UIKit/UIKit.h>
#import "DataSingleton.h"
#import "Global.h"
#import "GB_ToolUtils.h"
#import "Enc.h"
// 任务
#import "LocalPush.h"
#import "TimerHandle.h"
#import "Const.h"
#import "DeviceParam.h"

@interface TimeLimit()

@property (nonatomic, strong) TimerHandle *timeHandle;

// bid
@property (nonatomic, strong) NSString *bid;
@property (nonatomic, strong) NSString *limit;
@property (nonatomic, strong) NSString *startTime;

//剩余时间、s
@property (nonatomic, assign) NSInteger CountDownTime;
// 完成
@property (nonatomic, assign) BOOL taskTimeOK;

@end

@implementation TimeLimit

DEFINE_SINGLETON_FOR_CLASS(TimeLimit)

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (TimerHandle *)timeHandle{
    if (!_timeHandle) {
        _timeHandle = [[TimerHandle alloc] init];
        _timeHandle.timeInterval = 24*24*3600;
    }
    return _timeHandle;
}


- (void)applicationWillResignActive:(NSNotification *)notification{
    if (self.bid) {
        [self.timeHandle startTimer];
        if(self.taskOpened){
            self.timeHandle.timeInterval = [self.limit integerValue];
        }
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    if (self.bid&&self.taskOpened) {
        [self.timeHandle resumeTimer];
        NSInteger time_old = [self.startTime integerValue];
        NSInteger timeLimit = [self.limit integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now = [date timeIntervalSince1970] ;
        //获取当前是几点
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
        NSInteger hour = [components hour];
        BOOL busyTimeOK = timeLimit - (now - time_old)<0;
        BOOL freeTimeOK = timeLimit +30 - (now - time_old)<0;
        if ((hour>17||hour<15)&&freeTimeOK) {
            self.taskTimeOK = YES;
        }else if(busyTimeOK){
            self.taskTimeOK = YES;
        }
        
        // 剩余时间
        if (hour>17||hour<15) {
            self.CountDownTime = timeLimit +30 - now + time_old;
        }else{
           self.CountDownTime =  timeLimit - (now - time_old);
        }
        if (self.CountDownTime<=0) {
            self.CountDownTime = 0;
        }
        
        // 通知
        if (!self.taskTimeOK) {
            [[NSNotificationCenter defaultCenter] postNotificationName:g_taskMonitor object:@{@"taskOK":@"0"}];
        }
        NSLog(@"剩余时间： %ld",(long)self.CountDownTime);
    }
}

- (void)startTask:(NSString *)bid limit:(NSString *)limit{
    self.bid = bid;
    self.limit = [NSString stringWithFormat:@"%@",limit];
    self.CountDownTime = 24*24*3600;
}
/** 获取属性 */
- (NSString *)getTaskBid{
    return self.bid;
}
- (NSString *)getTaskLimit{
    return self.limit;
}
- (NSString *)getTaskCountDownTime{
    return [NSString stringWithFormat:@"%ld",self.CountDownTime];
}
- (BOOL)taskOK{
   return  self.taskTimeOK;
}

- (void)taskClear{
     self.bid = nil;
    self.limit = @"";
    self.CountDownTime = 0;
    self.taskTimeOK = NO;
    [self.timeHandle endTimer];
    self.startTime = 0;
    self.taskOpened = NO;
}

- (void)openAppWith:(NSTimeInterval)interval{
    
    NSLog(@"task 尝试打开app");
    
    if ([GB_ToolUtils isNotBlank:self.bid]) {
        BOOL opened = [Enc openAppWithNoEnc:@"com.houbuwl.douzhuan"];//测试
        if (opened&&self.taskOpened == NO) {
            // 用户已经激活接口
            NSLog(@"task 已经打开，尝试调用已激活接口");
          //  [self openNet];
        }
    }
    if (interval<=0) {
        NSLog(@"task 倒计时结束，任务完成");
        [LocalPush push:@"任务已完成"];
        //[self net_finishedTask];
    }
}



@end
