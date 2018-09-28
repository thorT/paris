//
//  DKADSetCpuAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/9/29.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKADSetCpuAdapter : NSObject
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *appId;

/**
 *  广告参数配置
 */
- (void)configure;

/**
 *  加载广告
 */
- (NSString *)load;
@end
