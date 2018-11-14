//
//  DataSingleton.h
//  zhongzhuanzhan
//
//  Created by zhongzhuanzhan on 17-6-6.
//  Copyright (c) 2017年 zhongzhuanzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSingleton : NSObject

@property (nonatomic, strong) NSString *str1;
@property (nonatomic, strong) NSString *str2;
@property (nonatomic, strong) NSString *str3;
@property (nonatomic, strong) NSString *str4;
@property (nonatomic, strong) NSString *str5;
@property (nonatomic, strong) NSString *str7;

@property (nonatomic, strong) NSString *deviceToken;



- (NSString *)dataFilePath:(NSString *)fileName;
- (id)getLocalData:(NSString * )key;
- (void)saveLocalData:(NSString *)key value:(id)value;
- (void)removeLocalData:(NSString *) key;
- (void)removeLocalFile:(NSString *) path;



+ (DataSingleton *)sharedDataSingleton;

@end
