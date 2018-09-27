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
static NSString *APIMain  = @"http://www.dijiadijia.com/tyz/tapp/public/index.php?s=";
static NSString *API_app_download = @"https://t.dijiadijia.com/download/guider.html";

static NSString *API_user_gotoShare   =@"/user/gotoShare";
static NSString *APIWX_login        = @"bindWeChat";
static NSString *API_startApp   = @"startApp";
static NSString *API_userActivation    = @"userActivation";
static NSString *API_addDeviceToken = @"addDeviceToken";
static NSString *API_home        = @"home";


// 老旧的
static NSString *API_opening                  = @"opening";            // 开画页
static NSString *API_myincome                 = @"myincome";      // 我的收入
static NSString *API_user_getInvitationRecordList          = @"/user/getInvitationRecordList";      // 邀请记录
static NSString *API_withdraw                 = @"withdraw";      // 提现记录
static NSString *API_mymessage                = @"mymessage";      // 邀请记录




//提示语
static NSTimeInterval kHUDHideTimeInterval = 4.2f;
static NSTimeInterval kHUDHideTimefast = 0.0f;
static NSString *s_Network_abnormal          =  @"网络异常";
static NSString *s_Network_wrong           =  @"网络错误";
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

// 推送
static NSString *s_activityUrl            =  @"s_activityUrl";

#endif /* ServerAPI_h */
