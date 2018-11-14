//
//  AuthBaseInfoController.m
//  xiongmaodai
//
//  Created by thor on 2017/8/10.
//  Copyright © 2017年 gone. All rights reserved.
//

#import "HomeViewController.h"
#import "THEvaluate.h"
#import "Const.h"
#import "GB_ToolUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "DeviceParam.h"
#import "JsonTool.h"
#import "chain.h"
#import "DataSingleton.h"
#import "Enc.h"
#import "TimeLimit.h"
#import "Global.h"
#import "Global_ui.h"
#import "SaveImage.h"
#import "UMShareHelper.h"
#import "UMShareMode.h"
#import "WXLogin.h"
#import "BaseSetupSetting.h"
#import "VPN.h"
#import "WIFIInfo.h"
#import "HttpProxyView.h"
#import "NSString+AES.h"
#import "Arc4random.h"
#import "MBProgressHUD+BWMExtension.h"

#import <UMSocialCore/UMSocialCore.h>

@interface HomeViewController ()<WKNavigationDelegate>

@property (nonatomic, assign) BOOL taskTimeOK;
@property (nonatomic, strong) TimeLimit *timeLimit;
@property (nonatomic, assign) BOOL webLoaded;// webview 已经加载过了
@property (nonatomic, strong) HttpProxyView *httpProxyView;//检测vpn 和 代理
@property (nonatomic, strong) NSString *VeriDevCallBack;//用户验证设备callback
@property (nonatomic, assign) BOOL firstTestNet;//第一次检测网络
@property (nonatomic, assign) BOOL firstLoadVC;//第一次启动
@property (nonatomic, strong) NSString  *activityUrl;// 激活url

@end

@implementation HomeViewController



- (HttpProxyView *)httpProxyView{
    if (!_httpProxyView) {
        _httpProxyView = [[HttpProxyView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _httpProxyView.hidden = YES;
        [self.view addSubview:_httpProxyView];
    }
    [self.view bringSubviewToFront:_httpProxyView];
    return _httpProxyView;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    [self ajustSetting];
    
    // 判定用户是否在验证设备
    if ([Const getVeriDev]) {
        [self getKeysByServer];
    }
}

- (void)ajustSetting{
    if (self.firstLoadVC) {
        self.firstLoadVC = NO;
        return;
    }
    [BaseSetupSetting baseSetupSetting:^(BOOL vpn, BOOL proxy) {
        [self.httpProxyView isVPN:vpn isHttpProxy:proxy];
        
        // 如果用户未曾请求过接口
        if (!self.isProxy&&!vpn&&self.firstTestNet) {
            [self netWorkReachability];
        }
    }];
    
    if ([GB_ToolUtils isBlank:self.webView.title]&&self.fisrtLaunch == NO) {
        [self loadWebView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTestNet = YES;
    self.firstLoadVC = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(s_activityUrl) name:s_activityUrl object:nil];
    [Const gradientBg:self.view];
    
    [BaseSetupSetting baseSetupSetting:^(BOOL vpn, BOOL proxy) {
        [self.httpProxyView isVPN:vpn isHttpProxy:proxy];
        // 先判定vpn再联网
        if (!self.isProxy&&!vpn) {
            [self netWorkReachability];
        }
    }];
    
  // [Chain deleteChain];
}

- (void)activityBtn{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(Screen_Width/2-AdaptedWidth(180)/2, Screen_Height/2-AdaptedHeight(35)/2, AdaptedWidth(180), AdaptedHeight(35));
    [btn setTitle:@"前往激活" forState:UIControlStateNormal];
    btn.titleLabel.font = AdaptedFontSize(14);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = RGBCOLOR(253, 112, 72);
    btn.layer.cornerRadius = AdaptedHeight(35)/2;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(activitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)activitAction{
    if ([GB_ToolUtils isNotBlank:self.activityUrl]) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.activityUrl]];
    }
}

- (void)s_activityUrl{
    [Const setupS_is];
    [self setup];
}

- (void)setup{
    if (self.webLoaded) {
        [self loadWebView];
        return;
    }
    self.webLoaded = YES;
    
    [self configWeb];
    // 监听任务
    self.timeLimit = [[TimeLimit alloc] init];
}

-(void)netWorkReachability{
    //
    NSString *AppFirstInstall = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppFirstInstall"];
    
    BOOL is = [Const getS_is];
    if (is) {
        [self setup];
    }else if(!is&&AppFirstInstall){
        [self activityPort];
    }
    // 为保护用户隐私，如果用户不同意访问网络，就不访问网络
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.firstTestNet = NO;
        if((status == AFNetworkReachabilityStatusReachableViaWWAN|| status == AFNetworkReachabilityStatusReachableViaWiFi)&&!AppFirstInstall){
            // 第一次安装，用户同意了使用网络
            // 吊起激活接口 -war
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"AppFirstInstall"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 请求接口
            [self activityPort];
        }else if(status != AFNetworkReachabilityStatusReachableViaWWAN && status != AFNetworkReachabilityStatusReachableViaWiFi&&AppFirstInstall){
            // 保存用户并没有联网的状态
            [Const alertWith:@"网络未连接，请至☞“手机设置”中打开app网络"];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 正式
- (void)configWeb{
    // 监听
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_openApp];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_openUrl];
    //客服
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_service];
    // 任务
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_taskTime];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_startTask];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_finishTask];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_resetTask];
    // 本地
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_veriDev];
    // 网络
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_net];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_netFull];
    // 剪贴板
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_getPasteboard];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_setPasteboard];
    // 保存图片到本地
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_saveQRUrlImage];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_saveFullScreen];
    
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_share];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_wxLogin];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_curVer];
    
    //
    self.webView.navigationDelegate = self;
    self.webViewFrame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self loadWebView];
}

