//
//  THWebView.h
//  laizhuanJP
//
//  Created by thor on 2016/10/21.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface THWKWebView : WKWebView


@property (nonatomic, copy) void(^reloadClickBlock)(void);

@property (nonatomic, copy) void(^closeClickBlock)(void);

@property (nonatomic, assign) BOOL closeShow;

/** 固定 */
- (void)fixed;

///** 加载本地html */
//- (void)loadHtmlName:(NSString *)htmlName;

///** 加载本地并强制更新 */
//- (void)loadHtmlNameForceUpdate:(NSString *)htmlName;

/** 加载本地Bundle */
- (void)loadBundleHtmlName:(NSString *)htmlName;


/** 加载某个地址 */
- (void)loadURL:(NSString *)urlString;

/** 加载某个地址并测试403、404 */
- (void)loadURL_hasPostTest:(NSString *)urlString;

/** 加载失败 */
- (void)loadFailure;

/** 加载中 */
- (void)loading;

/** 加载完成 */
- (void)loadFinished;



@end
