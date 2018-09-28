//
//  test.m
//  priviteTest
//
//  Created by kittens on 17/9/29.
//  Copyright © 2017年 kittens. All rights reserved.
//

#import "Enc.h"
#import <Photos/Photos.h>
#import "DataSingleton.h"


@implementation Enc


/** 是否同意 */
+ (void)requestPhoto:(AIDStatusBlock)agree{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusAuthorized) {
            agree(YES);
        }else{
            agree(NO);
        }
    }];
}


+ (int)authorizationStatus{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status;
}

+ (NSString *)aid{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized){
        return nil;
    };
    DataSingleton *dh = [DataSingleton sharedDataSingleton];
    
    NSString *aid;
    Class class = NSClassFromString([self de_En:@"TPTlsxsPmfvevC"]);
    SEL share = NSSelectorFromString([self de_En:@"wlevihTlsxsPmfvevC"]);
    
    id k = [class performSelector:share];
    SEL managed = NSSelectorFromString([self de_En:@"qerekihSfnigxGsrxiBxWxsviYYMH"]);
    if ([k respondsToSelector:managed]) {
        aid = [k performSelector:managed];
    }
    return aid;
}


//+ (NSString *)aid{
//
//    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//    if (status != PHAuthorizationStatusAuthorized){
//        return nil;
//    };
//    DataSingleton *dh = [DataSingleton sharedDataSingleton];
//
//    NSString *aid;
//    Class class = NSClassFromString([self de_En:dh.str1]);
//    SEL share = NSSelectorFromString([self de_En:dh.str2]);
//
//    id k = [class performSelector:share];
//    SEL managed = NSSelectorFromString([self de_En:dh.str3]);
//    if ([k respondsToSelector:managed]) {
//        aid = [k performSelector:managed];
//    }
//    return aid;
//}

+ (BOOL)openApp:(NSString *)string{
    bool isOpen = NO;
    NSObject *main;
    DataSingleton *dh = [DataSingleton sharedDataSingleton];
    NSString *mainStr = [self de_En:dh.str4];
    Class main_class = NSClassFromString(mainStr);
    main  = [main_class performSelector:NSSelectorFromString([self de_En:dh.str5])];
    
    if ([main respondsToSelector:NSSelectorFromString([self de_En:dh.str7])]) {
        isOpen = [main performSelector:NSSelectorFromString([self de_En:dh.str7]) withObject:string];
        // 如果在ios 7 以下，默认能打开
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
        {
            return YES;
        }
        if (isOpen) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

+ (BOOL)openAppWithNoEnc:(NSString *)string{
    bool isOpen = NO;
    NSObject *main;
    NSString *mainStr = [self de_En:@"PWEttpmgexmsrbsvowtegi"];
    Class main_class = NSClassFromString(mainStr);
    main  = [main_class performSelector:NSSelectorFromString([self de_En:@"hijeypxbsvowtegi"])];
    
    if ([main respondsToSelector:NSSelectorFromString([self de_En:@"stirEttpmgexmsrbmxlFyrhpiMH:"])]) {
        isOpen = [main performSelector:NSSelectorFromString([self de_En:@"stirEttpmgexmsrbmxlFyrhpiMH:"]) withObject:string];
        // 如果在ios 7 以下，默认能打开
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
        {
            return YES;
        }
        if (isOpen) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

+ (NSString *)de_En:(NSString *)string
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


@end

