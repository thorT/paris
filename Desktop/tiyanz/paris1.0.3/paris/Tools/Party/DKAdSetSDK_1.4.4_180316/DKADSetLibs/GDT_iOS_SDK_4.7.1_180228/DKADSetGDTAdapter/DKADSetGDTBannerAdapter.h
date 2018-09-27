//
//  DKADSetGDTBannerAdapter.h
//  DKADSet
//
//  Created by liuzhiyi on 16/4/20.
//  Copyright © 2016年 liuzhiyi. All rights reserved.
//

#import "DKADSetBannerAdapter.h"
#import "GDTMobBannerView.h"

@interface DKADSetGDTBannerAdapter : DKADSetBannerAdapter<GDTMobBannerViewDelegate>
{
    GDTMobBannerView *bannerView;
}
@end
