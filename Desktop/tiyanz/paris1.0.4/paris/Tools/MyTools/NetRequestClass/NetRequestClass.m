//
//  NetRequestClass.m
//  xiaoxiaoQuan
//
//  Created by thor on 15/8/22.
//  Copyright (c) 2015年 thor. All rights reserved.
//

#import "NetRequestClass.h"
#import <AFNetworking/AFNetworking.h>
#import "DataSingleton.h"
#import "GB_ToolUtils.h"
#import "Global.h"
#import "JsonTool.h"
#import "Arc4random.h"
#import "NSString+AES.h"
#import "Const.h"
#import "NSHTTPCookie+utils.h"


@interface NetRequestClass()

@property (nonatomic, strong) AFHTTPSessionManager *manager_get;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) AFHTTPSessionManager *testManager;

@property (nonatomic, strong) AFHTTPSessionManager *downLoadmanager;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilitymanager;


@end


@implementation NetRequestClass

DEFINE_SINGLETON_FOR_CLASS(NetRequestClass)

#pragma mark - 设置全局变量，解决内存泄漏问题
//[NSSet setWithObject:@"text/html"];//
- (AFHTTPSessionManager *)manager{
    if (!_manager){
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = nil;
        //[self netWorkReachability];
    }
    return _manager;
}

- (AFHTTPSessionManager *)manager_get{
    if (!_manager_get) {
        _manager_get = [AFHTTPSessionManager manager];
        _manager_get.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager_get.responseSerializer.acceptableContentTypes = nil;
    }
    return _manager_get;
}

