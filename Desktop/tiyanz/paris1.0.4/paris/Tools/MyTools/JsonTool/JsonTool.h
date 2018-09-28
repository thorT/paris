//
//  JsonTool.h
//  jsonTool
//
//  Created by 张明伟 on 15/4/29.
// 技术联系   920606042@qq.com
//  Copyright (c) 2015年 ebeijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonTool : NSObject
+(NSString *)jsonStrFrom:(id)obj;
+(NSDictionary *)jsonDicFrom:(NSData *)data;
+(NSArray *)jsonArrFrom:(NSData *)data;
+(NSData *)jsonDataFromDic:(NSDictionary *)dic;
+(NSData *)jsonDataFromArr:(NSArray *)arr;
/** json字符串转字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
