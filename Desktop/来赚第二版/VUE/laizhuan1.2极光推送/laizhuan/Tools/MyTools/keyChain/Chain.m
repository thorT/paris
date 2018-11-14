//
//  yahuitool.m
//  网页调起传参接收测试
//
//  Created by 王亚辉 on 2018/4/13.
//  Copyright © 2018年 NSObject. All rights reserved.
//

#import "Chain.h"
#import <UIKit/UIKit.h>
#import <SAMKeychain/SAMKeychain.h>
#import "NSString+AES.h"


@implementation Chain


//+ (NSString *)getChain{
//    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@"com.Thorlaigou.laigou"account:@"yahuigo"];
//    return currentDeviceUUIDStr;
//}


+ (void)deleteChain{
    [SAMKeychain deletePasswordForService:@"com.Thorlaigou.laigou" account:@"yahuigo"];
}

//0：表示uuid，1：表示udid
+ (void)saveChainKeys:(NSString *)keys{
    NSString *local = [keys aci_encryptWithAES];
    [SAMKeychain setPassword:local forService:@"com.Thorlaigou.laigou"account:@"yahuigo"];
}

+ (NSString *)getChainKeys{
    
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@"com.Thorlaigou.laigou"account:@"yahuigo"];
    if ([GB_ToolUtils isNotBlank:currentDeviceUUIDStr]) {
      return currentDeviceUUIDStr = [currentDeviceUUIDStr aci_decryptWithAES];
    }
    return @"";
}

+ (NSString *)getUUID{
    
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@"com.Thorlaigou.laigou"account:@"yahuigo"];
    if ([GB_ToolUtils isNotBlank:currentDeviceUUIDStr]) {
        return currentDeviceUUIDStr = [currentDeviceUUIDStr aci_decryptWithAES];
    }
    return @"";
}


//+ (NSString *)getSavedContent:(NSString *)currentDeviceUUIDStr uid:(NSString *)uid udid:(NSString *)udid{
//    NSString *content;
//    if (!currentDeviceUUIDStr || [currentDeviceUUIDStr isEqualToString:@""] ) {
//        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
//        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
////        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
////        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
//        content = [NSString stringWithFormat:@"%@|0",currentDeviceUUIDStr];
//        NSString *local = [content aci_encryptWithAES];
//        [SAMKeychain setPassword:local forService:@"com.Thorlaigou.laigou"account:@"yahuigo"];
//        return content;// 这种情况一般不存在
//    }
//
//    NSArray *arr = [currentDeviceUUIDStr componentsSeparatedByString:@"|"];
//    if (arr && arr[0]) {
//        NSString *first = udid!=nil?udid:arr[0];
//        NSString *mid;
//         NSString *last;
//        if ([arr[1] isEqualToString:@"1"]||udid) {
//            mid=@"|1";
//        }else{
//            mid=@"|0";
//        }
//        if (arr.count == 3) {
//            last = uid !=nil?[NSString stringWithFormat:@"|%@",uid]:[NSString stringWithFormat:@"|%@",arr[2]];
//        }else{
//            last = uid !=nil?[NSString stringWithFormat:@"|%@",uid]:@"";
//        }
//        content = [NSString stringWithFormat:@"%@%@%@",first,mid,last];
//    }
//    NSString *local = [content aci_encryptWithAES];
//    [SAMKeychain setPassword:local forService:@"com.Thorlaigou.laigou"account:@"yahuigo"];
//    return content;
//}








@end
