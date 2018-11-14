//
//  WXLogin.m
//  laizhuan
//
//  Created by thor on 2018/5/30.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "WXLogin.h"
#import <UMSocialCore/UMSocialCore.h>
#import "Const.h"
#import "JsonTool.h"


@implementation WXLogin

+ (void)login:(WXLoginBlock)loginBlock{
    [self getAuthWithUserInfoFromWechat:loginBlock];
}
+ (void)getAuthWithUserInfoFromWechat:(WXLoginBlock)loginBlock
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 调接口 发送给服务器
            [self wxLoginSuccessAction:resp loginBlock:loginBlock];
        }
    }];
}


+ (void)wxLoginSuccessAction:(UMSocialUserInfoResponse *)resp loginBlock:(WXLoginBlock)loginBlock{
    
    // 授权信息
    
    // 第三方平台SDK源数据
    
    NSString *wx_uid = resp.uid;
    NSString *openid = resp.openid;
    NSString *unionId = resp.unionId;
    NSString *accessToken = resp.accessToken;
    NSString *refreshToken = resp.refreshToken;
    NSString *nickname = resp.name;
    NSString *headimgurl = resp.iconurl;
    NSString *sex = resp.originalResponse[@"sex"];
    NSString *city = resp.originalResponse[@"city"];
    NSString *country = resp.originalResponse[@"country"];
    NSString *language = resp.originalResponse[@"language"];
    NSString *province = resp.originalResponse[@"province"];
    
    NSDictionary *dic = @{@"wx_uid":wx_uid,
                          @"openid":openid,
                          @"unionId":unionId,
                          @"accessToken":accessToken,
                          @"refreshToken":refreshToken,
                          @"nickname":nickname,
                          @"headimgurl":headimgurl,
                          @"sex":sex,
                          @"city":city,
                          @"country":country,
                          @"language":language,
                          @"province":province,
                          @"code":@""
                          };
    
    NSMutableDictionary *final = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *uid = [Const getUID];
    if ([GB_ToolUtils isBlank:uid]) {
        uid = @"";
    }
    NSDictionary *info = @{@"uid":uid};
    [final addEntriesFromDictionary:info];
    
    // 登录
    NSString *url = [NSString stringWithFormat:@"%@%@",APIMain,APIWX_login];
    
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:final WithReturnValeuBlock:^(NSDictionary *returnValue) {
        
        NSString *code = [NSString stringWithFormat:@"%@",returnValue[@"code"]];
        if ([code isEqualToString:@"200"]) {
            loginBlock(YES,@"");
        }else{
            loginBlock(NO,returnValue[@"msg"]);
        }
        
        // 注册成功，保存信息
//        DataSingleton *dh = [DataSingleton sharedDataSingleton];
//        NSDictionary *data = returnValue[@"data"];
//        if ([GB_ToolUtils isNotBlank:data]) {
//            NSString *uid = data[@"uid"];
//            NSString * nickname= data[@"nickname"];
//            NSString *token = data[@"token"];
//            NSString *head_img = data[@"head_img"];
//            NSString *price = data[@"price"];
//            NSString *openid = data[@"wx_openid"];
//            NSString *allow_push = [THConst turnToString:data[@"allow_push"]];
//
//            if ([GB_ToolUtils isNotBlank:allow_push]) {
//                [dh saveLocalData:kallow_push value:allow_push];
//            }
//            if ([GB_ToolUtils isNotBlank:openid]) {
//                [dh saveLocalData:kopenid value:openid];
//            }
//
//            if ([GB_ToolUtils isNotBlank:token]) {
//                [dh saveLocalData:kToken value:token];
//            }
//            if ([GB_ToolUtils isNotBlank:uid]) {
//                [dh saveLocalData:kuid value:uid];
//            }
//            if ([GB_ToolUtils isNotBlank:nickname]) {
//                [dh saveLocalData:knickname value:nickname];
//            }
//            if ([GB_ToolUtils isNotBlank:head_img]) {
//                [dh saveLocalData:khead_img value:head_img];
//            }
//            if ([GB_ToolUtils isNotBlank:price]) {
//                [dh saveLocalData:kprice value:price];
//            }
//
//            [NotificationCenter postNotificationName:klocation_data_update object:nil];
//            [self performSelector:@selector(dismissVC) withObject:nil afterDelay:kHUDHideTimeInterval];
//        }
        
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        
    } WithFailureBlock:^(NSString *errorMsg) {
        
    }];
}



@end
