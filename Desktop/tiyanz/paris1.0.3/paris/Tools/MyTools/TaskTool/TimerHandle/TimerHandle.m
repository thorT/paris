//
//  TimeHandle.m
//  Timer
//
//  Created by thor on 2018/6/17.
//  Copyright © 2018年 lety. All rights reserved.
//

#import "TimerHandle.h"
#import <UIKit/UIKit.h>
#import "Const.h"
#import "TimeLimit.h"

@interface TimerHandle()


@end

@implementation TimerHandle
{
    NSTimer *_timer;
    BOOL _isFired;
    NSString *_bid;
}

+ (instancetype)sharedTimerHandle{
    static dispatch_once_t onceToken;
    static TimerHandle *handle;
    
    dispatch_once(&onceToken, ^{
        handle = [[TimerHandle alloc] init];
    });
    return handle;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

#pragma mark - Timer Action
- (void)timerAction{
    if (_timeInterval >= 0) {
        _timeInterval=_timeInterval-1;
        NSInteger time = _timeInterval;
        if (time%5==0) {
            BOOL runInBackGround = [Const runningInBackground];
            if (!runInBackGround) {
                return;
            }
            NSLog(@"time==》》%f",_timeInterval);
            //打开bid
           [[TimeLimit sharedTimeLimit] openAppWith:_timeInterval];
        }
    }else{
        [self stopTimer];
    }
}
#pragma mark - Private Method
- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval{
    _isFired = YES;
    _timeInterval = timeInterval;
    [self.timer setFireDate:[NSDate date]];
}

- (void)startTimer{
    _isFired = YES;
    [self.timer setFireDate:[NSDate date]];
}

- (void)stopTimer{
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        _isFired = NO;
    }
}
- (void)endTimer{
    if (_timer) {
        _isFired = NO;
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)resumeTimer{
    [self stopTimer];
}



@end











