//
//  MisicPlayer.h
//  BgModel
//
//  Created by thor on 2018/6/21.
//  Copyright © 2018年 lety. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MisicPlayer : NSObject

+ (instancetype)sharedMisicPlayer;

- (void)play;
-(void)pause;


@end


