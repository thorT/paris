//
//  AuthBaseInfoController.m
//  xiongmaodai
//
//  Created by thor on 2017/8/10.
//  Copyright © 2017年 gone. All rights reserved.
//

#import "HomeViewController.h"
#import "XianwanVController.h"
#import <SafariServices/SafariServices.h>
#import "THEvaluate.h"
#import "Const.h"
#import "GB_ToolUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "DeviceParam.h"
#import "JsonTool.h"
#import "DataSingleton.h"
#import "Enc.h"
#import "TimeLimit.h"
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
//点开
#import "DKADSetBannerView.h"
#import "DKADSet.h"
// 工具
#import "MisicPlayer.h"
#import "SaveQRcode.h"



@interface HomeViewController ()<WKNavigationDelegate,DKADSetBannerViewDelegate>

@property (nonatomic, assign) BOOL taskTimeOK;
@property (nonatomic, strong) TimeLimit *timeLimit;
@property (nonatomic, assign) BOOL webLoaded;// webview 已经加载过了
@property (nonatomic, strong) SaveQRcode *saveQRcode;
@property (nonatomic, strong) NSString *VeriDevCallBack;//用户验证设备callback
@property (nonatomic, strong) NSString  *activityUrl;// 激活url

// 点开
@property (nonatomic, strong) DKADSetBannerView *banner;

@end

@implementation HomeViewController

- (SaveQRcode *)saveQRcode{
    if (!_saveQRcode) {
        _saveQRcode = [[SaveQRcode alloc] initWithFrame:CGRectMake(AdaptedWidth(50), AdaptedHeight(100), Screen_Width-AdaptedWidth(50)*2, Screen_Height)];
        [self.view addSubview:_saveQRcode];
    }
    return _saveQRcode;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    // 判定用户是否在验证设备
    if (self.VeriDevCallBack&&self.webView) {
        [self netHome];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(s_activityUrl) name:s_activityUrl object:nil];
    [self authPhotoInfo];
    
}
- (void)s_activityUrl{
    [self setup];
}

- (void)setup{
    if (self.webLoaded) {
        //   [self loadWebView];
        return;
    }
    self.webLoaded = YES;
    
    [self configWeb];
    // 监听任务
    self.timeLimit = [[TimeLimit alloc] init];
}

-(void)netWorkReachability{
    // 是否已经存在uid
    BOOL hasUid = [Const DataSHas:s_uid];
    if (hasUid) {
        [self setup];
    }
    // 为保护用户隐私，如果用户不同意访问网络，就不访问网络
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if((status == AFNetworkReachabilityStatusReachableViaWWAN|| status == AFNetworkReachabilityStatusReachableViaWiFi)){
            NSString *firstLaunch = [Const DataSGet:@"firstlaunch"];
            if ([GB_ToolUtils isBlank:firstLaunch]||!hasUid) {
                // 请求接口
                [self startApp];
                [Const DataSSet:@"firstlaunch" value:@"firstlaunch"];
            }
        }else if(status != AFNetworkReachabilityStatusReachableViaWWAN && status != AFNetworkReachabilityStatusReachableViaWiFi){
            // 保存用户并没有联网的状态
            [Const alertWith:@"网络未连接，请至☞“手机设置”中打开app网络"];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 正式
- (void)configWeb{
    //  [[MisicPlayer sharedMisicPlayer] play];
    
    // 监听
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_openApp];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_openUrl];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_wkWeb];
    //客服
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_service];
    //    // 任务
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_safari];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_taskTime];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_startTask];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_finishTask];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_resetTask];
    //    // 本地
        [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_veriDev];
    //    // 网络
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_net];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_netFull];
    //    // 剪贴板
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_getPasteboard];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_setPasteboard];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_localData];
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_saveData];
    //    // 保存图片到本地
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_saveQRUrlImage];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_saveFullScreen];
    //
    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_share];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_wxLogin];
    //    [self.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:js_curVer];
    //
    //
    self.webView.navigationDelegate = self;
    self.webViewFrame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self loadWebView];
}

