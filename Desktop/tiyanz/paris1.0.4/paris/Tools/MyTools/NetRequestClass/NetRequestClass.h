//
//  NetRequestClass.h
//  xiaoxiaoQuan
//
//  Created by thor on 15/8/22.
//  Copyright (c) 2015年 thor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+BWMExtension.h"


// 单例
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;


#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}


//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (NSDictionary *returnValue);
typedef void (^ErrorCodeBlock) (NSDictionary  *errorCode);
typedef void (^FailureBlock)(NSString *errorMsg);
typedef void (^NetWorkBlock)(BOOL netConnetState);
typedef void (^NetBlock) (NSString  *netState);

typedef void (^DownLoadProgress) (int progress);


@interface NetRequestClass : NSObject

#pragma mark- 当前网络状态

/* 检测网络状态 **/
-(void)netWorkReachability;

+(int)netWorkStatus;

// 网络是否异常
+(BOOL)netWorkStatusClear;

/**
 *  获取网络连接状态
 *
 *  @param urlStr 网络连接的url
 */
+(void)netWorkReachabilityWithURLString:(NSString *)urlStr netBlock:(NetBlock) netBlock;

/** POST 测试接口 带hub */
+ (void)NetTestPOSTWithRequestURL: (NSString *) requestURLString
                    WithParameter: (NSDictionary *) parameter
                          WithHub: (MBProgressHUD *)hub
             WithReturnValeuBlock: (ReturnValueBlock) block
               WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                 WithFailureBlock: (FailureBlock) failureBlock;
/** get 请求 */
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;
/** get 请求 带hub */
+ (void)NetRequestGETWithRequestURL: (NSString *) requestURLString
                      WithParameter: (NSDictionary *) parameter
                            WithHub: (MBProgressHUD *) hub
               WithReturnValeuBlock: (ReturnValueBlock) block
                 WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                   WithFailureBlock: (FailureBlock) failureBlock;
/** post 请求*/
+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;
/** POST 不加密请求方式 */
+ (void)NetRequestNotEncryPOSTWithRequestURL: (NSString *) requestURLString
                               WithParameter: (NSDictionary *) parameter
                        WithReturnValeuBlock: (ReturnValueBlock) block
                          WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                            WithFailureBlock: (FailureBlock) failureBlock;
/** POST 加密请求方式 带hub */
+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                              WithHub: (MBProgressHUD *) hub
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;

/** POST 不加密请求方式 带hub */
+ (void)NetRequestNotEncryPOSTWithRequestURL: (NSString *) requestURLString
                               WithParameter: (NSDictionary *) parameter
                                     WithHub: (MBProgressHUD *)hub
                        WithReturnValeuBlock: (ReturnValueBlock) block
                          WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                            WithFailureBlock: (FailureBlock) failureBlock;

/**下载 请求*/
+ (void)NetDownLoadWithRequestURL: (NSString *) requestURLString
                    WithParameter: (NSDictionary *) parameter
             WithDownLoadProgress:(DownLoadProgress)progress
             WithReturnValeuBlock: (ReturnValueBlock) block
               WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                 WithFailureBlock: (FailureBlock) failureBlock;
+ (NetRequestClass *)sharedNetRequestClass;

@end
