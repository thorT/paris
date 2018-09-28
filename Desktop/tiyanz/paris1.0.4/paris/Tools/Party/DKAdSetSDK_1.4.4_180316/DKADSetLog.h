//  Created by liuzhiyi on 16/11/15.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  自定义Log，可配置开关（用于替换NSLog）
 */
//#ifdef DEBUG

#define LzyLog(format,...) DkAdSetLog(format,##__VA_ARGS__)

//#else
//#define LzyLog(...)


//#endif
/**
 *  自定义Log
 *  @warning 外部可直接调用 DkAdSetLog
 *
 *   方法名
 *   行号
 *   format       Log内容
 *   ...          个数可变的Log参数
 */
void DkAdSetLog( NSString *format, ...);

/**
 *  自定义Log类，外部控制Log开关
 */
@interface DKADSetLog : NSObject

/**
 *  Log 输出开关 (默认开启，release时关闭)
 *
 *  @param flag 是否开启
 */
+ (void)setLogEnable:(BOOL)flag;

/**
 *  是否开启了 Log 输出
 *
 *  @return Log 开关状态
 */
+ (BOOL)logEnable;

@end