- (void)loadWebView{
    [self.webView loadURL_hasPostTest:[Const urlArcKey:js_main]];
    [self.view bringSubviewToFront:self.webView];
    if (_httpProxyView) {
        [self.view bringSubviewToFront:self.httpProxyView];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([js_startTask isEqualToString:message.name]){
        [self js_startTask:message];
    }else  if ([js_openUrl isEqualToString:message.name]){
        [self openUrl:message];
    }else  if ([js_openApp isEqualToString:message.name]){
        [self openApp:message];
    }
    else  if ([js_startTask isEqualToString:message.name]){
        [self js_startTask:message];
    }
    else  if ([js_finishTask isEqualToString:message.name]){
        [self js_finishTask:message];
    }
    else  if ([js_resetTask isEqualToString:message.name]){
        [self js_resetTask:message];
    }
    else  if ([js_net isEqualToString:message.name]){
        [self js_net:message];
    }
    else  if ([js_getPasteboard isEqualToString:message.name]){
        [self js_getPasteboard:message];
    }
    else  if ([js_setPasteboard isEqualToString:message.name]){
        [self js_setPasteboard:message];
    }
    else  if ([js_saveFullScreen isEqualToString:message.name]){
        [self js_saveFullScreen:message];
    }
    else  if ([js_saveQRUrlImage isEqualToString:message.name]){
        [self js_saveQRUrlImage:message];
    }
    else if ([js_share isEqualToString:message.name])
    {
        [self js_share:message];
    }else if ([js_wxLogin isEqualToString:message.name])
    {
        [self js_wxLogin:message];
    }
    else if ([js_curVer isEqualToString:message.name])
    {
        [self js_curVer:message];
    }
    else if ([js_netFull isEqualToString:message.name])
    {
        [self js_netFull:message];
    }
    else if ([js_veriDev isEqualToString:message.name])
    {
        [self js_veriDev:message];
    }
    else if ([js_service isEqualToString:message.name])
    {
        [self js_service:message];
    }
}

#pragma mark - 任务
- (void)js_service:(WKScriptMessage *)message{
    NSString *type = message.body[@"type"];
    type = [NSString stringWithFormat:@"%@",type];
    if ([type isEqualToString:@"1"]) {
        if ([UMShareHelper isQQInstalled]) {
            NSString *url = message.body[@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(1),@"msg":@""}];
        }else{
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(0),@"msg":@"QQ客户端未安装"}];
        }
    }else if([type isEqualToString:@"2"]){
        if ([UMShareHelper isWXInstalled]) {
            NSString *url = message.body[@"url"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(1),@"msg":@""}];
        }else{
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(0),@"msg":@"微信客户端未安装"}];
        }
    }
}

