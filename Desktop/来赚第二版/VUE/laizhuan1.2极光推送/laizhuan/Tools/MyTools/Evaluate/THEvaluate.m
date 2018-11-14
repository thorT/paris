//
//  THEvaluate.m
//  laizhuanJP
//
//  Created by thor on 2016/11/4.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "THEvaluate.h"
#import "JsonTool.h"
//#import "NetRequestClass.h"

@implementation THEvaluate

+ (void)evaluateTip:(NSString *)tip WebView:(WKWebView *)webView method:(NSString *)method dic:(NSDictionary *)dic{
    if (!webView|| !dic || !method) {NSLog(@"错误 tip=%@ webView=%@ dic== %@ method== %@",tip,webView,dic,method);return;}
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mut setObject:method forKey:@"callback"];
    NSString *render = [NSString stringWithFormat:@"%@(%@)",@"_getFromIOS",[JsonTool jsonStrFrom:mut]];
  //  NSString *render = [NSString stringWithFormat:@"%@(%@)",method,[JsonTool jsonStrFrom:dic]];
    
    [webView evaluateJavaScript:render completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
            NSLog(@"错误 tip=%@ dic== %@ method== %@ item = %@,error = %@",tip,dic,method,item,error.userInfo);
        }
    }];
    
   // NSLog(@"evluateTip=%@ dic== %@ method== %@",tip,[JsonTool jsonStrFrom:dic],method);
    
}

+ (void)evaluateTip:(NSString *)tip WebView:(WKWebView *)webView method:(NSString *)method string:(NSString *)string{
    if (!webView || !string || !method) {NSLog(@"错误 tip=%@ webView=%@ string== %@ method== %@",tip,webView,string,method);return;}
    NSString *render = [NSString stringWithFormat:@"%@(%@)",method,string];
    [webView evaluateJavaScript:render completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
            NSLog(@"错误 tip=%@ string== %@ method== %@ item = %@,error = %@",tip,string,method,item,error.localizedDescription);
        }
    }];
}

+ (void)evaluateTip:(NSString *)tip WebView:(WKWebView *)webView method:(NSString *)method num:(NSNumber *)num{
    if (!webView || !num || !method) {NSLog(@"错误 evluate tip=%@ webView=%@ num== %@ method== %@",tip,webView,num,method);return;}
    NSString *render = [NSString stringWithFormat:@"%@(%@)",method,num];
    [webView evaluateJavaScript:render completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
            NSLog(@"错误 tip=%@ num== %@ method== %@ item = %@,error = %@",tip,num,method,item,error.localizedDescription);
        }
    }];
}

#pragma mark - 网络请求回调
// 成功
+ (void)requestSuccessTip:(NSString *)tip WebView:(WKWebView *)webView data:(NSDictionary *)data callBack:(NSString *)callBack{
    [self evaluateTip:tip WebView:webView method:callBack dic:data];
}

+ (void)requestAbnormalTip:(NSString *)tip WebView:(WKWebView *)webView data:(NSDictionary *)errorCode callBack:(NSString *)callBack{
    NSDictionary *dic = [self netRequstNotExpectedData:errorCode];
    [self evaluateTip:tip WebView:webView method:callBack dic:dic];
}

//// 错误
//- (void)requestErrorTip:(NSString *)tip WebView:(THWebView *)webView data:(NSDictionary *)data callBack:(NSString *)callBack{
//    NSString *msg = data[@"msg"] != nil? data[@"msg"]: @"";
//    [self evluateTip:tip WebView:webView method:callBack dic:@{@"errcode":@2,@"msg":msg}];
//}
//// 失败
//- (void)requestFailureTip:(NSString *)tip WebView:(THWebView *)webView data:(NSString *)errorMsg callBack:(NSString *)callBack{
//    NSDictionary *dic = [self netRequstNotExpectedData:nil];
//    [self evluateTip:tip WebView:webView method:callBack dic:dic];
//}
// 网络错误或者失败默认数据 errorCode表示服务器返回 status ！= 10
//+ (NSDictionary *)netRequstNotExpectedData:(NSDictionary *)errorCode{
//    NSDictionary *dic;
//    if (![NetRequestClass netWorkStatusClear]) {
//        dic = @{@"errcode":@0};
//    }else if(errorCode){
//        NSString *msg = errorCode[@"msg"] != nil? errorCode[@"msg"]: @"";
//        dic = @{@"errcode":@2,@"msg":msg};
//    }else{
//        dic = @{@"errcode":@1};
//    }
//    return dic;
//}







@end








