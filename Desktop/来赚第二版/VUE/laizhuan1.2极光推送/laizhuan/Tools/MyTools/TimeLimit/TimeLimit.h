//
//  TimeLimit.h
//  laizhuan
//
//  Created by thor on 2018/5/14.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLimit : NSObject

@property (nonatomic, assign) BOOL taskTimeOK;

// 测试，剩余时间、s
@property (nonatomic, assign) NSInteger CountDownTime;


- (void)taskReset;

@end
