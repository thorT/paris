//
//  WIFIInfo.h
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIFIInfo : NSObject

+ (NSDictionary *)wifi_info;

// 是否打开wifi代理
+ (BOOL)getProxyStatus;

@end
