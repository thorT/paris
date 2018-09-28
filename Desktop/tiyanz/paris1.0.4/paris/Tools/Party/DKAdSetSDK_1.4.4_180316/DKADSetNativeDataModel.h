//
//  DKADSetNativeDataModel.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/23.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DKADSetNativeDataModel : NSObject

/**
 *  标题
 */
@property (nonatomic, copy) NSString *nativeTitle;

/**
 *  图标链接
 */
@property (nonatomic, copy) NSString *nativeIconURLStr;

/**
 *  描述
 */
@property (nonatomic, copy) NSString *nativeDesc;

/**
 *  大图链接
 */
@property (nonatomic, copy) NSString *nativeMainImgURLStr;

/**
 *  品牌图链接
 */
@property (nonatomic, copy) NSString *nativeBrandURLStr;

/**
 *  广告标签图链接
 */
@property (nonatomic, copy) NSString *nativeAdTagURLStr;

@property (nonatomic, strong)id originData;


@property (nonatomic, copy) NSString *aid;

@end
