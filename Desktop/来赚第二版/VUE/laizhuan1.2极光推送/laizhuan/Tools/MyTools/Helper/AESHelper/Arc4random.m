//
//  Arc4random.m
//  qingshang
//
//  Created by thor on 16/3/9.
//  Copyright © 2016年 Bodo. All rights reserved.
//

#import "Arc4random.h"

@implementation Arc4random

+ (long)getRandomNumber:(long)from to:(long)to
{
    long k = (long)(to - from);
    return (long)(from + (arc4random() % (k + 1)));
}

@end


