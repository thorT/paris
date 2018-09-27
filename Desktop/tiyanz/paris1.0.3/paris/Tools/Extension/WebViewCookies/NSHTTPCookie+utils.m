//
//  NSHTTPCookie+utils.m
//  paris
//
//  Created by thor on 2018/8/16.
//  Copyright © 2018年 paris. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSHTTPCookie (utils)

- (NSString *)da_javascriptString
{
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    return string;
}

@end
