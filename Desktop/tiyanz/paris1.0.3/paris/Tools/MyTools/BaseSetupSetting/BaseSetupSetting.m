//
//  BaseSetupSetting.m
//  laizhuan
//
//  Created by thor on 2018/6/1.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "BaseSetupSetting.h"
#import "VPN.h"
#import "WIFIInfo.h"

@implementation BaseSetupSetting

+(void)baseSetupSetting:(BaseSetupBlock)block{
    BOOL vpn = [VPN isVPNConnected];
    BOOL proxy = [WIFIInfo getProxyStatus];
    block(vpn,proxy);
}

+(void)vpnToSetting{
    
}

+(void)proxyToSetting{
    
}


// 0,VPN；1，代理
+ (void)alertWithType:(int)type vc:(UIViewController *)vc{
    NSURL *url;
    NSString *msg;
    if (type == 0) {
        url = [NSURL URLWithString:@"App-prefs:root=General"];
        msg = @"请到\"设置-->通用\"中关闭vpn";
    }else if(type == 1){
        url = [NSURL URLWithString:@"App-prefs:root=WIFI"];
        msg = @"请到\"设置-->wifi\"中关闭http代理";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alert addAction:sure];
    [vc presentViewController:alert animated:YES completion:nil];
}



@end












