//
//  GB_ToolUtils.m
//  GeekBean4IOS
//
//  Created by GaoHang on 12-11-28.
//
//

#import "GB_ToolUtils.h"
#import "GB_StringUtils.h"

@implementation GB_ToolUtils

/**
 *	@brief	判断对象是否为空、NULL、nil
 *
 *	@param 	obj 	对象
 *
 *	@return	返回BOOL值
 */
+(BOOL)isBlank:(id)obj
{
    if(obj == [NSNull null] || obj == nil)return YES;
    if([obj isKindOfClass:[NSArray class]])
        return [obj count]==0;
    if([obj isKindOfClass:[NSMutableArray class]])
        return [obj count]==0;
    if([obj isKindOfClass:[NSDictionary class]])
        return [obj count]==0;
    if([obj isKindOfClass:[NSMutableDictionary class]])
        return [obj count]==0;
    if([obj isKindOfClass:[NSData class]])
        return [obj length]==0;
    if([obj isKindOfClass:[NSString class]])
        return [obj length]==0;
    return NO;
}

+(BOOL)isNotBlank:(id)obj{
    return ![self isBlank:obj];
}

/**
 *	@brief	判断对象是不是Null
 *
 *	@param 	obj 	对象
 *
 *	@return	返回BOOL值
 */
+(BOOL)isNull:(id)obj
{
    if(obj == [NSNull null] || obj == nil)return YES;
    return NO;
}

+(BOOL)isNotNull:(id)obj{
    return ![self isNull:obj];
}

//+(float)getFontHeight:(UIFont *)font{
//    return [@"1" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)].height;
//}
//
///**
// *	@brief	获取字符串在指定的size内(宽度超过150,则换行)所需的的实际高度和宽度.
// *
// *	@param 	text 	文本
// *	@param 	font 	字体大小
// *	@param 	size 	指定Size
// *
// *	@return	返回实际的size
// */
//+(CGSize)getTextSize:(NSString *)text font:(UIFont *)font size:(CGSize)size
//{
//    if([GB_StringUtils isBlank:text])return CGSizeZero;
//    if([GB_ToolUtils isBlank:font])return CGSizeZero;
//    return [text sizeWithFont:font constrainedToSize:size];
//}
//
//+(float)getTextWidth:(NSString *)text font:(UIFont *)font size:(CGSize)size{
//    if([GB_StringUtils isBlank:text])return 0;
//    if([GB_ToolUtils isBlank:font])return 0;
//    CGSize s = [text sizeWithFont:font constrainedToSize:size];
//    return s.width;
//}

//+(float)getTextHeight:(NSString *)text font:(UIFont *)font size:(CGSize)size{
//    if([GB_StringUtils isBlank:text])return 0;
//    if([GB_ToolUtils isBlank:font])return 0;
//    CGSize s = [text sizeWithFont:font constrainedToSize:size];
//    return s.height;
//}

@end
