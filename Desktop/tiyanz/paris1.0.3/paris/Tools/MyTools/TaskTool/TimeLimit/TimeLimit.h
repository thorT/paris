//
//  TimeLimit.h
//  laizhuan
//
//  Created by thor on 2018/5/14.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 单例
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;


#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}


@interface TimeLimit : NSObject


@property (nonatomic, assign) BOOL taskOpened;//已经告诉后台这个app激活了

/** 任务 */
- (void)startTask:(NSString *)bid limit:(NSString *)limit;
- (void)taskClear;

/** 获取属性 */
- (NSString *)getTaskBid;
- (NSString *)getTaskLimit;
- (NSString *)getTaskCountDownTime;
- (BOOL)taskOK;

- (void)openAppWith:(NSTimeInterval)interval;



//- (void)saveLocalLimit:(NSString *)limit bid:(NSString *)bid;





DEFINE_SINGLETON_FOR_HEADER(TimeLimit)

@end
