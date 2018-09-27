//
//  AppDelegate.m
//  laizXin
//
//  Created by thor on 2018/4/25.
//  Copyright © 2018年 riji. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "HomeViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "DeviceParam.h"
#import "Const.h"
#import "UMShareHelper.h"
#import "UMPushHelper.h"
#import "UMessage.h"
#import "JsonTool.h"
#import "UMMobClick/MobClick.h"
#import "LocalPush.h"
#import "BaseSetupSetting.h"

#import "DKADSet.h"
#import "DKADSetInterstitialManager.h"

@interface AppDelegate ()<DKADSetSplashManagerDelegate>
@property (nonatomic, strong)DKADSetSplashManager *splashManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeViewController *home = [[HomeViewController alloc] init];
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:home];
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(64, 158, 255)];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    // 初始化友盟分享
    [UMShareHelper initUMShare];
    // 友盟推送
    [UMPushHelper initUMPushWithOptions:launchOptions delegate:self];
    
    // 友盟统计
    [self setupMob];
    // 本地推送
    [LocalPush setup:application];
    
    // 开屏广告
    [self showDk];
    return YES;
}

#pragma mark - 设置友盟
- (void)setupMob{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    // 开始
    UMConfigInstance.appKey = umAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark - 推送相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    //
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    // 保存到本地
    if ([GB_ToolUtils isNotBlank:token]) {
        [DataSingleton sharedDataSingleton].deviceToken = token ;
        [self addPushAssoc:token];
    }
}

- (void)addPushAssoc:(NSString *)deviceToken{
    if (![Const DataSHas:s_uid]) {
        return;
    }
    NSString *uid = [Const DataSGet:s_uid];
    NSString *url = [NSString stringWithFormat:@"%@%@",APIMain,API_addDeviceToken];
    [NetRequestClass NetRequestNotEncryPOSTWithRequestURL:url WithParameter:@{@"uid":uid,@"device_token":deviceToken} WithReturnValeuBlock:^(NSDictionary *returnValue) {
        NSLog(@"%@",[JsonTool jsonStrFrom:returnValue]);
        
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        NSLog(@"%@",[JsonTool jsonStrFrom:errorCode]);
    } WithFailureBlock:^(NSString *errorMsg) {
         NSLog(@"%@",[JsonTool jsonStrFrom:errorMsg]);
    }];
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    // 友盟推送
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        [UMPushHelper remoteNotification_activeWtihUserInfo:userInfo];
    //    }else{
    //        [UMPushHelper remoteNotification_backgroundWtihUserInfo:userInfo];
    //    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        // 处理userInfo
        //    [UMPushHelper remoteNotification_activeWtihUserInfo:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
        
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        // 处理userInfo
        //   [UMPushHelper remoteNotification_backgroundWtihUserInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}
// ios9 之前
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // 友盟分享
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    [self userActivation:[url absoluteString]];
    return YES;
}

// ios9 之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    // 友盟分享
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    [self userActivation:[url absoluteString]];
    
    return YES;
}

- (void)userActivation:(NSString *)str{
    NSDictionary *dic_url = [Const urlParam:str];
    if (!dic_url) {
        return;
    }
    if (dic_url[@"type"]) {
        NSString *type = dic_url[@"type"];
        if (![type isKindOfClass:[NSString class]]||![type isEqualToString:@"activity"]) {
            return;
        }
    }else if([GB_ToolUtils isBlank:dic_url[@"type"]]){
        return;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,API_userActivation];
    NSDictionary *dic  = [DeviceParam deviceParam];
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *sfuid = @"";
    if ([GB_ToolUtils isNotBlank:dic_url[@"uid"]]) {
        sfuid = dic_url[@"uid"];
    }
    [mut setObject:sfuid forKey:@"sfuid"];
//    [mut setObject:[Const appBid] forKey:@"bid"];
//    [mut setObject:@([UIScreen mainScreen].bounds.size.width) forKey:@"deviceW"];
//    [mut setObject:@([UIScreen mainScreen].bounds.size.height) forKey:@"deviceH"];
    NSString *deviceToken = [DataSingleton sharedDataSingleton].deviceToken;
    if ([GB_ToolUtils isBlank:deviceToken]) {deviceToken = @"";}
    [mut setObject:deviceToken forKey:@"deviceToken"];
    // NSString *str1 = [JsonTool jsonStrFrom:mut];
    [self activitedNet:url parm:mut];
   
}

- (void)activitedNet:(NSString *)url parm:(NSDictionary *)param{
    MBProgressHUD *hub = [MBProgressHUD bwm_showHUDAddedTo:self.window title:nil];
    [NetRequestClass NetRequestNotEncryPOSTWithRequestURL:url WithParameter:param WithHub: (MBProgressHUD *)hub WithReturnValeuBlock:^(NSDictionary *returnValue) {
        
        NSDictionary *data = returnValue[@"data"];
        if ([GB_ToolUtils isNotBlank:data]) {
            NSString *uid = data[@"uid"];
            if ([GB_ToolUtils isNotBlank:uid]) {
                [Const DataSSet:s_uid value:uid];
                [[NSNotificationCenter defaultCenter] postNotificationName:s_activityUrl object:nil];
            }
        }
        
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        [Const alertWith:@"网络解析错误"];
    } WithFailureBlock:^(NSString *errorMsg) {
        [Const alertWith:@"网络异常"];
    }];
}

- (void)showDk{
    [DKADSetLog setLogEnable:YES];
    // 开屏广告初始化方法
    self.splashManager = [[DKADSetSplashManager alloc] initWithPublishID:@"4df598095e131374a17f7a3e5bc1f644" adSpaceID:@"189926a0e835bcc902702fa9ff34a6c1"];
    // 开屏广告代理
    self.splashManager.delegate = self;
    //     加载并展示广
    [self.splashManager loadAdAndShow];
}
// 开屏广告展示成功
- (void)DKADSetSplashManagerSuccessPresentScreen:(id)splash{
    NSLog(@"%s开屏广告展示成功",__func__);
}
// 开屏广告展示失败
- (void)DKADSetSplashManagerFailPresentScreen:(id)splash withError:(id) error{
    NSLog(@"%s开屏广告展示失败 error: %@", __func__, error);
}
//开屏广告被点击
- (void)DKADSetSplashManagerDidClicked:(id)splash{
    NSLog(@"%s开屏广告被点击",__func__);
}
// 开屏广告展示结束
- (void)DKADSetSplashManagerDidDismissScreen:(id)splash{
    NSLog(@"%s开屏广告展示结束",__func__);
}


@end



















