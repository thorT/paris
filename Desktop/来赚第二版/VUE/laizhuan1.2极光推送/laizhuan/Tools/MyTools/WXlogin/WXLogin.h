//
//  WXLogin.h
//  laizhuan
//
//  Created by thor on 2018/5/30.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WXLoginBlock) (BOOL success, NSString *msg);

@interface WXLogin : NSObject

+ (void)login:(WXLoginBlock)loginBlock;

@end
