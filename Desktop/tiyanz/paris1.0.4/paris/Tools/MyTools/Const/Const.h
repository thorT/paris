//
//  Const.h
//  shenghuo
//
//  Created by shenghuo on 2017/12/4.
//  Copyright © 2017年 shenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Const : NSObject

/** 本地 */
+ (BOOL)DataSHas:(NSString *)key;
+ (id)DataSGet:(NSString*)key;
+ (void)DataSSet:(NSString*)key value:(id)value;
+ (void)DataSDel:(NSString*)key;

+ (NSString *)utf8:(NSString *)str;

// 判断应用是在前台还是后台
+(BOOL) runningInBackground;
+(BOOL) runningInForeground;

// 判断设备
+ (float)getIOSVersion;
+ (BOOL)device_Is_iPhoneX;
+ (NSString *)appVersion;
+ (NSString *)appName;
+ (NSString *)appBid;
+ (CGFloat)AdaptedY;

// 小方法
+ (NSString *)UTF8Encoding:(NSString *)str;
+ (NSDictionary *)urlParam:(NSString *)url;
+ (NSString *)hidePhoneNuber:(NSString*)number;
+ (NSString *)stringValue:(id)value;
+ (NSString *)stringMoneyValue:(id)value;
+ (NSString *)urlArcKey:(NSString *)url;


// 页面
+ (void)gradientBg:(UIView *)view;
+ (void)alertWith:(NSString *)message;
+ (void)alertWith:(NSString *)message vc:(UIViewController *)vc;
+ (void)alertWith:(NSString *)message sureText:(NSString *)sureText cancelText:(NSString *)cancelText vc:(UIViewController *)vc click:(void(^)(NSInteger index))clickIndex;
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (NSMutableAttributedString *)attributedString:(NSString *)str1 dic1:(NSDictionary *)dic1 str2:(NSString *)str2 dic2:(NSDictionary *)dic2;
+ (void)addBGImageV:(UIView *)view imageName:(NSString *)imageName;
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;
+ (void)addBorderDashWith:(UIView *)view color:(UIColor *)color;
+ (NSMutableURLRequest *)wkwebLoadCookieRequest:(NSString *)url;

/** 时间转换 */
+(NSString *)timestampSwitchTime:(NSInteger)timestamp format:(NSString *)format;

@end



