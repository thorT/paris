//
//  BaseWKWebController.m
//  laigou
//
//  Created by thor on 2016/12/12.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "BaseWKWebViewController.h"
#import "Global.h"


#define IsNull(s) (!s || [s isKindOfClass:[NSNull class]])


@interface BaseWKWebViewController ()<UIGestureRecognizerDelegate,WKScriptMessageHandler,WKNavigationDelegate>


@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) WKWebViewConfiguration *configuration;


@end

@implementation BaseWKWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([GB_ToolUtils isBlank:self.webView.title]) {
        [self.webView reload];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏颜色
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 创建返回按钮
    [self creatBackBtn];
    
    // 创建webView
    [self creatConfig];
    
    // 创建轻扫手势
    //  [self setupSwipeGesture];
    
    self.fisrtLaunch = YES;
}

- (void)creatConfig{
    // 创建配置
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    self.userContentController = [[WKUserContentController alloc] init];
    self.configuration = [[WKWebViewConfiguration alloc] init];
    self.configuration.userContentController = self.userContentController;
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    //    [self.userContentController addScriptMessageHandler:self name:kPage_to];
        
    // 创建WKWebView
    self.webView = [[THWKWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) configuration:self.configuration];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    
   // self.webView.scrollView.scrollEnabled = NO;
   self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    
    if (@available(iOS 11.0, *)) {
        
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{

        }
}

//- (void)setupSwipeGesture{
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe)];
//    swipe.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipe];
//}

//- (void)swipe{
//    if (![self.navigationController.visibleViewController isKindOfClass:[HomeViewController class]]) {
//        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"不 是 home");
//    }
//}

- (void)dealloc{
    
    
}
- (void)setWebViewFrame:(CGRect)webViewFrame{
    _webViewFrame = webViewFrame;
    _webView.frame = webViewFrame;
}


- (void)creatBackBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_retrun"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)leftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark - navigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    if (self.fisrtLaunch) {
    [self.webView loading];
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailProvisionalNavigation");
    if (self.fisrtLaunch) {
        [self.webView loadFailure];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailNavigation");
    if (self.fisrtLaunch) {
        [self.webView loadFailure];
    }
}

//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    NSLog(@"didCommitNavigation");
//}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    if (self.fisrtLaunch) {
        self.fisrtLaunch = NO;
        [self.webView loadFinished];
    }
}

//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    // 类似 UIWebView 的- webView:didFailLoadWithError:
//
//    NSLog(@"didFailProvisionalNavigation");
//
//}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}
//
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
//
//
//  decisionHandler(WKNavigationActionPolicyAllow);
//
//
//
//}
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
//
//}


#pragma mark - UIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"runJavaScriptAlertPanelWithMessage");
    [self alertWithMessage:message];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    completionHandler(NO);
}

- (void)alertWithMessage:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler
//{    // js 里面的alert实现，如果不实现，网页的alert函数无效
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
//                                                                             message:nil
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
//                                                        style:UIAlertActionStyleCancel
//                                                      handler:^(UIAlertAction *action) {
//                                                          completionHandler(@"");
//                                                      }]];
//
//    [self presentViewController:alertController animated:YES completion:^{}];
//
//    completionHandler(@"");
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
//
//
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
//
//    completionHandler(@"Client Not handler");
//
//}








@end




@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end






















