//
//  UMShare.h
//  laigou
//
//  Created by thor on 2016/12/9.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMShareMode.h"

typedef void (^ShareBack) (BOOL success, NSString *msg);

@interface UMShareHelper : NSObject

/** 初始化友盟分享及各个平台参数 */
+ (void)initUMShare;


/** 是否安装QQ */
+ (BOOL)isQQInstalled;

/** 是否安装新浪微博 */
+ (BOOL)isSinaInstalled;

/** 是否安装微信 */
+ (BOOL)isWXInstalled;

/**  弹出分享面板 */
+ (void)shareMenu:(UIViewController *)viewController model:(UMShareMode *)model block:(ShareBack)block;

// 0,微信；1.微信空间；2.QQ；3.QQ空间；4.新浪
+ (void)shareMenu:(UIViewController *)viewController model:(UMShareMode *)model type:(int)type block:(ShareBack)block ;

/** 分享到QQ */
+ (void)shareToQQ:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback;
/** 分享到QQ空间 */
+ (void)shareToQQZone:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback;
/** 分享到微信 */
+ (void)shareToWX:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback;
/** 分享到微信朋友圈 */
+ (void)shareToWXZone:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback;
/** 分享到新浪微博 */
+ (void)shareToSina:(UIViewController *)viewController model:(UMShareMode *)model callback:(ShareBack)callback;



@end
