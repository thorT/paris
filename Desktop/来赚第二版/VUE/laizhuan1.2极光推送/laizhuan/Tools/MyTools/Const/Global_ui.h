//
//  HtmlAPI.h
//  laigou
//
//  Created by thor on 2016/11/25.
//  Copyright © 2016年 thor. All rights reserved.
//

#ifndef Global_ui_h
#define Global_ui_h


#pragma mark js与oc 交互


//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x)            [UIFont systemFontOfSize:x]//[UIFont fontWithName:CHINESE_FONT_NAME size:x]
#define CHINESE_SYSTEMWeight(x)      [UIFont systemFontOfSize:x weight:0.45]
#define kScreenWidthRatio            (Screen_Width / 375.0) //375
#define kScreenHeightRatio           (Screen_Height / 667.0) //667
#define AdaptedWidth(x)              ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)             ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)           CHINESE_SYSTEM(AdaptedWidth(R))
#define AdaptedFontSizeWeight(R)     CHINESE_SYSTEMWeight(AdaptedWidth(R))
// 加粗
#define CHINESE_SYSTEMBold(x)      [UIFont boldSystemFontOfSize:x]
#define AdaptedFontSizeBold(R)     CHINESE_SYSTEMBold(AdaptedWidth(R))

#define SizeScale (Screen_Width != 414 ? 1 : 1.2)
#define kFont(value) [UIFont systemFontOfSize:value * SizeScale]

//屏幕宽度
#define Screen_Width [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define Screen_Height [UIScreen mainScreen].bounds.size.height

// 当前版本
#define IOS_Version  [[[UIDevice currentDevice] systemVersion] floatValue]

//登录记录
#define loginRecord @"http://www.dijiadijia.com/face.php"

// 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define g_darkRed RGBCOLOR(253,112,72)
#define g_grey RGBCOLOR(153,153,153)

#endif /* Global_ui_h */










