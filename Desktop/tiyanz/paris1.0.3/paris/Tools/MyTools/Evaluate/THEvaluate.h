//
//  THEvaluate.h
//  laizhuanJP
//
//  Created by thor on 2016/11/4.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface THEvaluate : NSObject

///** add loading */
//+ (void)evaluateAddLoadingTip:(NSString *)tip WebView:(WKWebView *)webView;

///** remove loading */
//+ (void)evaluateRemoveLoadingTip:(NSString *)tip WebView:(WKWebView *)webView;

+ (void)evaluateTip:(NSString *)tip WebView:(WKWebView *)webView method:(NSString *)method dic:(NSDictionary *)dic;

+ (void)evaluateTip:(NSString *)tip WebView:(WKWebView *)webView method:(NSString *)method string:(NSString *)string;

+ (void)evaluateTip:(NSString *)tip WebView:(WKWebView *)webView method:(NSString *)method num:(NSNumber *)num;

#pragma mark - 网络请求回调
/** 成功 */
+ (void)requestSuccessTip:(NSString *)tip WebView:(WKWebView *)webView data:(NSDictionary *)data callBack:(NSString *)callBack;

/** 网络返回不正常 */
+ (void)requestAbnormalTip:(NSString *)tip WebView:(WKWebView *)webView data:(NSDictionary *)errorCode callBack:(NSString *)callBack;
///** 错误 */
//- (void)requestErrorTip:(NSString *)tip WebView:(THWebView *)webView data:(NSDictionary *)data callBack:(NSString *)callBack;
///** 失败 */
//- (void)requestFailureTip:(NSString *)tip WebView:(THWebView *)webView data:(NSString *)errorMsg callBack:(NSString *)callBack;
/** 网络错误或者失败数据 errorCode表示服务器返回 status ！= 10*/
+ (NSDictionary *)netRequstNotExpectedData:(NSDictionary *)errorCode;

@end
