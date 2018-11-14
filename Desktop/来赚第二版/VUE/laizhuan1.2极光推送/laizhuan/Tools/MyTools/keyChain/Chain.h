//
//  yahuitool.h
//  网页调起传参接收测试
//
//  Created by 王亚辉 on 2018/4/13.
//  Copyright © 2018年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chain : NSObject


+ (void)deleteChain;

+ (void)saveChainKeys:(NSString *)keys;

+ (NSString *)getChainKeys;


@end
