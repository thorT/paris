//
//  DKADSetGDTSplashAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/20.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetSplashAdapter.h"

#import "GDTSplashAd.h"


@interface DKADSetGDTSplashAdapter : DKADSetSplashAdapter<GDTSplashAdDelegate>

@property (nonatomic, strong)GDTSplashAd *splash;

@end
