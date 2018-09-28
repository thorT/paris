//
//  VPN.m
//  laizhuan
//
//  Created by thor on 2018/5/18.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "VPN.h"
#import <UIKit/UIKit.h>
#import "Const.h"

@implementation VPN

+ (BOOL)isVPNConnected {
    if ([Const device_Is_iPhoneX]) {
        return NO;
    }
    UIApplication *app = [UIApplication sharedApplication];
    UIView *statusView = [app valueForKey:@"statusBar"];
    NSArray *subViews = [[statusView valueForKey:@"foregroundView"] subviews];
    
    Class StatusBarIndicatorItemViewClass = NSClassFromString(@"UIStatusBarIndicatorItemView");
    for (UIView *subView in subViews) {
        Class SubStatusBarIndicatorItemViewClass = [subView class];
        if ([SubStatusBarIndicatorItemViewClass isSubclassOfClass:StatusBarIndicatorItemViewClass]) {
            NSString *desc = [subView description];
            BOOL isContainedVPN = [desc containsString:@"VPN"];
            BOOL isvisibleVPN = [[subView valueForKey:@"_visible"] boolValue];
            if (isContainedVPN == YES || isvisibleVPN == YES) {
                return isContainedVPN;
            }
        }
    }
    return NO;
}


@end
