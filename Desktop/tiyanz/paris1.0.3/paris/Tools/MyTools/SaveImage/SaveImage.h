//
//  SaveImage.h
//  laizhuan
//
//  Created by thor on 2018/5/29.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef enum {
    SaveNetImage=0,    //网络图片
    SaveUrlToQRImage,  //保存网络url成二维码
} SaveImageType;
typedef void (^SaveImageAuth)(bool agree);
typedef void (^SaveImageBlock)(int type, NSString *msg);  //1.1成功，2.失败;msg 失败原因


@interface SaveImage : NSObject

@property (nonatomic,assign) SaveImageType saveImageType;

// 申请权限
+ (void)saveImageAuth:(SaveImageAuth)auth;

-(void)saveImage:(UIImage *)image block:(SaveImageBlock)block;

-(void)saveUrlQRImage:(NSString *)url block:(SaveImageBlock)block;

-(void)saveFullScreenWithView:(WKWebView *)webView block:(SaveImageBlock)block;


@end
