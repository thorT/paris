//
//  DataSingleton.m
//  zhongzhuanzhan
//
//  Created by zhongzhuanzhan on 17-6-6.
//  Copyright (c) 2017年 zhongzhuanzhan. All rights reserved.
//

#import "DataSingleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


@implementation DataSingleton


+ (DataSingleton *)sharedDataSingleton
{
    static DataSingleton *sharedDataSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSingleton = [[self alloc] init];
    });
    return sharedDataSingleton;
}

- init {
    if ((self = [super init])) {
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
        
        //        self.address1 = [self getLocalData:kAddress1Key];
        //        self.address2 = [self getLocalData:kAddress2Key];
        //        self.address3 = [self getLocalData:kAddress3Key];
        //        NSArray * array=[self getLocalData:kAddressArrayKey];
        //        if (array && array.count>0) {
        //            self.addressArray= [NSMutableArray arrayWithArray:array];
        //        }else{
        //            self.addressArray= [NSMutableArray arrayWithCapacity:1];
        //        }
        
    }
    return self;
}

- (NSString *)dataFilePath:(NSString *)fileName{
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory =[[paths1 objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%i", user.userId]];
    NSString *documentsDirectory = [paths1 objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (id)getLocalData:(NSString * )key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)saveLocalData:(NSString *)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeLocalData:(NSString *) key {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (void)removeLocalFile:(NSString *) path {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSError *err;
    [defaultManager removeItemAtPath:path error:&err];
}

- (NSString *) timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat: @"yyyy-MM-dd-HH-mm-ss-zzz"];
    [formatter setDateFormat: @"yyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}





@end
