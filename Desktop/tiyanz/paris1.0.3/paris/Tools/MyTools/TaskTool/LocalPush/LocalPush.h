//
//  LocalPush.h
//  paris
//
//  Created by thor on 2018/6/17.
//  Copyright © 2018年 paris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPush : NSObject

+ (void)setup:(UIApplication *)application;

+ (void)push:(NSString *)body;


@end
