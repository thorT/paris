//
//  test.h
//  kittens
//
//  Created by kittens on 17/9/29.
//  Copyright © 2017年 kittens. All rights reserved.
//

#import <Foundation/Foundation.h>


// 是否同意了
typedef void (^AIDStatusBlock) (BOOL agree);

@interface Enc : NSObject

/** 是否同意 */
+ (void)requestPhoto:(AIDStatusBlock)agree;

/** 认证状态 */
+ (int)authorizationStatus;


+ (NSString *)aid;


+ (BOOL)openApp:(NSString *)string;


+ (BOOL)openAppWithNoEnc:(NSString *)string;


@end
