//
//  BaseSetupSetting.h
//  laizhuan
//
//  Created by thor on 2018/6/1.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BaseSetupBlock) (BOOL vpn, BOOL proxy);

@interface BaseSetupSetting : NSObject

+(void)baseSetupSetting:(BaseSetupBlock)block;
+ (void)alertWithType:(int)type vc:(UIViewController *)vc;
@end