// 专门为激活接口使用
- (AFHTTPSessionManager *)testManager{
    if (!_testManager){
        _testManager = [AFHTTPSessionManager manager];
        [_testManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _testManager.requestSerializer.timeoutInterval = 10.f;
        [_testManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _testManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _testManager.responseSerializer.acceptableContentTypes = nil;// [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return _testManager;
}

- (AFHTTPSessionManager *)downLoadmanager{
    if (!_downLoadmanager){
        _downLoadmanager = [AFHTTPSessionManager manager];
    }
    return _downLoadmanager;
}

- (AFNetworkReachabilityManager *)reachabilitymanager{
    if(!_reachabilitymanager){
        _reachabilitymanager = [AFNetworkReachabilityManager sharedManager];
    }
    return _reachabilitymanager;
}
#pragma mark- 实时检测网络状态
-(void)netWorkReachability{
    [self.reachabilitymanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
         
        NSString *firstLaunch = [[DataSingleton sharedDataSingleton] getLocalData:g_firstLaunch];
        
        if ([GB_ToolUtils isNotBlank:firstLaunch] && status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络已断开" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else if([GB_ToolUtils isBlank:firstLaunch] && (status == AFNetworkReachabilityStatusReachableViaWWAN|| status == AFNetworkReachabilityStatusReachableViaWiFi)){
            [[NSNotificationCenter defaultCenter] postNotificationName:g_updateHome object:nil userInfo:nil];
            [[DataSingleton sharedDataSingleton] saveLocalData:g_firstLaunch value:@"1"];
        };
       
    }];
    [self.reachabilitymanager startMonitoring];
}

#pragma mark- 当前网络状态
+(int)netWorkStatus{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

// 网络是否异常
+(BOOL)netWorkStatusClear{
    int status = [NetRequestClass netWorkStatus];
    if (status == -1 || status == 0) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark- 实时检测网络状态
+(void)netWorkReachabilityWithURLString:(NSString *)urlStr netBlock:(NetBlock) netBlock{
    __block NSString *netState = @"";
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                netState = @"WWAN";
                netBlock(netState);
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                netState = @"WiFi";
                netBlock(netState);
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
                netState = @"无连接";
            case AFNetworkReachabilityStatusUnknown:
            {
                netState = @"无法识别";
                netBlock(netState);
                break;
            }
            default:
                netState = @"无法识别";
                netBlock(netState);
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 可以下面语句结束
    //[[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


#pragma --mark GET请求方式
+ (void)NetRequestGETWithRequestURL: (NSString *) requestURLString
                      WithParameter: (NSDictionary *) parameter
               WithReturnValeuBlock: (ReturnValueBlock) block
                 WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                   WithFailureBlock: (FailureBlock) failureBlock
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    requestURLString = [NSString stringWithFormat:@"%@?t=%@",requestURLString,timeSp];
    
    [[NetRequestClass sharedNetRequestClass].manager_get GET:requestURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        NSDictionary *dic;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dic = responseObject;
        }else if ([responseObject isKindOfClass:[NSData class]]){
            dic = [JsonTool jsonDicFrom:responseObject];
        }
        
        if ([GB_ToolUtils isBlank:dic]) {
            errorBlock(dic);
        }else{
            block(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error.localizedDescription);
    }];
}

#pragma --mark GET请求方式
+ (void)NetRequestGETWithRequestURL: (NSString *) requestURLString
                      WithParameter: (NSDictionary *) parameter
                      WithHub: (MBProgressHUD *) hub
               WithReturnValeuBlock: (ReturnValueBlock) block
                 WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                   WithFailureBlock: (FailureBlock) failureBlock
{
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
//    requestURLString = [NSString stringWithFormat:@"%@?t=%@",requestURLString,timeSp];
//
    NSLog(@"url=%@ parameter = %@",requestURLString,[JsonTool jsonStrFrom:parameter]);
    [[NetRequestClass sharedNetRequestClass].manager_get GET:requestURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        NSDictionary *dic;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dic = responseObject;
        }else if ([responseObject isKindOfClass:[NSData class]]){
            dic = [JsonTool jsonDicFrom:responseObject];
        }
        
        if ([GB_ToolUtils isBlank:dic]) {
            errorBlock(dic);
        }else{
            [hub bwm_hideAfter:kHUDHideTimefast];
            block(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error.localizedDescription);
    }];
}



#pragma --mark POST 不加密请求方式
+ (void)NetRequestNotEncryPOSTWithRequestURL: (NSString *) requestURLString
                               WithParameter: (NSDictionary *) parameter
                        WithReturnValeuBlock: (ReturnValueBlock) block
                          WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                            WithFailureBlock: (FailureBlock) failureBlock
{
    NSLog(@"url=%@ parameter = %@",requestURLString,[JsonTool jsonStrFrom:parameter]);
    [[NetRequestClass sharedNetRequestClass].manager POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dic = responseObject;
        }else if ([responseObject isKindOfClass:[NSData class]]){
            dic = [JsonTool jsonDicFrom:responseObject];
        }
       
        if ([GB_ToolUtils isNotBlank:dic]) {
            NSString *code = [Const stringValue:dic[@"code"]];
            if (![code isEqualToString:@"200"]) {
                NSLog(@"code=%@, msg = %@",code, dic[@"msg"])
            }
            
            block(dic);
        }else{
            NSDictionary *error = @{@"error":[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]};
            [Const alertWith:dic[@"msg"]];
            NSLog(@"error = %@",dic[@"msg"]);
            errorBlock(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString * str = [[NSString alloc]initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        NSLog(@"errorstr = %@",str);
        
        failureBlock(error.localizedDescription);
    }];
}

/** POST 测试接口 带hub */
+ (void)NetTestPOSTWithRequestURL: (NSString *) requestURLString
                               WithParameter: (NSDictionary *) parameter
                                     WithHub: (MBProgressHUD *)hub
                        WithReturnValeuBlock: (ReturnValueBlock) block
                          WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                            WithFailureBlock: (FailureBlock) failureBlock{
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [hub bwm_hideAfter:0];
        block(parameter);
    });
}

/** POST 不加密请求方式 带hub */
+ (void)NetRequestNotEncryPOSTWithRequestURL: (NSString *) requestURLString
                               WithParameter: (NSDictionary *) parameter
                                     WithHub: (MBProgressHUD *)hub
                        WithReturnValeuBlock: (ReturnValueBlock) block
                          WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                            WithFailureBlock: (FailureBlock) failureBlock{
//    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:parameter];
//    [tempDic setObject:@"2" forKey:@"msys"];
    NSLog(@"url=%@ parameter = %@",requestURLString,[JsonTool jsonStrFrom:parameter]);
    
    [[NetRequestClass sharedNetRequestClass].manager POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dic = responseObject;
        }else if ([responseObject isKindOfClass:[NSData class]]){
            dic = [JsonTool jsonDicFrom:responseObject];
        }
        NSString *dicstr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"dic=%@",dicstr);
        if ([GB_ToolUtils isNotBlank:dic]) {
            [hub bwm_hideAfter:0];
            block(dic);
        }else{
            NSDictionary *error = @{@"error":[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]};
             [hub bwm_hideAfter:0];
            NSLog(@"网络解析失败 error=%@",dic[@"msg"]);
            errorBlock(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.localizedDescription);
        [hub bwm_hideWithTitle:s_Network_abnormal hideAfter:kHUDHideTimefast];
        failureBlock(error.localizedDescription);
    }];
}


