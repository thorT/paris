//
//  Const.h
//  shenghuo
//
//  Created by shenghuo on 2017/12/4.
//  Copyright © 2017年 shenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Const : NSObject


+ (BOOL)device_Is_iPhoneX;

+ (void)alertWith:(NSString *)message;

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSDictionary *)urlParam:(NSString *)url;

+ (NSString *)bid;
// 本地参数
+ (void)setupUID:(NSString *)uid;
+ (NSString *)getUID;
+ (void)setKeys:(NSString *)keys;
// 设置本地正在验证设备状态
+ (void)setVeriDev;
// 获取本地是否在验证设备
+ (BOOL)getVeriDev;
// 删除本地是否在验证设备状态
+ (void)deleteVeriDev;
// 设置是用户
+ (void)setupS_is;
// 获取本地是否是用户
+ (BOOL)getS_is;
// 删除本地用户记录
+ (void)deleteS_is;


// url
+ (NSString *)urlArcKey:(NSString *)url;


/**
 *  添加背景图
 */
+ (void)addBGImageV:(UIView *)view imageName:(NSString *)imageName;

/**
 *  添加渐变背景色
 */
+ (void)gradientBg:(UIView *)view;
/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;



@end