- (void)loadWebView{
    [self.webView loadURL_hasPostTest:[Const urlArcKey:js_main]];
    [self.view bringSubviewToFront:self.webView];
    //    if (_httpProxyView) {
    //        [self.view bringSubviewToFront:self.httpProxyView];
    //    }
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
#pragma mark - 任务
- (void)js_saveData:(WKScriptMessage *)message{
    NSDictionary *dic = [Const DataSGet:js_localData];
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    if ([GB_ToolUtils isNotBlank:dic]) {
        [mut addEntriesFromDictionary:dic];
    }
    NSDictionary *parm = message.body[@"param"];
    if ([GB_ToolUtils isNotBlank:parm]) {
        [mut addEntriesFromDictionary:parm];
    }
    [Const DataSSet:js_localData value:mut];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"code":@(1),@"param":mut}];
}
- (void)js_localData:(WKScriptMessage *)message{
    NSDictionary *param = [DeviceParam deviceParam];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(1),@"param":param}];
}
- (void)js_service:(WKScriptMessage *)message{
    NSDictionary *param = message.body[@"param"];
    if ([GB_ToolUtils isBlank:param]) {
        return;
    }
    NSString *type = [NSString stringWithFormat:@"%@",param[@"type"]];
    if ([type isEqualToString:@"1"]) {
        if ([UMShareHelper isQQInstalled]) {
            NSString *url = param[@"url"];
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

- (void)js_safari:(WKScriptMessage *)message{
    NSDictionary *param = message.body[@"param"];
    if ([GB_ToolUtils isBlank:param]||[GB_ToolUtils isBlank:param[@"url"]]) {
        return;
    }
    NSString *is_dk = [NSString stringWithFormat:@"%@",param[@"is_dk"]];
    NSString *path = param[@"url"];
    path = [path stringByReplacingOccurrencesOfString:@"[userid]" withString:[Const DataSGet:s_uid]];
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:path]];
    
    Weakify(self);
    [self presentViewController:safari animated:YES completion:^{
        if ([GB_ToolUtils isNotBlank:is_dk]&&[is_dk isEqualToString:@"1"]) {
            Strongify(weakSelf);
            safari.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-(Screen_Width/6.4));
            strongSelf.banner = [[DKADSetBannerView alloc] initWithPublishID:@"4df598095e131374a17f7a3e5bc1f644" adSpaceID:@"760b928084ee6e8a6b0b5dfe145b8fef" frame:CGRectMake(0, Screen_Height-(Screen_Width/6.4), Screen_Width, Screen_Width/6.4)];
            strongSelf.banner.controller = safari;
            strongSelf.banner.delegate = strongSelf;
            [strongSelf.banner loadAdAndShow];
            [safari.view addSubview:strongSelf.banner];
        }
    }];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@1,@"msg":@""}];
}
- (void)js_wkWeb:(WKScriptMessage *)message{
    NSDictionary *param = message.body[@"param"];
    if ([GB_ToolUtils isBlank:param]||[GB_ToolUtils isBlank:param[@"url"]]) {
        return;
    }
    NSString *path = param[@"url"];
    NSString *title = param[@"title"];
    XianwanVController *xianwan = [[XianwanVController alloc] init];
    xianwan.webUrl = path;
    if ([GB_ToolUtils isNotBlank:title]) {
        xianwan.titleText = title;
    }
    [self.navigationController pushViewController:xianwan animated:YES];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@1,@"msg":@""}];
}

