//
//  JsonTool.m
//  jsonTool
//
//  Created by ebeijia on 15/4/29.
//  Copyright (c) 2015年 ebeijia. All rights reserved.
//

#import "JsonTool.h"
#import "GB_ToolUtils.h"

@implementation JsonTool
//obj to jsonString;
+(NSString *)jsonStrFrom:(id)obj{
    if ([GB_ToolUtils isBlank:obj]) {
        return obj;
    }
    //预防性判断
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    
    // 转化
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length>0&&error==nil) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            return jsonStr;
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }
}
//jsonData to Dic
+(NSDictionary *)jsonDicFrom:(NSData *)data{
    if ([GB_ToolUtils isBlank:data]) {
        return nil;
    }
    NSError *error;
    NSDictionary * obj = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (obj != nil && error == nil) {
        return obj;
    }else{
        return nil;
    }
}
//jsonData to array
+(NSArray *)jsonArrFrom:(NSData *)data{
    if ([GB_ToolUtils isBlank:data]) {
        return nil;
    }
    NSError *error;
    NSArray* obj = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (obj != nil && error == nil) {
        return obj;
    }else{
        return nil;
    }
}

//Dic to jsonData
+(NSData *)jsonDataFromDic:(NSDictionary *)dic{
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length>0&&error==nil) {
            return jsonData;
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }
}
//Arr to jsonData
+(NSData *)jsonDataFromArr:(NSArray *)arr{
    if ([NSJSONSerialization isValidJSONObject:arr]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length>0&&error==nil) {
            return jsonData;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

// json字符串转为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    if ([jsonString isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)jsonString;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
