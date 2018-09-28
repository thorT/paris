//
//  DKADSetGDTIntAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/20.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetInterstitialAdapter.h"

#import "GDTMobInterstitial.h"


@interface DKADSetGDTIntAdapter : DKADSetInterstitialAdapter<GDTMobInterstitialDelegate>

@property (nonatomic, strong)GDTMobInterstitial *interstitial;

@end