//
//- (void)js_startTask:(WKScriptMessage *)message{ // type  0:未安装；1：打开目标app，返回YES；2：有任务正在进行中
//    NSNumber *timeLimit = message.body[@"limit"];
//    NSString *bid = message.body[@"bid"];
//    NSDictionary *dic = [[DataSingleton sharedDataSingleton] getLocalData:g_taskTime];
//    if ([GB_ToolUtils isNotBlank:dic]) {
//        NSString *bid_loc = dic[@"bid"];
//        if (bid_loc&&[bid_loc isEqualToString:bid]) {
//            BOOL open = [Enc openAppWithNoEnc:bid];
//            if (!open) {
//                [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(0),@"msg":@"未安装"}];
//                return;
//            }
//        }
//        // 告诉js正在有任务进行中
//        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(2),@"msg":@"有任务正在进行"}];
//        return;
//    }
//
//    BOOL open = [Enc openAppWithNoEnc:bid];
//    if (!open) {
//        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(0),@"msg":@"未安装"}];
//        return;
//    }
//
//    [[DataSingleton sharedDataSingleton] saveLocalData:g_taskTime value:@{@"bid":bid,@"timeLimit":timeLimit}];
//    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(1),@"bid":bid,@"msg":@"任务完成"}];
//}
//
//- (void)js_finishTask:(WKScriptMessage *)message{ // type  0:当前没有任务进行；1：任务完成；2：任务未完成
//    NSDictionary *dic = [[DataSingleton sharedDataSingleton] getLocalData:g_taskTime];
//    if ([GB_ToolUtils isBlank:dic]) {
//        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(0),@"msg":@"当前没有任务进行"}];
//        return;
//    }
//    if (self.timeLimit.taskTimeOK) {
//        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(1),@"msg":@"任务完成"}];
//        [self.timeLimit taskReset];
//    }else{
//        NSString *time = [NSString stringWithFormat:@"任务未完成，剩余时间%lds",(long)self.timeLimit.CountDownTime];
//        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"type":@(2),@"msg":time}];
//        [self alertWith:[NSString stringWithFormat:@"任务未完成，剩余时间%lds",(long)self.timeLimit.CountDownTime]];
//    }
//}
//- (void)js_resetTask:(WKScriptMessage *)message{
//    [self.timeLimit taskReset];
//    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@1}];
//}

