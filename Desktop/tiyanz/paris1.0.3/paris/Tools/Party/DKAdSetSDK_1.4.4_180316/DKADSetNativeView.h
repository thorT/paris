//
//  DKADSetNativeView.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/27.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKADSetNativeDataModel.h"
#import "DKADSetNativeAdapter.h"

@class DKADSetNativeView;

@protocol DKADSetNativeViewDelegate <NSObject>

- (void)DKADSetNativeViewClickedWithDKADSetNativeView:(DKADSetNativeView *)view model:(DKADSetNativeDataModel *)model;

@end

@interface DKADSetNativeView : UIView
@property (nonatomic, weak)id<DKADSetNativeViewDelegate> DKADSetNativeViewDelegate;
@property (nonatomic, strong)DKADSetNativeDataModel *model;

/**
 *  标题
 */
@property (nonatomic, strong)UILabel *titleLabel;
/**
 *  描述
 */
@property (nonatomic, strong)UILabel *textLabel;

@property (nonatomic, assign)CGRect iconIVFrame;

@property (nonatomic, assign)CGRect mainIVFrame;

@property (nonatomic, assign)CGRect platformIVFrame;

@property (nonatomic, assign)CGRect adLogoIVFrame;

@property (nonatomic, strong)DKADSetNativeAdapter *nativeAdapter;


- (void)adSetNativeViewPackaged;

@end
