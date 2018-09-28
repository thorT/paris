//
//  AuthBaseInfoController.m
//  xiongmaodai
//
//  Created by thor on 2017/8/10.
//  Copyright © 2017年 gone. All rights reserved.
//

#import "XianwanVController.h"
#import "THEvaluate.h"
#import "Const.h"
#import "GB_ToolUtils.h"
#import "DataSingleton.h"
#import "Global.h"
#import "Global_ui.h"
#import "SaveImage.h"
#import "UMShareHelper.h"
#import "UMShareMode.h"
#import "BaseSetupSetting.h"
#import "VPN.h"
#import "WIFIInfo.h"
#import "HttpProxyView.h"
#import "NSString+AES.h"
#import "Arc4random.h"
#import "MBProgressHUD+BWMExtension.h"
#import <UMSocialCore/UMSocialCore.h>




@interface XianwanVController ()<WKNavigationDelegate>

@property (nonatomic, assign) BOOL taskTimeOK;
@property (nonatomic, strong) TimeLimit *timeLimit;
@property (nonatomic, assign) BOOL webLoaded;// webview 已经加载过了
@property (nonatomic, strong) NSString *VeriDevCallBack;//用户验证设备callback
@property (nonatomic, strong) NSString  *activityUrl;// 激活url



@end

@implementation XianwanVController

- (void)leftBarButtonClick{
    if (self.webView && self.webView.canGoBack) {
        [self.webView goBack];
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)cofigNav{
    self.title = self.titleText;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont systemFontOfSize:18]};
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 0, 24, 24);
    UIImage * bImage = [UIImage imageNamed:@"return"];
    [btn setBackgroundImage:bImage forState:UIControlStateNormal];

    [btn addTarget: self action: @selector(leftBarButtonClick)forControlEvents: UIControlEventTouchUpInside];
    //[btn setImage: bImage forState: UIControlStateNormal];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigNav];
  [self configWeb];
}

- (CGFloat)topH{
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    return statusRect.size.height+navRect.size.height;
}
- (CGFloat)bottomH{
    CGFloat h= [self topH];
    if (h>64) {
        h = h+20;
    }
    return h;
}

#pragma mark - 正式
- (void)configWeb{
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"Browser"];
    self.webView.navigationDelegate = self;
    self.webViewFrame = CGRectMake(0, [self topH], Screen_Width, Screen_Height-[self bottomH]);
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
    }
    [self loadWebView];
}

- (void)loadWebView{
    [self.webView loadURL_hasPostTest:self.webUrl];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"message name=%@,mssage.body=%@",message.name,message.body);
    
    NSString *selStr = [NSString stringWithFormat:@"%@:",message.name];
    SEL sel = NSSelectorFromString(selStr);
    if ([self respondsToSelector:sel]){
        SuppressPerformSelectorLeakWarning(
                                           [self performSelector:sel withObject:message];
                                           );
    }
}

- (void)Browser:(WKScriptMessage *)message{
    NSString *str = message.body[@"body"];
    if ([GB_ToolUtils isBlank:str]) {return;}

    NSLog(@"str = %@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(1)}];
}




@end






















