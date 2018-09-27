//
//  GB_ToolUtils.h
//  GeekBean4IOS
//
//  Created by GaoHang on 12-11-28.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GB_ToolUtils : NSObject

//是否为空白对象
+(BOOL)isBlank:(id)obj;

//是否不为空白对象
+(BOOL)isNotBlank:(id)obj;

//是否为空对象
+(BOOL)isNull:(id)obj;

//是否不为空对象
+(BOOL)isNotNull:(id)obj;

//获取字体高度
//+(float)getFontHeight:(UIFont *)font;
//
////获取文字size
//+(CGSize)getTextSize:(NSString *)text font:(UIFont *)font size:(CGSize)size;
//
////获取文字宽度
//+(float)getTextWidth:(NSString *)text font:(UIFont *)font size:(CGSize)size;
//
////获取文字高度
//+(float)getTextHeight:(NSString *)text font:(UIFont *)font size:(CGSize)size;



@end
