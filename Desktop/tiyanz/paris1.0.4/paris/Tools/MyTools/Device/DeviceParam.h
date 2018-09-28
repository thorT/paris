//
//  WHDeviceParam.h
//  UZApp
//
//  Created by wuhao on 15/10/29.
//  Copyright © 2015年 APICloud. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^NetPermissionBlock) (NSInteger netState);

@interface DeviceParam : NSObject

@property (nonatomic, copy) void(^SaveImage)(bool agree,bool success);

  @property (nonatomic, copy) void(^txt_recode)(NSString *txt);

-(void)saveImage:(NSString *)str;

+(NSDictionary *)deviceParam;

-(void)txt_record_action:(NSString *)str;

+ (NSString*)getIPWithHostName:(const NSString*)hostName;


@end
