//
//  HttpProxyView.h
//  paris
//
//  Created by thor on 2018/5/15.
//  Copyright © 2018年 paris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HttpProxyView : UIView

@property (nonatomic, assign) BOOL isVPN;

@property (nonatomic, assign) BOOL isHttpProxy;

- (void)isVPN:(BOOL)isVPN isHttpProxy:(BOOL)isHttpProxy;

@end