- (void)js_startTask:(WKScriptMessage *)message{ // type  0:未安装；1：打开目标app，返回YES；2：有任务正在进行中
    NSNumber *timeLimit = message.body[@"limit"];
    NSString *bid = message.body[@"bid"];
    NSDictionary *dic = [[DataSingleton sharedDataSingleton] getLocalData:g_taskTime];
    if ([GB_ToolUtils isNotBlank:dic]) {
        NSString *bid_loc = dic[@"bid"];
        if (bid_loc&&[bid_loc isEqualToString:bid]) {
            BOOL open = [Enc openAppWithNoEnc:bid];
            if (!open) {
                [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(0),@"msg":@"未安装"}];
                return;
            }
        }
        // 告诉js正在有任务进行中
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(2),@"msg":@"有任务正在进行"}];
        return;
    }
    
    BOOL open = [Enc openAppWithNoEnc:bid];
    if (!open) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(0),@"msg":@"未安装"}];
        return;
    }
    
    [[DataSingleton sharedDataSingleton] saveLocalData:g_taskTime value:@{@"bid":bid,@"timeLimit":timeLimit}];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(1),@"bid":bid,@"msg":@"任务完成"}];
}

- (void)js_finishTask:(WKScriptMessage *)message{ // type  0:当前没有任务进行；1：任务完成；2：任务未完成
    NSDictionary *dic = [[DataSingleton sharedDataSingleton] getLocalData:g_taskTime];
    if ([GB_ToolUtils isBlank:dic]) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(0),@"msg":@"当前没有任务进行"}];
        return;
    }
    NSString *bid = dic[@"bid"];
    if ([GB_ToolUtils isBlank:bid]) {
        bid = @"";
    }
    if (self.timeLimit.taskTimeOK) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(1),@"msg":@"任务完成",@"bid":bid}];
        [self.timeLimit taskReset];
    }else{
        NSString *time = [NSString stringWithFormat:@"任务未完成，剩余时间%lds",(long)self.timeLimit.CountDownTime];
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(2),@"msg":time,@"bid":bid}];
        [self alertWith:[NSString stringWithFormat:@"任务未完成，剩余时间%lds",(long)self.timeLimit.CountDownTime]];
    }
}

- (void)js_resetTask:(WKScriptMessage *)message{
    [self.timeLimit taskReset];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@1}];
}

- (void)js_veriDev:(WKScriptMessage *)message{
    self.VeriDevCallBack = message.body[@"callback"];
    NSString *url = message.body[@"url"];
    [Const setVeriDev];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


#pragma mark - H5请求
- (NSDictionary *)addUidWith:(NSDictionary *)param{
    NSMutableDictionary *dic;
    NSString *uid = [Const getUID];
    if ([GB_ToolUtils isNotBlank:uid]) {
         if (param!=nil && [param isKindOfClass:[NSDictionary class]]) {
        dic = [NSMutableDictionary dictionaryWithDictionary:param];
        [dic setObject:uid forKey:@"uid"];
             return dic;
         }else{
             param = @{@"uid":uid};return param;
         }
    }else{
        return param;
    }
}

- (void)js_net:(WKScriptMessage *)message{
    NSDictionary *parameter = [self addUidWith:message.body[@"param"]];
    NSString *path = message.body[@"path"];
    NSString *callback = message.body[@"callback"];
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,path];
    [self js_netWithURL:url parameter:parameter callback:callback];
}

- (void)js_netFull:(WKScriptMessage *)message{
    NSDictionary *parameter = [self addUidWith:message.body[@"param"]];
    NSString *path = message.body[@"path"];
    NSString *callback = message.body[@"callback"];
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:parameter];
    NSDictionary *dic = [DeviceParam deviceParam];
    [mut addEntriesFromDictionary:dic];
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain_full,path];
    [self js_netWithURL:url parameter:mut callback:callback];
}
- (void)js_curVer:(WKScriptMessage *)message{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"bid":bid,@"curVer":app_Version}];
}
- (void)js_wxLogin:(WKScriptMessage *)message{
    [WXLogin login:^(BOOL success, NSString *msg) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(success),@"msg":msg}];
    }];
}
- (void)js_share:(WKScriptMessage *)message{
    
    if (![self message_body:message]) {return;}
    // 分享参数
    NSString *title = message.body[@"title"];
    NSString *descr = message.body[@"content"];
    NSString *thumbURL = message.body[@"share_img"];//[NSString stringWithFormat:@"%@_40x40.jpg",message.body[@"share_img"]];
    NSString *webpageUrl = message.body[@"share_url"];
    NSString *type = message.body[@"type"];
    // 创建模型
    UMShareMode *model = [[UMShareMode alloc] init];
    if (title) {model.title = title;}
    if (descr) {model.descr = descr;}
    if (thumbURL) {model.thumbURL = thumbURL;}
    if (webpageUrl) {model.webpageUrl = webpageUrl;}
    [UMShareHelper shareMenu:self model:model type:[type intValue] block:^(BOOL success, NSString *msg) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(success),@"msg":msg}];
    }];
}

