//
//  AppDelegate.m
//  laizXin
//
//  Created by thor on 2018/4/25.
//  Copyright © 2018年 riji. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "chain.h"
#import "DeviceParam.h"
#import "Const.h"
#import "UMShareHelper.h"
#import "JsonTool.h"
#import "BaseSetupSetting.h"
#import "UMMobClick/MobClick.h"
#import <Bugly/Bugly.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeViewController *home = [[HomeViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:home];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    // 初始化友盟分享
    [UMShareHelper initUMShare];
    // 友盟推送
    [self initJpush:launchOptions];
   // [UMPushHelper initUMPushWithOptions:launchOptions delegate:self];
    
    // 友盟统计
    [self setupMob];
    [Bugly startWithAppId:@"a853710521"];
    
    return YES;
}

- (void)initJpush:(NSDictionary *)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
     NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:@"fc6fc1f6108d660490a48ff3"
                          channel:@"app store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
}

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
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
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

    NSString *uid = [Const getUID];
    if ([GB_ToolUtils isBlank:uid]) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APIMain,API_addDeviceToken];
    NSDictionary *para = @{@"uid":uid,@"device_token":deviceToken};
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:para WithReturnValeuBlock:^(NSDictionary *returnValue) {
        
//        NSString *alert = [NSString stringWithFormat:@"接口=%@，参数=%@，返回参数=%@",url,[JsonTool jsonStrFrom:para],[JsonTool jsonStrFrom:returnValue]];
//        [Const alertWith:alert];
        
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
        
    } WithFailureBlock:^(NSString *errorMsg) {
        
    }];
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
        if (![type isKindOfClass:[NSString class]]||![type isEqualToString:@"activation"]) {
            return;
        }
    }else if([GB_ToolUtils isBlank:dic_url[@"type"]]){
        return;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@",APIMain,API_activityUrl];
    NSDictionary *dic  = [DeviceParam deviceParam];
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *sfuid = @"";
    if ([GB_ToolUtils isNotBlank:dic_url[@"sfuid"]]) {
        sfuid = dic_url[@"sfuid"];
    }
    [mut setObject:dic_url[@"sfuid"] forKey:@"sfuid"];
    [mut setObject:[Const bid] forKey:@"bid"];
    [mut setObject:@([UIScreen mainScreen].bounds.size.width) forKey:@"deviceW"];
    [mut setObject:@([UIScreen mainScreen].bounds.size.height) forKey:@"deviceH"];
    NSString *deviceToken = [DataSingleton sharedDataSingleton].deviceToken;
    if ([GB_ToolUtils isBlank:deviceToken]) {deviceToken = @"";}
    [mut setObject:deviceToken forKey:@"deviceToken"];
    // NSString *str1 = [JsonTool jsonStrFrom:mut];
    [BaseSetupSetting baseSetupSetting:^(BOOL vpn, BOOL proxy) {
        if (!vpn&&!proxy) {
             [self activitedNet:url parm:mut];
        }
    }];
}

- (void)activitedNet:(NSString *)url parm:(NSDictionary *)param{
   
    MBProgressHUD *hub = [MBProgressHUD bwm_showHUDAddedTo:self.window title:nil];
    [NetRequestClass NetRequestPOSTWithRequestURL:url WithParameter:param WithHub: (MBProgressHUD *)hub WithReturnValeuBlock:^(NSDictionary *returnValue) {
        if (returnValue) {
            NSString *code = [NSString stringWithFormat:@"%@",returnValue[@"code"]];
            if ([code isEqualToString:@"200"]) {
                if (![Const getS_is]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:s_activityUrl object:nil];
                }
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
            }else{
                [hub bwm_hideWithTitle:s_Network_wrong hideAfter:kHUDHideTimeInterval];
            }
        }
    } WithErrorCodeBlock:^(NSDictionary *errorCode) {
    } WithFailureBlock:^(NSString *errorMsg) {
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    
    completionHandler(0);
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    completionHandler();
}

@end
