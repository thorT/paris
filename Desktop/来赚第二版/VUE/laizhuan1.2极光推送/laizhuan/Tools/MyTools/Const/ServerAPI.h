//
//  ServerAPI.h
//  laigou
//
//  Created by thor on 2016/11/25.
//  Copyright © 2016年 thor. All rights reserved.
//

#ifndef ServerAPI_h
#define ServerAPI_h




// 服务器地址
// type: 2    --- iOS

//static NSString *APIMain  = @"http://116.62.133.217/laizhuan/laizhuan/index.php/";
//static NSString *APIMain_full  = @"http://116.62.133.217/newlaizhuan/laizhuan/index.php/";
//static NSString *APIMain_full2  = @"http://116.62.133.217/laizhuan/laizhuan/index.php/";
static NSString *APIWX_login        = @"bindWeChat";
static NSString *API_activityPort   = @"startApp";
static NSString *API_activityUrl    = @"userActivation";
static NSString *API_addDeviceToken = @"addDeviceToken";
static NSString *API_getKeys        = @"getKeys";
static NSString *API_addShareRecord = @"addShareRecord";


static NSString *APIMain  = @"http://106.15.157.173/laizhuan/laizhuan/index.php/";
static NSString *APIMain_full  = @"http://106.15.157.173/laizhuan/laizhuan/index.php/";



//提示语
static NSTimeInterval kHUDHideTimeInterval = 1.0f;
static NSTimeInterval kHUDHideTimefast = 0.0f;
static NSString *s_Network_abnormal          =  @"请求超时";
static NSString *s_Network_wrong             =  @"网络错误";
static NSString *s_Network_analysisWrong     =  @"网络解析错误";


static NSString *s_login_success             =  @"登录成功";
static NSString *s_wxauth_success             =  @"授权成功";
static NSString *s_wxbinding_success          =  @"绑定成功";
static NSString *s_verify_send             =  @"验证码已发送，请稍后...";
static NSString *s_regist_success            =  @"注册成功";
static NSString *s_modify_password_success   =  @"密码修改成功";
static NSString *s_loginout_success          =  @"已登出";
static NSString *s_notify_type_change         =  @"已成功变更";
static NSString *s_upload_success            =  @"上传成功";
static NSString *s_apply_success            =  @"已成功申请";
static NSString *s_is            =  @"s_is";
static NSString *s_activityUrl            =  @"s_activityUrl";




#endif /* ServerAPI_h */