- (void)openApp:(WKScriptMessage *)message{
    NSString *str = message.body[@"str"];
    BOOL open = [Enc openAppWithNoEnc:str];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(open)}];
}
- (void)js_openUrl:(WKScriptMessage *)message{
    NSString *str = message.body[@"param"][@"url"];
    if ([GB_ToolUtils isBlank:str]) {return;}

    NSLog(@"str = %@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(1)}];
}


//
- (void)js_veriDev:(WKScriptMessage *)message{
    self.VeriDevCallBack = message.body[@"callback"];
    NSDictionary *param = message.body[@"param"];
    NSString *url = param[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
//
//
//
- (void)js_net:(WKScriptMessage *)message{
    NSDictionary *parameter = [self addUidWith:message.body[@"param"]];
    NSString *path = message.body[@"path"];
    NSString *callback = message.body[@"callback"];
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,path];
    [self js_netWithURL:url parameter:parameter callback:callback];
}
- (NSDictionary *)addUidWith:(NSDictionary *)param{
    NSMutableDictionary *dic;
    NSString *uid = [Const DataSGet:s_uid];
    if ([GB_ToolUtils isNotBlank:uid]) {
        if (param!=nil && [param isKindOfClass:[NSDictionary class]]) {
            dic = [NSMutableDictionary dictionaryWithDictionary:param];
            [dic setObject:uid forKey:@"uid"];
            return dic;
        }else{param = @{@"uid":uid};return param;}
    }else{return param;}
}
- (void)js_netFull:(WKScriptMessage *)message{
    NSString *path = message.body[@"path"];
    NSString *callback = message.body[@"callback"];
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    NSDictionary *dic = [DeviceParam deviceParam];
    [mut addEntriesFromDictionary:dic];
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,path];
    [self js_netWithURL:url parameter:mut callback:callback];
}
//- (void)js_curVer:(WKScriptMessage *)message{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
//    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"bid":bid,@"curVer":app_Version}];
//}
//- (void)js_wxLogin:(WKScriptMessage *)message{
//    [WXLogin login:^(BOOL success, NSString *msg) {
//        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(success),@"msg":msg}];
//    }];
//}
- (void)js_share:(WKScriptMessage *)message{
    
    if (![self message_body:message]) {return;}
    NSDictionary *param = message.body[@"param"];
    if ([GB_ToolUtils isBlank:param]&&![param isKindOfClass:[NSDictionary class]]) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(0),@"msg":@"分享失败"}];
        return;
    }
    // 分享参数
    NSString *title = param[@"title"];
    NSString *descr = param[@"content"];
    NSString *thumbURL = param[@"share_img"];//[NSString stringWithFormat:@"%@_40x40.jpg",message.body[@"share_img"]];
    NSString *webpageUrl = param[@"share_url"];
    
    // 创建模型
    UMShareMode *model = [[UMShareMode alloc] init];
    if (title) {model.title = title;}
    if (descr) {model.descr = descr;}
    if (thumbURL) {model.thumbURL = thumbURL;}
    if (webpageUrl) {model.webpageUrl = webpageUrl;}
    
    [UMShareHelper shareMenu:self model:model block:^(BOOL success, NSString *msg) {
        [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"success":@(success),@"msg":msg}];
    }];
}
//
//- (void)js_saveQRUrlImage:(WKScriptMessage *)message{
//    [SaveImage saveImageAuth:^(bool agree) {
//        SaveImage *saveImage = [[SaveImage alloc] init];
//        if (agree) {
//            [saveImage saveUrlQRImage:message.body[@"url"] block:^(int type, NSString *msg) {
//                [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(type),@"msg":msg}];
//            }];
//        }else{
//            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(0),@"msg":@""}];
//        }
//    }];
//}
//- (void)js_saveFullScreen:(WKScriptMessage *)message{
//    [SaveImage saveImageAuth:^(bool agree) {
//        SaveImage *saveImage = [[SaveImage alloc] init];
//        if (agree) {
//            [saveImage saveFullScreenWithView:self.webView block:^(int type, NSString *msg) {
//                [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(type),@"msg":msg}];
//            }];
//        }else{
//            [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"agree":@(agree),@"success":@(0),@"msg":@""}];
//        }
//    }];
//}
//
- (void)js_getPasteboard:(WKScriptMessage *)message{
    UIPasteboard *ob = [UIPasteboard generalPasteboard];
    NSString *str = ob.string == nil?@"":ob.string;
    [THEvaluate evaluateTip:@"home" WebView:self.webView method:message.body[@"callback"] dic:@{@"str":str}];
}
- (void)js_setPasteboard:(WKScriptMessage *)message{
    NSString *str = message.body[@"param"][@"str"]!=nil?message.body[@"param"][@"str"]:@"";
    UIPasteboard *ob = [UIPasteboard generalPasteboard];
    ob.string = str;
    [THEvaluate evaluateTip:@"loandetail" WebView:self.webView method:message.body[@"callback"] dic:@{@"str":str}];
}



