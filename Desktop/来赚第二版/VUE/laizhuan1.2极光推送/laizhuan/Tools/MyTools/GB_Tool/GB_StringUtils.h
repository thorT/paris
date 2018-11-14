//
//  GB_StringUtils.h
//  GeekBean4IOS
//
//  Created by GaoHang on 12-11-28.
//
//

#import <Foundation/Foundation.h>

@interface GB_StringUtils : NSObject

//是否为空
+(BOOL)isEmpty:(NSString *)str;

//是否为空白
+(BOOL)isBlank:(NSString *)str;

//是否不为空
+(BOOL)isNotEmpty:(NSString *)str;

//是否不为空白
+(BOOL)isNotBlank:(NSString *)str;

//是否为数字
+(BOOL)isNumeric:(NSString *)str;

//分割字符串
+(NSArray *)split:(NSString *)src separator:(NSString *)separator;



+(BOOL)isString:(NSString *)str;

@end
