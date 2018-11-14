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
#import "HtmlAPI.h"

@interface TimeLimit()

@property (nonatomic, assign) NSInteger limitTimeLeave;//需要保存到本地的限制时间

@end

@implementation TimeLimit

- (instancetype)init{
    self = [super init];
    if (self) {
        self.limitTimeLeave = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationWillResignActive:(NSNotification *)notification{
    NSDictionary *dic = [[DataSingleton sharedDataSingleton] getLocalData:g_taskTime];
    if ([GB_ToolUtils isNotBlank:dic]) {
        if (self.limitTimeLeave) {
            NSMutableDictionary *dic_mut = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dic_mut setObject:@(self.limitTimeLeave) forKey:@"timeLimit"];
            [[DataSingleton sharedDataSingleton] saveLocalData:g_taskTime value:dic_mut];
            return;
        }
        NSMutableDictionary *dic_mut = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time = [date timeIntervalSince1970];
        [dic_mut setObject:@(time) forKey:@"time"];
        [[DataSingleton sharedDataSingleton] saveLocalData:g_taskTime value:dic_mut];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    NSDictionary *dic = [[DataSingleton sharedDataSingleton] getLocalData:g_taskTime];
    if ([GB_ToolUtils isNotBlank:dic]) {
        NSInteger time_old = [dic[@"time"] integerValue];
        NSInteger timeLimit = [dic[@"timeLimit"] integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now = [date timeIntervalSince1970] ;
        //获取当前是几点
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
        NSInteger hour = [components hour];
        // 算剩余时间
        BOOL busyTimeOK = timeLimit - (now - time_old)<0;
        BOOL freeTimeOK = timeLimit +30 - (now - time_old)<0;
        if ((hour>17||hour<15)&&freeTimeOK) {
            self.taskTimeOK = YES;
        }else if(busyTimeOK){
            self.taskTimeOK = YES;
        }
        
        // 剩余时间
        if (hour>17||hour<15) {
           NSInteger countDownTime = timeLimit +30 - now + time_old;
            if (countDownTime >20) {
                countDownTime = countDownTime + 20;
            }
            self.limitTimeLeave = countDownTime;
            self.CountDownTime = countDownTime;
        }else{
            NSInteger countDownTime = timeLimit - (now - time_old);
            if (countDownTime >20) {
                countDownTime = countDownTime + 20;
            }
            self.limitTimeLeave = countDownTime;
            self.CountDownTime = countDownTime;
        }
        if (self.CountDownTime<=0) {
            self.CountDownTime = 0;
            self.limitTimeLeave = 0;
        }
    }
}

- (void)taskReset{
    self.CountDownTime = 0;
    self.limitTimeLeave = 0;
    self.taskTimeOK = NO;
    [[DataSingleton sharedDataSingleton] removeLocalData:g_taskTime];
}

@end
