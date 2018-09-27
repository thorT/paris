//
//  TimeHandle.h
//  Timer
//
//  Created by thor on 2018/6/17.
//  Copyright © 2018年 lety. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerHandle : NSObject

@property (nonatomic, assign) NSTimeInterval timeInterval;

+ (instancetype)sharedTimerHandle;

- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval;

- (void)startTimer;

- (void)resumeTimer;

- (void)endTimer;



@end
