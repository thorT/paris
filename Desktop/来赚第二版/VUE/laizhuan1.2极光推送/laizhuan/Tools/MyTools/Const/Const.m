//
//  Const.m
//  yuecai
//
//  Created by shenghuo on 2017/12/4.
//  Copyright © 2017年 shenghuo. All rights reserved.
//

#import "Const.h"
#import "Chain.h"
#import "Global_ui.h"
#import "Arc4random.h"

@implementation Const

+ (BOOL)device_Is_iPhoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}

+ (void)alertWith:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)bid{
    return [[NSBundle mainBundle] bundleIdentifier];
}
#pragma mark - 本地数据
// 设置本地正在验证设备状态
+ (void)setVeriDev{
    [[DataSingleton sharedDataSingleton] saveLocalData:js_veriDev value:@"1"];
}
// 获取本地是否在验证设备
+ (BOOL)getVeriDev{
  NSString *str = [[DataSingleton sharedDataSingleton] getLocalData:js_veriDev];
    if ([GB_ToolUtils isNotBlank:str]) {
        return YES;
    }else{
        return NO;
    }
}
// 删除本地是否在验证设备状态
+ (void)deleteVeriDev{
    [[DataSingleton sharedDataSingleton] removeLocalData:js_veriDev];
}

+ (void)setupUID:(NSString *)uid{
    [[DataSingleton sharedDataSingleton] saveLocalData:@"uid" value:uid];
}
+ (NSString *)getUID{
    return [[DataSingleton sharedDataSingleton] getLocalData:@"uid"];
}
+ (void)setKeys:(NSString *)keys{
     [[DataSingleton sharedDataSingleton] saveLocalData:@"udid" value:keys];
    [Chain saveChainKeys:keys];
}
// 设置是用户
+ (void)setupS_is{
    [[DataSingleton sharedDataSingleton] saveLocalData:s_is value:@"1"];
}
// 获取本地是否是用户
+ (BOOL)getS_is{
    NSString *str = [[DataSingleton sharedDataSingleton] getLocalData:s_is];
    if ([GB_ToolUtils isNotBlank:str]) {
        return YES;
    }
    return NO;
}
// 删除本地用户记录
+ (void)deleteS_is{
    [[DataSingleton sharedDataSingleton] removeLocalData:s_is];
}

+ (NSString *)urlArcKey:(NSString *)url{
  long k =  [Arc4random getRandomNumber:1 to:9];
    long j =  [Arc4random getRandomNumber:1 to:9];
    NSString *str = [NSString stringWithFormat:@"%@?%ld=%ld",url,k,j];
    return str;
}

#pragma mark - 工具
+ (void)addBGImageV:(UIView *)view imageName:(NSString *)imageName{
    NSString *temp;
    if (Screen_Height<=480) {
        temp = @"44";
    }else if (Screen_Height<=568) {
        temp = @"55";
    }else if (Screen_Height<=667) {
        temp = @"66";
    }else if (Screen_Height<=1104) {
        temp = @"66p";
    }else{
        temp = @"XX";
    }
    imageName = [NSString stringWithFormat:@"%@%@",imageName,temp];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageV.backgroundColor = [UIColor redColor];
    imageV.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageV];
}
+ (void)gradientBg:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBCOLOR(253, 112, 73).CGColor, (__bridge id)RGBCOLOR(253, 168, 106).CGColor, (__bridge id)RGBCOLOR(253, 169, 144).CGColor];
    gradientLayer.locations = @[@0.1, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer addSublayer:gradientLayer];
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (NSDictionary *)urlParam:(NSString *)url{
    NSArray *arr = [url componentsSeparatedByString:@"?"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (arr&&arr.count==2) {
        NSString *paramStr = arr[1];
        NSArray *param = [paramStr componentsSeparatedByString:@"&"];
        for (int i = 0; i<param.count; i++) {
            NSString *tip = param[i];
            NSArray*tipArr = [tip componentsSeparatedByString:@"="];
            [dic setObject:tipArr[1] forKey:tipArr[0]];
        }
    }
    return dic;
}


/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = data;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}


- (void)dispatchTime{
    // 延时调激活接口
    Weakify(self);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        Strongify(weakSelf);
        // 调激活接口 -war
    });
}


@end
