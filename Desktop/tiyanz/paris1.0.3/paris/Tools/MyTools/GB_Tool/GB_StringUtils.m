//
//  GB_StringUtils.m
//  GeekBean4IOS
//
//  Created by GaoHang on 12-11-28.
//
//

#import "GB_StringUtils.h"
#import "GB_ToolUtils.h"

@implementation GB_StringUtils

/**
 *	@brief	判断是否空字符串
 *
 *	@param 	str 	要判断字符串
 *
 *	@return	返回BOOL值
 */
+(BOOL)isEmpty:(NSString *)str
{
    if([GB_ToolUtils isBlank:str])return YES;
    if(![GB_StringUtils isString:str])return YES;
    return str.length == 0;
}

+(BOOL)isNotEmpty:(NSString *)str{
    return ![self isEmpty:str];
}

/**
 *	@brief	字符串是否是空白
 *
 *	@param 	str 	字符串
 *
 *	@return	返回BOOL值
 */
+(BOOL)isBlank:(NSString *)str
{
    if([GB_ToolUtils isBlank:str])return YES;
    if(![GB_StringUtils isString:str])return YES;
    for(int i = 0; i < str.length; i++){
        if([[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "]==NO){
            return NO;
        }
    }
    return YES;
}

/**
 *	@brief	判断是不是字符串类
 *
 *	@param 	str 	字符串
 *
 *	@return	返回BOOL值
 */
+(BOOL)isString:(NSString *)str
{
    return [str isKindOfClass:[NSString class]]||str == nil;
}

+(BOOL)isNotBlank:(NSString *)str{
    return ![self isBlank:str];
}

/**
 *	@brief	判断字符串仅包含数字
 *
 *	@param 	str 	字符串
 *
 *	@return	返回BOOL值
 */
+(BOOL)isNumeric:(NSString *)str
{
    if([GB_ToolUtils isBlank:str])return YES;
    if(![GB_StringUtils isString:str])return NO;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [str isEqualToString:filtered];
}

/**
 *	@brief	返回将字符串分割后的数组
 *
 *	@param 	src 	字符串
 *	@param 	separator 	分割的字符
 *
 *	@return	返回数组
 */
+(NSArray *)split:(NSString *)src separator:(NSString *)separator
{
    if([self isEmpty:src])return nil;
    if([self isEmpty:separator])return nil;
    if(src == nil || separator == nil || src.length == 0 || separator.length == 0)return [NSArray array];
    return [src componentsSeparatedByString:separator];
}


@end