#pragma mark - 网络请求
- (void)netHome{
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,API_home];
    NSDictionary *dic = [DeviceParam deviceParam];
    MBProgressHUD *hub = [MBProgressHUD bwm_showHUDAddedTo:self.navigationController.view title:nil];
    [NetRequestClass NetRequestNotEncryPOSTWithRequestURL:url WithParameter:dic WithHub: (MBProgressHUD *)hub WithReturnValeuBlock:^(NSDictionary *returnValue) {
        
        NSString *code = [Const stringValue:returnValue[@"code"]];
        if ([GB_ToolUtils isNotBlank:code]) {
            if ([code isEqualToString:@"200"]) {
                [THEvaluate evaluateTip:@"home" WebView:self.webView method:self.VeriDevCallBack dic:returnValue];
                self.VeriDevCallBack = nil;
            }else{
                [Const alertWith:s_Network_wrong];
            }
        }
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        
    } WithFailureBlock:^(NSString *errorMsg) {
        
    }];
}
- (void)startApp{
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,API_startApp];
    NSDictionary *dic = [DeviceParam deviceParam];
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *deviceToken = [DataSingleton sharedDataSingleton].deviceToken;
    if ([GB_ToolUtils isBlank:deviceToken]) {deviceToken = @"";}
    [mut setObject:deviceToken forKey:@"deviceToken"];
    MBProgressHUD *hub = [MBProgressHUD bwm_showHUDAddedTo:self.navigationController.view title:nil];
    [NetRequestClass NetRequestNotEncryPOSTWithRequestURL:url WithParameter:mut WithHub: (MBProgressHUD *)hub WithReturnValeuBlock:^(NSDictionary *returnValue) {
        
        NSString *code = [Const stringValue:returnValue[@"code"]];
        if ([GB_ToolUtils isNotBlank:code]) {
            if ([code isEqualToString:@"200"]) {
                NSDictionary *additional = returnValue[@"data"];
                if ([GB_ToolUtils isNotBlank:additional]) {
                    NSString *uid = additional[@"uid"];
                    if ([GB_ToolUtils isNotBlank:uid]) {
                        [Const DataSSet:s_uid value:uid];
                    }
                }
                [self setup];
            }else if([code isEqualToString:@"102"]){
                NSDictionary *data = returnValue[@"data"];
                NSString *openUrl = data[@"url"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:returnValue[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self.activityUrl = openUrl;
                    [self activityBtn:NO];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
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
    
    [NetRequestClass NetRequestNotEncryPOSTWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(NSDictionary *returnValue) {
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

//- (NSString *)de_En:(NSString *)string
//{
//    for (int i = 0; i<[string length]; i++) {
//        //截取字符串中的每一个字符
//        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
//
//        int newNum = [s characterAtIndex:0];
//        if (newNum != 58) {
//            if (newNum <69) {
//                newNum = newNum+58;
//            }
//            if (newNum>96 && newNum<101) {
//                newNum = newNum-7;
//            }
//            newNum = newNum - 4;
//        }
//        NSString *newStr = [NSString stringWithFormat:@"%c", newNum];
//        NSRange range = NSMakeRange(i, 1);
//        string =   [string stringByReplacingCharactersInRange:range withString:newStr];
//    }
//    return string;
//}
//
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

#pragma mark - 相册认证逻辑
- (void)authPhotoInfo{
    NSString *firstLaunch = [Const DataSGet:@"firstlaunch"];
    if ([GB_ToolUtils isBlank:firstLaunch]) {
        Weakify(self);
        weakSelf.saveQRcode.agree=^(int agree){
            Strongify(weakSelf);
            [strongSelf variPLID];
            strongSelf.saveQRcode.hidden = YES;
        };
    }else{
        [self variPLID];
    }
}
- (void)variPLID{
    [Enc requestPhoto:^(BOOL agree) {
        if (agree) {
            NSString *plid = [Enc aid]!=nil?[Enc aid]:@"";
            dispatch_async(dispatch_get_main_queue(), ^{
                [DataSingleton sharedDataSingleton].plid = plid;
                [self netWorkReachability];
            });
        }else{
            [self activityBtn:YES];
            [Const alertWith:@"请允许app访问相册" vc:self];
        }
    }];
}

- (void)activityBtn:(BOOL)isSaveQR{
    int tag;
    NSString *title;
    if (isSaveQR) {
        title = @"重新加载";
        tag = 100;
    }else{
        title = @"前往激活";
        tag = 101;
    }
    
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = tag;
    btn.frame = CGRectMake(Screen_Width/2-AdaptedWidth(180)/2, Screen_Height/2-AdaptedHeight(35)/2, AdaptedWidth(180), AdaptedHeight(35));
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = AdaptedFontSize(16);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = g_theme;
    btn.layer.cornerRadius = AdaptedHeight(35)/2;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(activitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    if (isSaveQR) {
        
    }
}
- (void)activitAction:(UIButton *)btn{
    if (btn.tag == 100) {
        [self variPLID];
        return;
    }
    if ([GB_ToolUtils isNotBlank:self.activityUrl]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.activityUrl]];
    }
}


@end






