- (void)js_saveQRUrlImage:(WKScriptMessage *)message{
    [SaveImage saveImageAuth:^(bool agree) {
        dispatch_async(dispatch_get_main_queue(), ^{
        SaveImage *saveImage = [[SaveImage alloc] init];
        if (agree) {
            [saveImage saveUrlQRImage:message.body[@"url"] block:^(int type, NSString *msg) {
                [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(type),@"msg":msg}];
            }];
        }else{
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(0),@"msg":@""}];
        }
        });
    }];
}
- (void)js_saveFullScreen:(WKScriptMessage *)message{
    [SaveImage saveImageAuth:^(bool agree) {
        dispatch_async(dispatch_get_main_queue(), ^{
        SaveImage *saveImage = [[SaveImage alloc] init];
        if (agree) {
            [saveImage saveFullScreenWithView:self.webView block:^(int type, NSString *msg) {
                [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(type),@"msg":msg}];
            }];
        }else{
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(0),@"msg":@""}];
        }
        });
    }];
}

- (void)js_getPasteboard:(WKScriptMessage *)message{
    UIPasteboard *ob = [UIPasteboard generalPasteboard];
    NSString *str = ob.string == nil?@"":ob.string;
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"str":str}];
}
- (void)js_setPasteboard:(WKScriptMessage *)message{
    NSString *str = message.body[@"str"]!=nil?message.body[@"str"]:@"";
    str = [NSString stringWithFormat:@"%@",str];
    UIPasteboard *ob = [UIPasteboard generalPasteboard];
    ob.string = str;
    [THEvaluate evaluateTip:@"loandetail" WebView:self.webView method:message.body[@"callback"] dic:@{@"str":str}];
}

- (void)openApp:(WKScriptMessage *)message{
    NSString *str = message.body[@"str"];
    BOOL open = [Enc openAppWithNoEnc:str];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(open)}];
}
- (void)openUrl:(WKScriptMessage *)message{
    NSString *str = message.body[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(1)}];
}

#pragma mark - 网络请求
- (void)getKeysByServer{
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,API_getKeys];
    NSDictionary *dic  = [DeviceParam deviceParam];
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *deviceToken = [DataSingleton sharedDataSingleton].deviceToken;
    if ([GB_ToolUtils isBlank:deviceToken]) {deviceToken = @"";}
    NSString *uid = [Const getUID] != nil?[Const getUID]:@"";
    [mut setObject:deviceToken forKey:@"deviceToken"];
    [mut setObject:uid forKey:@"uid"];
    MBProgressHUD *hub = [MBProgressHUD bwm_showHUDAddedTo:self.navigationController.view title:nil];
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:mut WithHub: (MBProgressHUD *)hub WithReturnValeuBlock:^(NSDictionary *returnValue) {
        if (returnValue&&returnValue[@"code"]) {
            NSString *code = [NSString stringWithFormat:@"%@",returnValue[@"code"]];
            if ([code isEqualToString:@"200"]) {
                [Const deleteVeriDev];
                NSDictionary *additional = returnValue[@"additional"];
                if ([GB_ToolUtils isNotBlank:additional]) {
                    NSString *keys = additional[@"keys"];
                    NSString *uid = additional[@"uid"];
                    NSString *device_verification = [NSString stringWithFormat:@"%@",additional[@"device_verification"]] ;
                    // 保存
                    if ([GB_ToolUtils isNotBlank:keys]) {
                        [Const setKeys:keys];
                    }else{keys = @"";}
                    if ([GB_ToolUtils isNotBlank:uid]) {
                        [Const setupUID:uid];
                    }else{uid = @"";}
                    
                    if (self.VeriDevCallBack) {
                        [THEvaluate evaluateTip:@"" WebView:self.webView method:self.VeriDevCallBack dic:@{@"keys":keys,@"uid":uid,@"device_verification":device_verification}];
                        self.VeriDevCallBack = nil;
                    }
                }
            }else{
                [Const alertWith:s_Network_wrong];
            }
        }
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        
    } WithFailureBlock:^(NSString *errorMsg) {
        
    }];
}