//
///** POST 加密请求方式 带hub */
//+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
//                        WithParameter: (NSDictionary *) parameter
//                              WithHub: (MBProgressHUD *) hub
//                 WithReturnValeuBlock: (ReturnValueBlock) block
//                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
//                     WithFailureBlock: (FailureBlock) failureBlock{
//    // 加密
//    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:parameter];
//    [tempDic setObject:@"2" forKey:@"msys"];
//    NSString *infoStr = [JsonTool jsonStrFrom:tempDic];
//    if (!infoStr) {
//        NSLog(@"parameter 不能转化为json字符串");
//        [hub bwm_hideWithTitle:s_Network_anomaly hideAfter:kHUDHideTimeInterval];
//        failureBlock(@"不能转化为json字符串");
//        return;block(dic);
//    }
//    long maxLong = 9999999997;
//    long passWord_random = [Arc4random getRandomNumber:1000000000 to:maxLong];
//    long passWord_random_add2 = passWord_random + 2;
//    EncryptAndDe *encryAndDe = [[EncryptAndDe alloc] init];
//    NSString *encry = [encryAndDe encry:infoStr passWord:[NSString stringWithFormat:@"%ld",(unsigned long)passWord_random]];
//    NSDictionary *param = @{@"secret":@(passWord_random_add2),@"content":encry};
//    // 设置头
//    //    NSDictionary *dictionary = @{@"UserAgent": @"Xiaoquan/1.0.1 (iPhone; iOS)"};
//    //    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
//    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    //    manager.responseSerializer.acceptableContentTypes = nil;
//    // manager.requestSerializer.timeoutInterval = 10.0;
//    [[NetRequestClass sharedNetRequestClass].manager POST:requestURLString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                // 测试
//                NSString *ceshi = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSLog(@"ceshi=%@",ceshi);
//
//        // 解密
//        NSDictionary *dic = [self encryRresponseObject:responseObject encryAndDe:encryAndDe];
//        // 清除hub
//
//
//        // 判断
//        NSNumber *status = dic[@"status"];
//        if (![GB_ToolUtils isBlank:dic]) {
//            NSLog(@"msg= %@",dic[@"msg"])
//        }
//
//        if ([GB_ToolUtils isBlank:dic] || [GB_ToolUtils isBlank:status]) {
//            NSLog(@"url = %@ ---------服务器错误-----------",requestURLString);
//            [hub bwm_hideWithTitle:s_Network_anomaly hideAfter:kHUDHideTimeInterval];
//            failureBlock(@"");
//        }else if([status isEqualToNumber:@(1)]){
//            block(dic);
//        }else if([status isEqualToNumber:@(401)]){
//            // 进入登录页，并清除本地数据
//            [THConst exitLogin];
//            LoginViewController *login = [[LoginViewController alloc] init];
//            THNavigationController *navi = [[THNavigationController alloc] initWithRootViewController:login];
//            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:navi animated:YES completion:nil];
//        }else if([status isEqualToNumber:@(402)]){
//            // 进入登录页，并清除本地数据
//            [THConst exitLogin];
//        }else{
//            NSLog(@"errorBlock == %@",dic);
//            NSLog(@"errorCode msg == %@",dic[@"msg"]);
//            [hub bwm_hideWithTitle:dic[@"msg"] hideAfter:kHUDHideTimeInterval];
//            errorBlock(dic);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error.localizedDescription);
//        [hub bwm_hideWithTitle:s_Network_anomaly hideAfter:kHUDHideTimeInterval];
//        failureBlock(error.localizedDescription);
//    }];
//
//}


