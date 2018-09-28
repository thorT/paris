//
//  DKADSetCpuManager.h
//  DKADSet
//
//  Created by liuzhiyi on 16/9/29.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKADSetCpuManager : NSObject

+ (instancetype)sharedCupManger;

/**
 *  返回媒体URL
 *
 *  @param channelId   频道ID
 *  @param appId 应用ID
 *  说明：
 */
- (NSString *)dkAdSetGetCpuInfoUrlWithChannelId:(NSString *)channelId
                                   appId:(NSString *)appId;
@end