- (void)activityPort{
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,API_activityPort];
    NSDictionary *dic  = [DeviceParam deviceParam];
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *deviceToken = [DataSingleton sharedDataSingleton].deviceToken;
    if ([GB_ToolUtils isBlank:deviceToken]) {deviceToken = @"";}
    [mut setObject:deviceToken forKey:@"deviceToken"];
    MBProgressHUD *hub = [MBProgressHUD bwm_showHUDAddedTo:self.navigationController.view title:nil];
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:mut WithHub: (MBProgressHUD *)hub WithReturnValeuBlock:^(NSDictionary *returnValue) {
        
        if (returnValue&&returnValue[@"code"]&&[returnValue[@"code"] isKindOfClass:[NSNumber class]]) {
            NSNumber *code = returnValue[@"code"];
            if ([code isEqualToNumber:@100]) {
                NSDictionary *additional = returnValue[@"additional"];
                if ([GB_ToolUtils isNotBlank:additional]) {
                    NSString *keys = additional[@"keys"];
                    NSString *uid = additional[@"uid"];
                    // 保存
                    if ([GB_ToolUtils isNotBlank:keys]) {
                        [Const setKeys:keys];
                    }
                    if ([GB_ToolUtils isNotBlank:uid]) {
                        [Const setupUID:uid];
                    }
                }
                [self setup];
                [Const setupS_is];
            }else if([code isEqualToNumber:@101]){
            }else if([code isEqualToNumber:@102]){
                NSDictionary *additional = returnValue[@"additional"];
                NSString *openUrl = additional[@"url"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:returnValue[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                    self.activityUrl = openUrl;
                     [self activityBtn];
                }];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [Const alertWith:s_Network_wrong];
            }
        }
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        
    } WithFailureBlock:^(NSString *errorMsg) {
        
    }];
}

- (void)js_netWithURL:(NSString *)url parameter:(NSDictionary *)parameter callback:(NSString *)callback{
    
    [NetRequestClass NetRequestPOSTWithH5RequestURL:url WithParameter:parameter WithReturnValeuBlock:^(NSDictionary *returnValue) {
        if (returnValue) {
            [THEvaluate evaluateTip:@"home" WebView:self.webView method:callback dic:returnValue];
            [self alertWith:[NSString stringWithFormat:@"%@",returnValue]];
        }
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:callback dic:@{@"code":@"-2"}];
    } WithFailureBlock:^(NSString *errorMsg) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:callback dic:@{@"code":@"-1"}];
    }];
}



- (void)alertWith:(NSString *)message{
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:nil];
    //    [alert addAction:sure];
    //    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)de_En:(NSString *)string
{
    for (int i = 0; i<[string length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        int newNum = [s characterAtIndex:0];
        if (newNum != 58) {
            if (newNum <69) {
                newNum = newNum+58;
            }
            if (newNum>96 && newNum<101) {
                newNum = newNum-7;
            }
            newNum = newNum - 4;
        }
        NSString *newStr = [NSString stringWithFormat:@"%c", newNum];
        NSRange range = NSMakeRange(i, 1);
        string =   [string stringByReplacingCharactersInRange:range withString:newStr];
    }
    return string;
}

#pragma mark - js call oc
- (NSString *)message_callback:(WKScriptMessage *)message{
    NSString *callback;
    if ([GB_ToolUtils isNotBlank:message] && [GB_ToolUtils isNotBlank:message.body] && [message.body isKindOfClass:[NSDictionary class]]) {
        callback = message.body[@"callback"];
    }
    return callback;
}
- (NSDictionary *)message_body:(WKScriptMessage *)message{
    NSDictionary *body;
    if ([GB_ToolUtils isNotBlank:message] && [GB_ToolUtils isNotBlank:message.body] && [message.body isKindOfClass:[NSDictionary class]]) {
        body = message.body;
    }
    return body;
}

- (void)callbackWithMessage:(WKScriptMessage *)message result:(id)result{
    // 防空
    NSString *callback = [self message_callback:message];
    if ([GB_ToolUtils isBlank:callback]) {return;}
    if ([GB_ToolUtils isBlank:result]) {result = @{};}
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:callback dic:result];
}


@end






