#pragma --mark 加密 POST请求方式
+ (void)NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    // 加密
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [tempDic setObject:@"2" forKey:@"msys"];
    NSString *infoStr = [JsonTool jsonStrFrom:tempDic];
    if (!infoStr) {
        NSLog(@"parameter 不能转化为json字符串");
        failureBlock(@"不能转化为json字符串");
        return;
    }
    long maxLong = 9999999997;
    long passWord_random = [Arc4random getRandomNumber:1000000000 to:maxLong];
    long passWord_random_add2 = passWord_random + 2;
    NSString *encry = [infoStr aci_encryptWithKey:[NSString stringWithFormat:@"%ld",(unsigned long)passWord_random]];
    NSDictionary *param = @{@"secret":@(passWord_random_add2),@"content":encry};
    // 设置头
    //    NSDictionary *dictionary = @{@"UserAgent": @"Xiaoquan/1.0.1 (iPhone; iOS)"};
    //    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = nil;
    // manager.requestSerializer.timeoutInterval = 10.0;
    [[NetRequestClass sharedNetRequestClass].manager POST:requestURLString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        // 测试
        NSString *ceshi = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"ceshi=%@",ceshi);
        // 解密
        NSDictionary *dic =  [self encryRresponseObject:responseObject];
        
        if (dic) {
            block(dic);
        }else{
            NSDictionary *error = @{@"error":[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]};
            errorBlock(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.localizedDescription);
        failureBlock(error.localizedDescription);
    }];
}

/** POST 加密请求方式 带hub */
+ (void)NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                               WithParameter: (NSDictionary *) parameter
                                     WithHub: (MBProgressHUD *)hub
                        WithReturnValeuBlock: (ReturnValueBlock) block
                          WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                            WithFailureBlock: (FailureBlock) failureBlock{
    // 加密
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [tempDic setObject:@"2" forKey:@"msys"];
    NSString *infoStr = [JsonTool jsonStrFrom:tempDic];
    if (!infoStr) {
        NSLog(@"parameter 不能转化为json字符串");
        failureBlock(@"不能转化为json字符串");
        return;
    }
    long maxLong = 9999999997;
    long passWord_random = [Arc4random getRandomNumber:1000000000 to:maxLong];
    long passWord_random_add2 = passWord_random + 2;
    NSString *encry = [infoStr aci_encryptWithKey:[NSString stringWithFormat:@"%ld",(unsigned long)passWord_random]];
    NSDictionary *param = @{@"secret":@(passWord_random_add2),@"content":encry};
    [[NetRequestClass sharedNetRequestClass].manager POST:requestURLString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 解密
        NSDictionary *dic =  [self encryRresponseObject:responseObject];
        if (dic) {
            [hub hideAnimated:YES];
            block(dic);
        }else{
           // NSDictionary *error = @{@"error":[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]};
            errorBlock(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error.localizedDescription);
//        [hub bwm_hideWithTitle:s_Network_anomaly hideAfter:kHUDHideTimeInterval];
        failureBlock(error.localizedDescription);
    }];
}

#pragma mark - 接口解密
+ (NSDictionary *)encryRresponseObject:(id)responseObject {

    NSDictionary *dic;
    NSDictionary *responseDic;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        responseDic = responseObject;
    }else if([responseObject isKindOfClass:[NSData class]]){
        responseDic = [JsonTool jsonDicFrom:responseObject];
    }
    if ([GB_ToolUtils isNotBlank:responseDic] && [GB_ToolUtils isNotBlank:responseDic[@"secret"]]) {
        NSNumber *secretNum = responseDic[@"secret"];
        long long secret = [secretNum longLongValue];
        secret = secret -3;
        NSString *secretStr = [NSString stringWithFormat:@"%lld",secret];

        NSString *content = responseDic[@"content"];
        if ([GB_ToolUtils isNotBlank:content] && [content isKindOfClass:[NSString class]]) {
            NSString *de = [content aci_decryptWithKey:secretStr];
            // NSLog(@"de = %@",de);
            dic = [JsonTool dictionaryWithJsonString:de];
        }
    }
    NSLog(@"解密的dic = %@",dic);
    return dic;
}







@end






