//
//  Const.m
//  yuecai
//
//  Created by shenghuo on 2017/12/4.
//  Copyright © 2017年 shenghuo. All rights reserved.
//

#import "Const.h"




@implementation Const

#pragma mark - 数据

/** 获取 */
+ (BOOL)DataSHas:(NSString *)key{
    NSString *value = [[DataSingleton sharedDataSingleton] getLocalData:key];
    if ([GB_ToolUtils isNotBlank:value]) {
        return YES;
    }else{
        return NO;
    }
}
+ (id)DataSGet:(NSString*)key{
    
     NSString*val = [[DataSingleton sharedDataSingleton] getLocalData:key];
    if ([GB_ToolUtils isNotBlank:val]) {
        return val;
    }else{
        return @"";
    }
}
+ (void)DataSSet:(NSString*)key value:(id)value{
    [[DataSingleton sharedDataSingleton] saveLocalData:key value:value];
}
+ (void)DataSDel:(NSString*)key{
    [[DataSingleton sharedDataSingleton] removeLocalData:key];
}

+ (NSString *)UTF8Encoding:(NSString *)str{
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)utf8:(NSString *)str{
    if ([GB_ToolUtils isNotBlank:str]) {
       return  [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}

#pragma mark - 判断应用是在前台还是后台
+(BOOL) runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}
+(BOOL) runningInForeground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}

+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+ (BOOL)device_Is_iPhoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (NSString *)appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 版本
    NSString *appVer = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVer;
}
+ (NSString *)appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"]!= nil?[infoDictionary objectForKey:@"CFBundleDisplayName"]:@"";
    return appName;
}
+ (NSString *)appBid{
    return [[NSBundle mainBundle] bundleIdentifier];
}
+ (CGFloat)AdaptedY{
    if ([Const device_Is_iPhoneX]) {
        return 88;
    }else{
        return 64;
    }
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

#pragma mark - UI
+ (void)gradientBg:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBCOLOR(253, 112, 73).CGColor, (__bridge id)RGBCOLOR(253, 168, 106).CGColor, (__bridge id)RGBCOLOR(253, 169, 144).CGColor];
    gradientLayer.locations = @[@0.1, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer addSublayer:gradientLayer];
}

+ (void)alertWith:(NSString *)message vc:(UIViewController *)vc{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    [vc presentViewController:alert animated:YES completion:nil];
}
+ (void)alertWith:(NSString *)message sureText:(NSString *)sureText cancelText:(NSString *)cancelText vc:(UIViewController *)vc click:(void(^)(NSInteger index))clickIndex{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        clickIndex(1);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        clickIndex(0);
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertWith:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (NSMutableAttributedString *)attributedString:(NSString *)str1 dic1:(NSDictionary *)dic1 str2:(NSString *)str2 dic2:(NSDictionary *)dic2{
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:str1 attributes:dic1];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:dic2];
    [attributedString2 insertAttributedString:attributedString1 atIndex:0];
    return attributedString2;
}

+ (NSMutableURLRequest *)wkwebLoadCookieRequest:(NSString *)url{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    //Cookies数组转换为requestHeaderFields
    NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //设置请求头
    request.allHTTPHeaderFields = requestHeaderFields;
    return request;
}
+ (NSString *)stringValue:(id)value{
    return [NSString stringWithFormat:@"%@",value];
}
+ (NSString *)stringMoneyValue:(id)value{
    if ([GB_ToolUtils isNotBlank:value]) {
        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
    }else{
        return @"0.00";
    }
}

#pragma mark - 工具
// 隐藏手机号
+ (NSString *)hidePhoneNuber:(NSString*)number{
    if (number.length == 11) {//如果是手机号码的话
        
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        return numberString;
        
    }
    return number;
}

+ (NSString *)urlArcKey:(NSString *)url{
    NSString *tmp = [self getCurrentTime];
    NSString *str = [NSString stringWithFormat:@"%@?tmp=%@",url,tmp];
    return str;
}
+ (NSString*)getCurrentTime {// 获取当前时间戳
    NSDate*datenow = [NSDate date];
    NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

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

#pragma mark - 将某个时间戳转化成 时间
+(NSString *)timestampSwitchTime:(NSInteger)timestamp format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
+ (void)addBorderDashWith:(UIView *)view color:(UIColor *)color{
    CGFloat viewWidth = view.bounds.size.width;
    CGFloat viewHeight = view.bounds.size.height;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, viewWidth, viewHeight);
    borderLayer.position = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    //  borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:10].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@8, @8];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = color.CGColor;
    [view.layer addSublayer:borderLayer];
}

@end
